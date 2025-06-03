CREATE TABLE ALUNO (
	ID SERIAL PRIMARY KEY,
	MATRICULA INT,
	NOME VARCHAR(100)
); 


CREATE TABLE FUNCIONARIO (
	CODIGO INT PRIMARY KEY,
	NOME VARCHAR(30),
	SALARIO INT,
	DATA_ULTIMA_ATUALIZACAO TIMESTAMP 
)

CREATE TABLE EMPREGADO (
	NOME VARCHAR(100),
	SALARIO FLOAT
)

CREATE TABLE EMPREGADO2 (
	CODIGO SERIAL PRIMARY KEY,
	NOME VARCHAR(30),
	SALARIO FLOAT
)

CREATE TABLE EMPREGADO_AUDITORIA (
	OPERACAO CHAR(1),
	USUARIO VARCHAR(30),
	DATA TIMESTAMP,
	NOME VARCHAR(30),
	SALARIO FLOAT
)

CREATE TABLE EMPREGADO2_AUDIT (
	USUARIO VARCHAR(30),
	DATA TIMESTAMP,
	ID INT,
	COLUNA TEXT,
	VALOR_ANTIGO TEXT,
	VALOR_NOVO TEXT
)

-- 1. Crie uma tabela aluno com as colunas matrícula e nome.
-- Depois crie um trigger que não permita o cadastro de alunos
-- cujo nome começa com a letra “a”.

CREATE OR REPLACE FUNCTION FUNC_TEST()
RETURNS TRIGGER
AS $$
BEGIN
IF NEW.NOME ILIKE 'A%' THEN
RAISE EXCEPTION 'Não é permitido cadastro começado com A';
END IF;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL

CREATE TRIGGER BLOQUEIO 
BEFORE INSERT OR UPDATE ON ALUNO 
FOR EACH ROW EXECUTE PROCEDURE FUNC_TEST()

INSERT INTO ALUNO VALUES(1, 01, 'JOSE')
INSERT INTO ALUNO VALUES(2, 02, 'ALANDA')


-- 2. Crie uma tabela chamada Funcionário com os
-- seguintes campos: código (int), nome (varchar(30)), salário
-- (int), data_última_atualização (timestamp),
-- usuário_que_atualizou (varchar(30)). Na inserção desta
-- tabela, você deve informar apenas o código, nome e salário do
-- funcionário. Agora crie um Trigger que não permita o nome
-- nulo, a salário nulo e nem negativo. Faça testes que
-- comprovem o funcionamento do Trigger. 

INSERT INTO FUNCIONARIO(CODIGO, NOME,SALARIO) VALUES(1, 'Enzo', 3100)

CREATE OR REPLACE FUNCTION FUNC_FUNCIONARIO() 
RETURNS TRIGGER
AS $$ 
BEGIN
IF NEW.NOME IS NULL THEN
	RAISE EXCEPTION 'Não é permitido nome nulo.';
ELSEIF NEW.SALARIO IS NULL THEN
	RAISE EXCEPTION 'Não é permitido salario nulo.';
ELSEIF NEW.SALARIO < 0 THEN
	RAISE EXCEPTION 'Não é permitido salario nulo.';
END IF;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL

CREATE TRIGGER NULOS 
BEFORE INSERT OR UPDATE ON FUNCIONARIO 
FOR EACH ROW EXECUTE PROCEDURE FUNC_FUNCIONARIO()

INSERT INTO FUNCIONARIO (CODIGO, NOME, SALARIO) VALUES(1,NULL,NULL)


-- 3. Crie uma tabela chamada Empregado com os atributos
-- nome e salário. Crie também outra tabela chamada
-- Empregado_auditoria com os atributos: operação (char(1)),
-- usuário (varchar), data (timestamp), nome (varchar), salário
-- (integer) . Agora crie um trigger que registre na tabela
-- Empregado_auditoria a modificação que foi feita na tabela
-- empregado (E,A,I), quem fez a modificação, a data da
-- modificação, o nome do empregado que foi alterado e o salário
-- atual dele.

CREATE OR REPLACE FUNCTION REGISTRO_EMPREGADO()
RETURNS TRIGGER
AS $$
BEGIN 
IF (TG_OP = 'INSERT') THEN
	INSERT INTO EMPREGADO_AUDITORIA 
	VALUES ('I', SESSION_USER, CURRENT_TIMESTAMP, NEW.NOME, NEW.SALARIO);
ELSEIF (TP_OP = 'UPDATE') THEN
	INSERT INTO EMPREGADO_AUDITORIA
	VALUES ('A', SESSION_USER, CURRENT_TIMESTAMP, NEW.NOME, NEW.SALARIO);
ELSEIF (TG_OP = 'DELETE') THEN
	INSERT INTO EMPREGADDO_AUDITORIA
	VALUES ('D', SESSION_USER, CURRENT_TIMESTAMP, OLD.NOME,OLD.SALARIO);
END IF;
RETURN NULL;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER MODIFICA
AFTER INSERT OR UPDATE OR DELETE ON EMPREGADO
FOR EACH ROW EXECUTE PROCEDURE REGISTRO_EMPREGADO()

--  4. Crie a tabela Empregado2 com os atributos código (serial e
-- chave primária), nome (varchar) e salário (integer). Crie
-- também a tabela Empregado2_audit com os seguintes
-- atributos: usuário (varchar), data (timestamp), id (integer),
-- coluna (text), valor_antigo (text), valor_novo(text). Agora crie
-- um trigger que não permita a alteração da chave primária e
-- insira registros na tabela Empregado2_audit para refletir as
-- alterações realizadas na tabela Empregado2.

CREATE OR REPLACE FUNCTION INSERIR_EMPREGADO2()
RETURNS TRIGGER
AS $$
BEGIN
IF NEW.CODIGO <> OLD.CODIGO THEN
	RAISE EXCEPTION 'Não é possível mudanças no código.';
END IF;
IF NEW.NOME IS DISTINCT FROM OLD.NOME THEN
	INSERT INTO EMPREGADO2_AUDIT
	VALUES (SESSION_USER, CURRENT_TIMESTAMP, OLD.CODIGO, OLD.NOME, 'nomeExemplo', NEW.NOME);
END IF;
IF NEW.SALARIO IS DISTINCT FROM OLD.SALARIO THEN
	INSERT INTO EMPREGADO2_AUDIT
	VALUES (SESSION_USER, CURRENT_TIMESTAMP, OLD.CODIGO,'salaroExemplo', OLD.SALARIO::TEXT, NEW.SALARIO::TEXT);
END IF;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER TRG_EMPREGADO2
BEFORE UPDATE ON EMPREGADO2
FOR EACH ROW EXECUTE PROCEDURE INSERIR_EMPREGADO2()