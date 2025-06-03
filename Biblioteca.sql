CREATE TABLE LEITOR (
	COD_LEITOR SERIAL PRIMARY KEY,
	NOME VARCHAR(30) NOT NULL,
	DT_NASC DATE NOT NULL
);

INSERT INTO LEITOR (NOME, DT_NASC) VALUES
('joão', '1995-04-10'),
('maria', '1997-08-25'),
('carlos', '2005-12-01'); -- mais jovem


CREATE TABLE FUNCIONARIO (
	COD_FUNC SERIAL PRIMARY KEY,
	NOME VARCHAR(30) NOT NULL
);

INSERT INTO FUNCIONARIO (NOME) VALUES
('josé'),
('antônio'),
('cláudia');


CREATE TABLE TITULO (
	COD_TIT SERIAL PRIMARY KEY,
	NOME VARCHAR(30) NOT NULL
);

INSERT INTO TITULO (NOME) VALUES
('fundamentos de banco de dados'),
('algoritmos em c'),
('estrutura de dados'),
('sistemas distribuídos');


CREATE TABLE LIVRO (
	COD_LIVRO SERIAL PRIMARY KEY,
	COD_TIT INT NOT NULL REFERENCES TITULO(COD_TIT),
	VALOR_MULTA_DIA FLOAT
);

-- Títulos já criados de 1 a 4
INSERT INTO LIVRO (COD_TIT, VALOR_MULTA_DIA) VALUES
(1, 1.5),
(2, 2.0),
(3, 1.0),
(4, 2.5);


CREATE TABLE AUTOR (
	COD_AUTOR SERIAL PRIMARY KEY,
	NOME VARCHAR(30) NOT NULL
);

INSERT INTO AUTOR (NOME) VALUES
('ana silva'),
('bruno lima'),
('carla dias'),
('daniel costa');


CREATE TABLE AUTORIA (
	COD_AUTORIA SERIAL PRIMARY KEY,
	COD_AUTOR INT NOT NULL REFERENCES AUTOR(COD_AUTOR),
	COD_TIT INT NOT NULL REFERENCES TITULO(COD_TIT)
);

-- Ana escreveu o título 1 e 2
INSERT INTO AUTORIA (COD_AUTOR, COD_TIT) VALUES
(1, 1),
(1, 2),
-- Bruno escreveu o título 3
(2, 3),
-- Carla escreveu o título 2 e 4
(3, 2),
(3, 4),
-- Daniel escreveu o título 4
(4, 4);


CREATE TABLE EMPRESTIMO (
	COD_EMP SERIAL PRIMARY KEY,
	COD_LEITOR INT NOT NULL REFERENCES LEITOR(COD_LEITOR),
	COD_FUNC INT NOT NULL REFERENCES FUNCIONARIO(COD_FUNC),
	COD_LIVRO INT NOT NULL REFERENCES LIVRO(COD_LIVRO),
	DT_PREV_DEV DATE,
	DT_DEV DATE
);

-- João pegou o livro 1 (Fundamentos) com José
INSERT INTO EMPRESTIMO (COD_LEITOR, COD_FUNC, COD_LIVRO, DT_PREV_DEV, DT_DEV) VALUES
(1, 1, 1, '2024-03-01', '2024-03-05'),
-- João também pegou o livro 2 com outro funcionário (Cláudia)
(1, 3, 2, '2024-03-01', '2024-03-06'),
-- Carlos (mais jovem) reservou o livro 3, mas não emprestou nada
-- Maria não fez empréstimos (só reservas)
(3, 2, 3, '2024-03-02', '2024-03-10');


CREATE TABLE RESERVA (
	COD_RES SERIAL PRIMARY KEY,
	COD_LEITOR INT NOT NULL REFERENCES LEITOR(COD_LEITOR),
	COD_FUNC INT NOT NULL REFERENCES FUNCIONARIO(COD_FUNC),
	COD_TIT INT NOT NULL REFERENCES TITULO(COD_TIT)
);

-- Maria reservou título 1 e 2 com Antônio
INSERT INTO RESERVA (COD_LEITOR, COD_FUNC, COD_TIT) VALUES
(2, 2, 1),
(2, 2, 2),
-- Carlos (leitor mais jovem) reservou título 3 e 4
(3, 1, 3),
(3, 3, 4);

-- 2.1 O nome dos títulos dos livros emprestados para o leitor João pelo funcionário José, 
-- OU os reservados para a leitora Maria pelo funcionário Antônio.
SELECT TIT.NOME FROM TITULO TIT
JOIN LIVRO L ON TIT.COD_TIT = L.COD_TIT
JOIN EMPRESTIMO E ON L.COD_LIVRO = E.COD_LIVRO
JOIN FUNCIONARIO F ON F.COD_FUNC = E.COD_FUNC
JOIN RESERVA R ON R.COD_TIT = TIT.COD_TIT AND R.COD_FUNC = F.COD_FUNC AND R.COD_LEITOR = LT.COD_LEITOR
JOIN LEITOR LT ON LT.COD_LEITOR = R.COD_LEITOR
WHERE (LT.NOME ILIKE 'João%' AND F.NOME ILIKE 'José%')
OR (LT.NOME ILIKE 'Maria%' AND F.NOME ILIKE 'Antônio%');

-- 2.2 O nome dos autores que escreveram títulos reservados pela leitora Maria, 
-- mas que nunca foram reservados pelo leitor mais jovem.
SELECT A.NOME FROM AUTOR A
JOIN AUTORIA AUT ON AUT.COD_AUTOR = A.COD_AUTOR
JOIN TITULO TIT  ON TIT.COD_TITULO = AUT.COD_TITULO
JOIN RESERVA R ON R.COD_TIT = TIT.COD_TIT
JOIN LEITOR LT ON LT.COD_LEITOR = R.COD_LEITOR



-- 2.3 Para cada código e nome de leitor, o valor total pago em multas. 
-- Considere que a data de devolução (DT_DEV) é sempre maior ou igual à data prevista (DT_PREV_DEV). 
-- Mostre apenas os leitores com valor total maior que zero.
SELECT LT.COD_LEITOR, LT.NOME, SUM((DT_DEV - DT_PREV_DEV) * L.VALOR_MULTA_DIA) 
FROM LEITOR LT
JOIN EMPRESTIMO E ON E.COD_LEITOR = LT.COD_LEITOR
JOIN LIVRO L ON L.COD_LIVRO = E.COD_LIVRO
GROUP BY LT.COD_LEITOR, LT.NOME
HAVING SUM((DT_DEV - DT_PREV_DEV) * L.VALOR_MULTA_DIA) > 0;


-- 2.4 O nome dos autores com a quantidade de títulos que escreveram. Caso o autor não tenha escrito nenhum título, 
-- o valor deve ser zero.
SELECT A.NOME, COUNT(AT.COD_TIT) FROM AUTOR A
LEFT JOIN AUTORIA AT ON A.COD_AUTOR = AT.COD_AUTOR
GROUP BY A.NOME,A.COD_AUTOR;


-- 2.5 O nome dos títulos que nunca foram reservados e nem emprestados
SELECT T.NOME FROM TITULO T
LEFT JOIN LIVRO L ON L.COD_TIT = T.COD_TIT
LEFT JOIN EMPRESTIMO E ON E.COD_LIVRO = L.COD_LIVRO
LEFT JOIN RESERVA R ON R.COD_TIT = T.COD_TIT
WHERE R.COD_RES IS NULL AND E.COD_EMP IS NULL
GROUP BY T.COD_TIT, T.NOME;

-- 2.6 O nome dos leitores que reservaram todos os títulos cadastrados na biblioteca.
SELECT L.NOME FROM LEITOR L
JOIN RESERVA R ON R.COD_LEITOR = L.COD_LEITOR
GROUP BY L.COD_LEITOR, L.NOME
HAVING COUNT(DISTINCT R.COD_TIT) = (SELECT COUNT(*) FROM TITULO);

