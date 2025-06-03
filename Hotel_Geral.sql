CREATE TABLE CATEGORIA 
(COD_CAT SERIAL PRIMARY KEY, NOME VARCHAR(100), PRECO INT, DESCRICAO TEXT);
INSERT INTO CATEGORIA (NOME, PRECO, DESCRICAO) 
VALUES ('LUXO', 300, 'PARA RICOS');
INSERT INTO CATEGORIA (NOME, PRECO, DESCRICAO) 
VALUES ('DUBLE', 200, 'PARA DUBLES');
INSERT INTO CATEGORIA (NOME, PRECO, DESCRICAO) 
VALUES ('MEDIO', 150, 'CLASSE MEDIA');
INSERT INTO CATEGORIA (NOME, PRECO, DESCRICAO) 
VALUES ('POBRE', 100, 'PARA POBRES');

CREATE TABLE APARTAMENTO 
(NUM_AP SERIAL PRIMARY KEY, COD_CAT INT,
FOREIGN KEY (COD_CAT) REFERENCES CATEGORIA(COD_CAT));
INSERT INTO APARTAMENTO (COD_CAT)
VALUES (1);
INSERT INTO APARTAMENTO (COD_CAT)
VALUES (2);
INSERT INTO APARTAMENTO (COD_CAT)
VALUES (3);
INSERT INTO APARTAMENTO (COD_CAT)
VALUES (4);

CREATE TABLE HOSPEDAGEM 
(COD_HOSPEDAGEM SERIAL PRIMARY KEY, NUM_AP INT, COD_HOSP INT, COD_FUNC INT, DT_ENT DATE, DT_SAIDA DATE,
FOREIGN KEY (NUM_AP) REFERENCES APARTAMENTO(NUM_AP),
FOREIGN KEY (COD_HOSP) REFERENCES HOSPEDE(COD_HOSP),
FOREIGN KEY (COD_FUNC) REFERENCES FUNCIONARIO(COD_FUNC));
INSERT INTO HOSPEDAGEM (NUM_AP, COD_HOSP, COD_FUNC, DT_ENT, DT_SAIDA)
VALUES (1, 1, 1, '2025-1-1', '2025-1-2');
INSERT INTO HOSPEDAGEM (NUM_AP, COD_HOSP, COD_FUNC, DT_ENT, DT_SAIDA)
VALUES (2, 2, 2, '2025-1-1', '2025-1-3');
INSERT INTO HOSPEDAGEM (NUM_AP, COD_HOSP, COD_FUNC, DT_ENT, DT_SAIDA)
VALUES (3, 3, 3, '2025-1-1', '2025-1-4');
INSERT INTO HOSPEDAGEM (NUM_AP, COD_HOSP, COD_FUNC, DT_ENT, DT_SAIDA)
VALUES (4, 4, 4, '2025-1-1', NULL);

CREATE TABLE HOSPEDE 
(COD_HOSP SERIAL PRIMARY KEY, NOME VARCHAR(100), DT_NASC DATE);
INSERT INTO HOSPEDE (NOME, DT_NASC)
VALUES ('CHICO', '2005-1-6');
INSERT INTO HOSPEDE (NOME, DT_NASC)
VALUES ('JOAO', '1967-3-20');
INSERT INTO HOSPEDE (NOME, DT_NASC)
VALUES ('DONA ANGELA', '1972-12-8');
INSERT INTO HOSPEDE (NOME, DT_NASC)
VALUES ('CHICA', '2005-7-10');

CREATE TABLE FUNCIONARIO (COD_FUNC SERIAL PRIMARY KEY, NOME VARCHAR(100), DT_NASC DATE);
INSERT INTO FUNCIONARIO (NOME, DT_NASC)
VALUES ('RABICO', '1960-10-5');
INSERT INTO FUNCIONARIO (NOME, DT_NASC)
VALUES ('ADOLFO', '2000-3-20');
INSERT INTO FUNCIONARIO (NOME, DT_NASC)
VALUES ('RITA', '2000-5-29');
INSERT INTO FUNCIONARIO (NOME, DT_NASC)
VALUES ('CLEITON', '1980-3-20');

-- CREATE TABLE RESERVA
-- (COD_RES INT SERIAL PRIMARY KEY, NUM_AP INT, COD_HOSP INT, COD_FUNC INT, DATA_RES DATE, DT_ENT, DT_SAI, 
-- FOREIGN KEY (NUM_AP) REFERENCES APARTAMENTO(NUM_AP),
-- FOREIGN KEY (COD_HOSP) REFERENCES HOSPEDE(COD_HOSP),
-- FOREIGN KEY (COD_FUNC) REFERENCES FUNCIONARIO(COD_FUNC),
-- )

ALTER TABLE HOSPEDE 
ADD COLUMN NAC VARCHAR (100);
UPDATE HOSPEDE
SET NAC = 'ANGOLANO'
WHERE NOME = 'CHICO';
UPDATE HOSPEDE 
SET NAC = 'BRASILEIRO'
WHERE NOME = 'JOAO';
UPDATE HOSPEDE 
SET NAC = 'URUGUAIA'
WHERE NOME = 'DONA ANGELA';
UPDATE HOSPEDE
SET NAC = 'MEXICANA'
WHERE NOME = 'CHICA';

UPDATE CATEGORIA 
SET PRECO = PRECO * 1.10;

-- ========================== LISTA 1 ==========================

-- 1. Nomes das categorias que possuam preços entre R$ 100,00 e R$ 200,00.
SELECT NOME FROM CATEGORIA
WHERE PRECO BETWEEN 100 AND 200;

-- 2. Nomes das categorias cujos nomes possuam a palavra ‘Luxo’.
SELECT NOME FROM CATEGORIA
WHERE NOME ILIKE 'Luxo%';

-- 3. Número dos apartamentos que estão ocupados, ou seja, a data de saída está vazia.
SELECT A.NUM_AP FROM APARTAMENTO A
JOIN HOSPEDAGEM H ON H.NUM_AP = A.NUM_AP
WHERE H.DT_SAIDA = NULL;

-- 4. Número dos apartamentos cuja categoria tenha código 1, 2, 3, 11, 34, 54, 24, 12.
SELECT NUM_AP FROM APARTAMENTO A
WHERE COD_CAT IN (1,2,3,11,12,24,34,54);

-- 5. Todas as informações dos apartamentos cujas categorias iniciam com a palavra ‘Luxo’.
SELECT A.* FROM APARTAMENTO A
JOIN CATEGORIA C ON C.COD_CAT = A.COD_CAT
WHERE C.NOME ILIKE 'Luxo%';

-- 6. Quantidade de apartamentos cadastrados no sistema.
SELECT COUNT(NUM_AP) FROM APARTAMENTO;

-- 7. Somatório dos preços das categorias.
SELECT SUM(PRECO) FROM CATEGORIA;

-- 8. Média de preços das categorias.
SELECT AVG(PRECO) FROM CATEGORIA;
-- 9. Maior preço de categoria.
SELECT MAX(PRECO) FROM CATEGORIA;
 
-- 10. Menor preço de categoria.
SELECT MIN(PRECO) FROM CATEGORIA;

-- 11. Nome dos hóspedes que nasceram após 1° de janeiro de 1970.
SELECT NOME FROM HOSPEDE 
WHERE DT_NASC > '1970-01-01';

-- 12. Quantidade de hóspedes.
SELECT COUNT(COD_HOSP) FROM HOSPEDE;

-- 13. Altere a tabela Hóspede, acrescentando o campo "Nacionalidade".
ALTER TABLE HOSPEDE
ADD COLUMN 'Nacionalidade';

-- 14. A data de nascimento do hóspede mais velho.
SELECT MIN(DT_NASC) FROM HOSPEDE;

-- 15. A data de nascimento do hóspede mais novo.
SELECT MAX(DT_NASC) FROM HOSPEDE;

-- 16. O nome do hóspede mais velho
SELECT NOME FROM HOSPEDE
WHERE DT_NASC IN (SELECT MIN(DT_NASC) FROM HOSPEDE);

-- 17. Reajuste em 10% o valor das diárias das categorias.
UPDATE CATEGORIA
SET PRECO = PRECO * 1.10

-- 18. O número do apartamento mais caro ocupado pelo João.
SELECT MAX(AP.NUM_AP) FROM APARTAMENTO AP
JOIN HOSPEDAGEM H ON AP.NUM_AP = H.NUM_AP
JOIN HOSPEDE HO ON HO.COD_HOSP = H.COD_HOSP
WHERE HO.NOME ILIKE 'João%';

-- 19. O nome dos hóspedes que nunca se hospedaram no apartamento 201.
SELECT HO.NOME FROM HOSPEDE HO
JOIN HOSPEDAGEM H ON H.COD_HOSP = HO.COD_HOSP
JOIN APARTAMENTO AP ON AP.NUM_AP = H.NUM_AP
WHERE H.NUM_AP != 201;

-- 20. O nome dos hóspedes que nunca se hospedaram em apartamentos da categoria LUXO.
SELECT HO.NOME FROM HOSPEDE HO
JOIN HOSPEDAGEM H ON H.COD_HOSP = HO.COD_HOSP
JOIN APARTAMENTO AP ON AP.NUM_AP = H.NUM_AP
JOIN CATEGORIA C ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'Luxo%';

-- 21. O nome do hóspede mais velho que foi atendido pelo atendente mais novo.
SELECT HO.NOME FROM HOSPEDE HO
JOIN HOSPEDAGEM H ON H.COD_HOSP = HO.COD_HOSP
JOIN FUNCIONARIO F ON H.COD_FUNC = F.COD_FUNC
WHERE F.DT_NASC IN (SELECT MAX(DT_NASC) FROM FUNCIONARIO)
AND HO.DT_NASC IN (SELECT MIN(DT_NASC) FROM HOSPEDE);


-- 22. O nome da categoria mais cara que foi ocupado pelo hóspede mais velho.

SELECT C.NOME FROM CATEGORIA C
JOIN APARTAMENTO AP ON AP.COD_CAT = C.COD_CAT
JOIN HOSPEDAGEM H ON H.NUM_AP = AP.NUM_AP
JOIN HOSPEDE HO ON H.COD_HOSP = HO.COD_HOSP
WHERE C.PRECO IN (SELECT MAX(PRECO) FROM CATEGORIA)
AND HO.DT_NASC IN (SELECT MIN(DT_NASC) FROM HOSPEDE);


-- ========================== LISTA 2 ==========================

-- 1. Listagem dos hóspedes contendo nome e data de nascimento, ordenada em ordem
-- crescente por nome e decrescente por data de nascimento.
SELECT COD_HOSP FROM HOSPEDE ORDER BY NOME DESC,DT_NASC ASC

-- 2. Listagem contendo os nomes das categorias, ordenados alfabeticamente. A coluna de
-- nomes deve ter a palavra ‘Categoria’ como título.
SELECT NOME AS CATEGORIA ORDER BY CATEGORIA ASC

-- 3. Listagem contendo os valores de diárias e os números dos apartamentos, ordenada em
-- ordem decrescente de valor.
SELECT VALOR_DIA, NUM FROM APTO AP RIGHT JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT ORDER BY C DESC

-- 4. Categorias que possuem apenas um apartamento.
SELECT NOME FROM (SELECT NOME,COUNT(NOME) QUANTIDADE FROM CATEGORIA C JOIN APTO AP
ON AP.COD_CAT = C.COD_CAT GROUP BY C.NOME) WHERE COUNT(NOME) = 1

-- 5. Listagem dos nomes dos hóspedes brasileiros com mês e ano de nascimento, por ordem
-- decrescente de idade e por ordem crescente de nome do hóspede.
SELECT NOME, DT_NASC FROM HOSPEDE H ORDER BY DT_NASC ASC, NOME ASC


-- 6. Listagem com 3 colunas, nome do hóspede, número do apartamento e quantidade (número
-- de vezes que aquele hóspede se hospedou naquele apartamento), em ordem decrescente de
-- quantidade.
SELECT H.NOME, HO.NUM, COUNT(HO.NUM) AS QUANTIDADE FROM HOSPEDAGEM HO
JOIN HOSPEDE H ON H.COD_HOSP = HO.COD_HOSP 
GROUP BY H.NOME, HO.NUM
ORDER BY QUANTIDADE DESC

-- 7. Categoria cujo nome tenha comprimento superior a 15 caracteres.
SELECT NOME FROM CATEGORIA WHERE LENGTH(NOME)>15;

-- 8. Número dos apartamentos ocupados no ano de 2017 com o respectivo nome da sua
-- categoria.
SELECT AP.NUM_AP, C.NOME FROM APARTAMENTO AP
JOIN CATEGORIA C ON AP.COD_CAT = C.COD_CAT
JOIN HOSPEDAGEM HO ON AP.NUM_AP = HO.NUM_AP
WHERE HO.DT_ENT >= '2025-01-01' AND HO.DT_SAIDA <= '2025-12-31'


-- 9. Título do livro, nome da editora que o publicou e a descrição do assunto.
-- Não há como fazer.

-- 10. Crie a tabela funcionário com as atributos: cod_func, nome, dt_nascimento e salário.
-- Depois disso, acrescente o cod_func como chave estrangeira nas tabelas hospedagem e
-- reserva.
-- Questão já foi feita até a parte de adicionar cod_func como chave estrangeira na tabela hospedagem, falta criar a tabela reserva.
-- Tabela reserva criada e comentada lá em cima


-- 11. Mostre o nome e o salário de cada funcionário. Extraordinariamente, cada funcionário
-- receberá um acréscimo neste salário de 10 reais para cada hospedagem realizada.
SELECT NOME,SALARIO+COUNT(COD_HOSPEDA)*10 
FROM FUNCIONARIO F LEFT JOIN HOSPEDAGEM H
ON F.COD_FUNC=H.COD_FUNC
GROUP BY NOME,SALARIO

-- 12. Listagem das categorias cadastradas e para aquelas que possuem apartamentos, relacionar
-- também o número do apartamento, ordenada pelo nome da categoria e pelo número do
-- apartamento.
SELECT C.NOME, AP.NUM_AP FROM CATEGORIA C
LEFT JOIN APARTAMENTO AP ON C.COD_CAT = AP.COD_CAT
ORDER BY C.NOME, AP.NUM_AP


-- 13. Listagem das categorias cadastradas e para aquelas que possuem apartamentos, relacionar
-- também o número do apartamento, ordenada pelo nome da categoria e pelo número do
-- apartamento. Para aquelas que não possuem apartamentos associados, escrever "não possui
-- apartamento".
SELECT NOME,COALESCE(CAST(NUM AS TEXT), 'NÃO TEM APTO') 
FROM CATEGORIA C LEFT JOIN APTO A ON C.COD_CAT=A.COD_CAT

-- 14. O nome dos funcionário que atenderam o João (hospedando ou reservando) ou que
-- hospedaram ou reservaram apartamentos da categoria luxo.
SELECT DISTINCT F.NOME FROM FUNCIONARIO F
JOIN HOSPEDAGEM HO ON F.COD_FUNC = HO.COD_FUNC
JOIN APARTAMENTO AP ON HO.NUM_AP = AP.NUM_AP
JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT
JOIN HOSPEDE H ON HO.COD_HOSP = H.COD_HOSP
WHERE H.NOME ILIKE 'João%' OR C.NOME ILIKE '%luxo%'

-- 15. O código das hospedagens realizadas pelo hóspede mais velho que se hospedou no
-- apartamento mais caro.
SELECT COD_HOSPEDA FROM HOSPEDAGEM WHERE 
COD_HOSP IN (SELECT COD_HOSP FROM HOSPEDE WHERE 
DT_NASC IN (SELECT MIN(DT_NASC) FROM HOSPEDE WHERE 
COD_HOSP IN (SELECT COD_HOSP FROM HOSPEDAGEM WHERE
NUM IN (SELECT NUM FROM APTO WHERE
COD_CAT IN (SELECT COD_CAT FROM CATEGORIA WHERE
VALOR_DIA IN (SELECT MAX(VALOR_DIA) FROM CATEGORIA))))))

-- 16. Sem usar subquery, o nome dos hóspedes que nasceram na mesma data do hóspede de
-- código 2.
SELECT H2.NOME FROM HOSPEDE H1,HOSPEDE H2 WHERE 
H1.COD_HOSP<>H2.COD_HOSP AND H1.COD_HOSP=7 AND H1.DT_NASC=H2.DT_NASC

-- 17. O nome do hóspede mais velho que se hospedou na categoria mais cara no ano de 2017.
SELECT H.NOME FROM HOSPEDE H 
JOIN HOSPEDAGEM HO ON H.COD_HOSP = HO.COD_HOSP 
JOIN APARTAMENTO AP ON AP.NUM_AP = HO.NUM_AP
JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT
WHERE H.DT_NASC IN (SELECT MIN(DT_NASC) FROM HOSPEDE)
AND C.PRECO = (SELECT MAX(PRECO) FROM CATEGORIA) 
AND HO.DT_ENT >= '2017-01-01' AND HO.DT_SAIDA <= '2017-12-31';


SELECT c.nome FROM categoria c
JOIN apto a ON c.cod_cat = a.cod_cat
JOIN hospedagem ho ON ho.num = a.num
JOIN hospede h ON h.cod_hosp = ho.cod_hosp
WHERE h.nome ILIKE ('ribamar')
OR h.nome ILIKE ('joão') AND cod_func IN (
	SELECT cod_func FROM funcionario
	WHERE nome ILIKE ('klaudio')
);

-- 18. O nome das categorias que foram reservadas pela Maria ou que foram ocupadas pelo João
-- quando ele foi atendido pelo Joaquim.
SELECT C.NOME FROM CATEGORIA C
JOIN APARTAMENTO AP ON C.COD_CAT = AP.COD_CAT
JOIN HOSPEDAGEM HO ON HO.NUM_AP = AP.NUM_AP
JOIN FUNCIONARIO F ON HO.COD_FUNC = F.COD_FUNC
JOIN HOSPEDE H ON HO.COD_HOSP = H.COD_HOSP
WHERE H.NOME ILIKE 'Maria' 
OR H.NOME ILIKE 'João' AND F.NOME ILIKE 'Joaquim';


-- 19. O nome e a data de nascimento dos funcionários, além do valor de diária mais cara
-- reservado por cada um deles.
SELECT F.NOME, F.DT_NASC, MAX(C.PRECO) FROM FUNCIONARIO F
JOIN HOSPEDAGEM HO ON HO.COD_FUNC = F.COD_FUNC
JOIN APARTAMENTO AP ON AP.NUM_AP = HO.NUM_AP
JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT
GROUP BY F.NOME, F.DT_NASC;


-- 20. A quantidade de apartamentos ocupados por cada um dos hóspedes (mostrar o nome)
SELECT H.NOME, COUNT(AP.NUM_AP) FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON HO.COD_HOSP = H.COD_HOSP
JOIN APARTAMENTO AP ON HO.NUM_AP = AP.NUM_AP
GROUP BY H.NOME;

-- 21. A relação com o nome dos hóspedes, a data de entrada, a data de saída e o valor total
-- pago em diárias (não é necessário considerar a hora de entrada e saída, apenas as datas).
SELECT H.NOME, HO.DT_ENT, HO.DT_SAIDA, C.PRECO * (HO.DT_SAIDA - HO.DT_ENT) FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON HO.COD_HOSP = H.COD_HOSP
JOIN APARTAMENTO AP ON HO.NUM_AP = AP.NUM_AP
JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT;


-- 22. O nome dos hóspedes que já se hospedaram em todos os apartamentos do hotel.
SELECT H.NOME FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON H.COD_HOSP = HO.COD_HOSP
GROUP BY H.NOME
HAVING COUNT(DISTINCT(NUM_AP)) = (SELECT COUNT(*) FROM APARTAMENTO);

-------- 2 FORMA DE FAZER A QUESTÃO

SELECT NOME FROM HOSPEDE H1
WHERE (
	SELECT COUNT(DISTINCT(NUM_AP)) FROM HOSPEDAGEM H2
	WHERE H1.COD_HOSP = H2.COD_HOSP
) = (
	SELECT COUNT(*) FROM APARTAMENTO
);

-- ========================== LISTA 3 ==========================
-- 1.Liste o nome dos hóspedes que se hospedaram mais de uma vez no mesmo apartamento.
SELECT H.NOME, HO.NUM_AP, COUNT(*) AS QTD_HOSPEDAGENS
FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON H.COD_HOSP = HO.COD_HOSP
GROUP BY H.NOME,HO.NUM_AP
HAVING COUNT(*) > 1

-- 2.Mostre o nome dos hóspedes que nunca foram atendidos por um funcionário chamado “Carlos”.
SELECT H.NOME FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON H.COD_HOSP = HO.COD_HOSP
WHERE HO.NOME NOT IN (
	SELECT F.NOME FROM FUNCIONARIO
)

-- 3.Mostre o nome do(s) funcionário(s) que mais atenderam hóspedes, considerando o número de hospedagens.
SELECT F.NOME FROM FUNCIONARIO F
JOIN HOSPEDAGEM HO ON HO.COD_FUNC = F.COD_FUNC
GROUP BY F.NOME
HAVING COUNT(HO.COD_HOSPEDAGEM) = (
	SELECT COUNT(*)
	FROM HOSPEDAGEM
	GROUP BY COD_FUNC
)

-- 4.Liste o número do(s) apartamento(s) que ficaram mais tempo ocupados no ano de 2017.
SELECT AP.NUM_AP, SUM(HO.DT_SAIDA - HO.DT_ENT) AS OCUPACAO
FROM HOSPEDAGEM HO 
JOIN APARTAMENTO AP ON HO.NUM_AP = AP.NUM_AP
WHERE DT_ENT >= '2017-01-01' AND DT_SAIDA <= '2017-12-31' 
GROUP BY AP.NUM_AP
ORDER BY AP.NUM_AP DESC

-- 5.Liste os hóspedes que já se hospedaram em apartamentos de todas as categorias cadastradas.
SELECT H.NOME FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON H.COD_HOSP = HO.COD_HOSP
JOIN APARTAMENTO AP ON AP.NUM_AP = HO.NUM_AP
JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT
GROUP BY H.NOME
HAVING COUNT(DISTINCT(C.COD_CAT)) = (SELECT COUNT(*) FROM CATEGORIA)

-- 6.Liste todas as categorias cadastradas, mesmo as que ainda não possuem apartamentos associados, ordenadas pelo nome da categoria.
-- (Uso de LEFT JOIN e ORDER BY)
SELECT C.NOME, AP.NUM_AP FROM CATEGORIA C
LEFT JOIN APARTAMENTO AP ON AP.COD_CAT = C.COD_CAT
ORDER BY C.NOME

-- 7.Mostre todos os apartamentos e o nome da categoria associada, mesmo que algum apartamento não tenha sido associado a nenhuma categoria.
-- (Uso de RIGHT JOIN)
SELECT AP.NUM_AP, C.NOME FROM APARTAMENTO AP
RIGHT JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT 

-- Apresente a quantidade de hospedagens por mês no ano de 2018.
-- (Uso de GROUP BY)
SELECT 
	EXTRACT(MONTH FROM HO.DT_ENT) AS MES,
	COUNT(*) AS QTD_HOSPEDAGENS
FROM HOSPEDAGEM HO 
WHERE EXTRACT(YEAR FROM HO.DT_ENT) = 2018
GROUP BY MES
ORDER BY MES

-- Liste os nomes dos funcionários e o número de hóspedes que cada um atendeu, incluindo os funcionários que ainda não atenderam ninguém.
-- (Uso de LEFT JOIN e GROUP BY)
SELECT F.NOME, COUNT(HO.COD_HOSPEDAGEM) AS TOTAL
FROM FUNCIONARIO F
LEFT JOIN HOSPEDAGEM HO ON F.COD_FUNC = HO.COD_FUNC
GROUP BY F.NOME
ORDER BY TOTAL DESC

-- Mostre todos os hóspedes e os apartamentos em que se hospedaram, mesmo que algum hóspede ainda não tenha feito nenhuma hospedagem.
-- (Uso de LEFT JOIN)
SELECT H.NOME, AP.NUM_AP FROM HOSPEDAGEM HO
RIGHT JOIN APARTAMENTO AP ON AP.NUM_AP = HO.NUM_AP
LEFT JOIN HOSPEDE H ON H.COD_HOSP = HO.COD_HOSP
ORDER BY H.NOME


-- ****************** APRENDIZADO AULA 09/04/205 ******************
-- ----> GROUP BY:

-- Pega tudo que é igual e AGRUPA. A única coisa que pode ter depois é o order by
 SELECT NOME FROM HOSPEDE GROUP BY NOME
 SELECT NOME,COUNT(NOME) QUANTIDADE FROM HOSPEDE GROUP BY NOME
 ORDER BY 2 DESC

--  Obter a quantidade de hospedagens realizadas por cada nome de hóspede
 SELECT NOME, COUNT(NOME) QUANTIDADE FROM HOSPEDE H JOIN HOSPEDAGEM HO
 ON H.COD_HOSP = HO.COD_HOSP GROUP BY NOME

-- Listagem contendo os nomes das categorias, ordenados alfabeticamente. A coluna de
-- nomes deve ter a palavra ‘Categoria’ como título.
SELECT NOME AS CATEGORIA ORDER BY CATEGORIA ASC

-- ----> OUTER JOIN:

-- Cruza tabelas e apresenta linhas de uma tabela que não se relacionam com linhas de outra tabela

-- Nome de todas as categorias e, quando possível, os números do respectivo apartamento
SELECT NOME, NUM FROM APTO A RIGHT JOIN CATEGORIA C
ON A.COD_CAT = C.COD_CAT


-- ****************** APRENDIZADO AULA 12/04/205 ******************
-- ---> VISÕES DE BD:


-- ========================== LISTA 3 (PATROCINIO) ==========================
-- Instituto Federal do Piauí
-- Primeira Avaliação de Banco de Dados II - 20/03/2024
-- Luis Felipe dos Santos Patrocinio

-- 1. O nome dos títulos dos livros emprestados para o leitor João pelo funcionário José OU 
--os reservados para a leitora Maria pelo funcionário Antônio.
-- SELECT T.NOME TITULO_LIVRO
-- FROM TITULO T
-- NATURAL JOIN LIVRO LIV
-- NATURAL JOIN EMPRESTIMO EMP
-- JOIN LEITOR LEI ON LEI.COD_LEITOR = EMP.COD_LEITOR
-- JOIN FUNCIONARIO F ON F.COD_FUNC = EMP.COD_FUNC
-- WHERE (
-- 	F.NOME ILIKE 'José' AND
-- 	LEI.NOME ILIKE 'João'
-- ) OR (
-- 	LEI.NOME ILIKE 'Maria' AND
-- 	F.NOME ILIKE 'Antônio'
-- )


-- -- 2. O nome dos autores que escreveram os títulos reservados para a leitora Maria, 
-- -- mas que nunca foram reservados para o leitor mais jovem.
-- SELECT A.NOME
-- FROM AUTOR A
-- JOIN AUTORIA AU ON A.COD_AUTOR = AU.COD_AUTOR
-- JOIN TITULO T ON T.COD_TIT = AU.COD_TIT
-- JOIN RESERVA R ON R.COD_TIT = T.COD_TIT
-- JOIN LEITOR L ON L.COD_LEITOR = R.COD_LEITOR
-- WHERE L.NOME ILIKE 'MARIA'
-- EXCEPT
-- SELECT A.NOME
-- FROM AUTOR A
-- JOIN AUTORIA AU ON A.COD_AUTOR = AU.COD_AUTOR
-- JOIN TITULO T ON T.COD_TIT = AU.COD_TIT
-- JOIN RESERVA R ON R.COD_TIT = T.COD_TIT
-- JOIN LEITOR L ON L.COD_LEITOR = R.COD_LEITOR
-- WHERE L.DT_NASC IN (
-- 	SELECT MAX(DT_NASC) FROM LEITOR
-- )


-- -- 3. Para cada código e nome de leitor, o valor total pago em multas. 
-- -- Mostre apenas aqueles leitores cujo valor total das multas é maior que zero. 
-- -- COnsidere que a data de devolução é sempre maior ou igual à data prevista de devolução.
-- SELECT L.COD_LEITOR, L.NOME, SUM((DT_DEV-DT_PREV_DEV)*LIV.VALOR_MULTA_DIA) VALOR_MULTA
-- FROM LEITOR L
-- JOIN EMPRESTIMO EMP ON L.COD_LEITOR = EMP.COD_LEITOR
-- JOIN LIVRO LIV ON EMP.COD_LIVRO = LIV.COD_LIVRO
-- GROUP BY L.COD_LEITOR
-- HAVING SUM((DT_DEV-DT_PREV_DEV)*LIV.VALOR_MULTA_DIA) > 0


-- -- 4. O nome dos autores com a respectiva quantidade de títulos escritos.
-- -- Considere a possibilidade de haver autores sem nenhum título publicado no cadastro.
-- -- Para estes, informe o valor zero.
-- SELECT A.NOME, COUNT(AU.COD_AUTORIA) QUANTIDADE_LIVROS_ESCRITOS
-- FROM AUTOR A
-- NATURAL LEFT JOIN AUTORIA AU
-- LEFT JOIN TITULO T ON T.COD_TIT = AU.COD_TIT
-- GROUP BY A.NOME
-- ORDER BY QUANTIDADE_LIVROS_ESCRITOS DESC, A.NOME ASC


-- -- 6. O nome dos leitores que reservaram todos os títulos.
-- SELECT L.NOME, COUNT(R.COD_TIT)
-- FROM LEITOR L NATURAL JOIN RESERVA R 
-- JOIN TITULO T ON R.COD_TIT = T.COD_TIT
-- GROUP BY L.NOME
-- HAVING COUNT(DISTINCT T.COD_TIT) = (SELECT COUNT(COD_TIT) FROM TITULO)




