CREATE TABLE FORNECEDOR (
	COD_FORNECEDOR SERIAL PRIMARY KEY,
	NOME_FORNECEDOR VARCHAR(50),
	ENDERECO_FORNECEDOR VARCHAR(100)
)

CREATE TABLE TITULO (
	COD_TITULO SERIAL PRIMARY KEY,
	DESCR_TITULO VARCHAR(100)
) 

CREATE TABLE LIVRO (
	COD_LIVRO SERIAL PRIMARY KEY,
	COD_TITULO SERIAL,
	FOREIGN KEY(COD_TITULO) REFERENCES TITULO(COD_TITULO),
	QUANT_ESTOQUE INT,
	VALOR_UNITARIO FLOAT
)

CREATE TABLE PEDIDO (
	COD_PEDIDO SERIAL,
	COD_FORNECEDOR INT,
	DATA_PEDIDO DATE,
	QUANTIDADE_PEDIDOS INT DEFAULT 0,
	HORA_PEDIDO TIMESTAMP,
	VALOR_TOTAL_PEDIDO FLOAT
)

CREATE TABLE ITEM_PEDIDO (
	COD_LIVRO SERIAL,
	COD_PEDIDO SERIAL,
	QUANTIDADE_ITEM INT,
	VALOR_TOTAL_ITEM FLOAT
)

CREATE OR REPLACE FUNCTION INSERIR_RESTRICOES()
RETURNS TRIGGER AS $$
BEGIN 

IF NEW.COD_FORNECEDOR IS NULL OR 
NEW.DATA_PEDIDO IS NULL OR 
NEW.HORA_PEDIDO IS NULL OR 
NEW.VALOR_TOTAL_PEDIDO IS NULL THEN
	RAISE EXCEPTION 'Valores obrugatórios devem ser inseridos';
END IF;

IF NOT EXISTS (
	SELECT 1 FROM FORNECEDOR WHERE COD_FORNECEDOR = NEW.COD_FORNECEDOR
) THEN 
	RAISE EXCEPTION 'Código fornecedor deve ser informado';
END IF;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;


	
CREATE TRIGGER RESTRICOES 
BEFORE INSERT ON PEDIDO 
FOR EACH ROW EXECUTE PROCEDURE INSERIR_RESTRICOES()

-- 2) Responda as questões a seguir:
-- a) Mostre o nome dos fornecedores que venderam mais de X reais no mês de fevereiro de
-- 2024.
SELECT F.NOME_FORNECEDOR, SUM(IP.VALOR_TOTAL_ITEM) AS TOTAL_VENDIDO 
FROM FORNECEDOR F
JOIN PEDIDO P ON F.COD_FORNECEDOR = P.COD_FORNECEDOR 
JOIN ITEM_PEDIDO IP ON P.COD_PEDIDO = IP.COD_PEDIDO
WHERE P.DATA_PEDIDO BETWEEN '2024-02-01' AND '2024-02-29'
GROUP BY F.NOME_FORNECEDOR
HAVING SUM(IP.VALOR_TOTAL_ITEM) > 1000;


-- b) Mostre o nome de um dos fornecedores que mais vendeu no mês de fevereiro de 2024.
SELECT f.nome_fornenecdor, SUM(ip.valor_total_item) AS total_vendido
FROM fornecedor f
JOIN pedido p ON f.cod_fornecedor = p.cod_fornecedor
JOIN item_pedido ip ON p.cod_pedido = ip.cod_pedido
WHERE p.data_pedido BETWEEN '2024-02-01' AND '2024-02-29'
GROUP BY f.nome_fornenecdor
ORDER BY total_vendido DESC
LIMIT 1;

-- c) Qual o nome do(s) fornecedor(es) que mais vendeu(eram) no mês de fevereiro de 2024?
WITH vendas AS (
  SELECT f.nome_fornenecdor, SUM(ip.valor_total_item) AS total_vendido
  FROM fornecedor f
  JOIN pedido p ON f.cod_fornecedor = p.cod_fornecedor
  JOIN item_pedido ip ON p.cod_pedido = ip.cod_pedido
  WHERE p.data_pedido BETWEEN '2024-02-01' AND '2024-02-29'
  GROUP BY f.nome_fornenecdor
)
SELECT nome_fornenecdor, total_vendido
FROM vendas
WHERE total_vendido = (SELECT MAX(total_vendido) FROM vendas);

-- 3) Usando trigger, responda as questões a seguir.
-- a) Crie triggers que implementem todas essas restrições de chave primária, chave estrangeira
-- e valores não nulos nas tabelas Pedido e Item_pedido.
CREATE OR REPLACE FUNCTION INSERIR_RESTRICOES()
RETURNS TRIGGER AS $$
BEGIN 

IF NEW.COD_FORNECEDOR IS NULL OR 
NEW.DATA_PEDIDO IS NULL OR 
NEW.HORA_PEDIDO IS NULL OR 
NEW.VALOR_TOTAL_PEDIDO IS NULL THEN
	RAISE EXCEPTION 'Valores obrigatórios devem ser inseridos';
END IF;

IF NOT EXISTS (
	SELECT 1 FROM FORNECEDOR WHERE COD_FORNECEDOR = NEW.COD_FORNECEDOR
) THEN 
	RAISE EXCEPTION 'Código fornecedor deve ser informado';
END IF;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;
	
CREATE TRIGGER RESTRICOES 
BEFORE INSERT ON PEDIDO 
FOR EACH ROW EXECUTE PROCEDURE INSERIR_RESTRICOES()

-- b) Crie um trigger na tabela Livro que não permita quantidade em estoque negativa e sempre
-- que a quantidade em estoque atingir 10 ou menos unidades, um aviso de quantidade mínima
-- deve ser emitido ao usuário (para emitir alertas sem interromper a execução da transação,
-- você pode usar "raise notice" ou "raise info").
CREATE OR REPLACE FUNCTION INSERIR_RESTRICOES_LIVRO()
RETURNS TRIGGER AS $$
BEGIN

IF NEW.QUANT_ESTOQUE < 0 THEN
	RAISE EXCEPTION 'Não é permitido quantidades negativas de estoque';
END IF;

IF NEW.QUANT_ESTOQUE > 0 AND NEW.QUANT_ESTOQUE <= 10 THEN
	RAISE NOTICE 'A quantidade mínima desse produto em estoque foi atingida.';

END IF;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER RESTRICOES_LIVRO
BEFORE INSERT ON LIVRO
FOR EACH ROW EXECUTE PROCEDURE INSERIR_RESTRICOES_LIVRO();

INSERT INTO livro (cod_titulo, quant_estoque) VALUES (1, -5);
INSERT INTO livro (cod_titulo, quant_estoque) VALUES (2, 7);

-- c) Crie um trigger que sempre que houver inserções, remoções ou alterações na tabela
-- "Item_pedido", haja a atualização da "quant_itens_pedidos" e do "valor_total_pedido" da
-- tabela "pedido", bem como a atualização da quantidade em estoque da tabela Livro.
CREATE OR REPLACE FUNCTION TRIGGER_ITEM_PEDIDO()
RETURNS TRIGGER AS $$
BEGIN

	IF TG_OP = 'DELETE' THEN
	UPDATE LIVRO
	SET QUANT_ESTOQUE = QUANT_ESTOQUE - NEW.QUANT_ITEM
	WHERE COD_LIVRO = NEW.COD_LIVRO;

	UPDATE PEDIDO
	SET
		QUANTIDADE_ITEM = QUANTIDADE_ITEM + NEW.QUANTIDADE_ITEM,
		

	ELSIF TG_OP = 'DELETE' THEN
	UPDATE LIVRO
	SET QUANT_ESTOQUE = QUANT_ESTOQUE + OLD.QUANT_ITEM
	WHERE COD_LIVRO = OLD.COD_LIVRO;

	ELSIF TG_OP = 'UPDATE' THEN
	UPDATE LIVRO
	SET QUANT_ESTOQUE = QUANT_ESTOQUE + OLD.QUANT_ITEM - NEW.QUANT_ITEM
	WHERE COD_LIVRO = NEW.COD_LIVRO
	END IF;

	UPDATE PEDIDO
	SET
		QUANT_ITENS_PEDIDOS = ()