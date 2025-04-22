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
-- 2. Nomes das categorias cujos nomes possuam a palavra ‘Luxo’.
-- 3. Número dos apartamentos que estão ocupados, ou seja, a data de saída está vazia.
-- 4. Número dos apartamentos cuja categoria tenha código 1, 2, 3, 11, 34, 54, 24, 12.
-- 5. Todas as informações dos apartamentos cujas categorias iniciam com a palavra ‘Luxo’.
-- 6. Quantidade de apartamentos cadastrados no sistema.
-- 7. Somatório dos preços das categorias.
-- 8. Média de preços das categorias.
-- 9. Maior preço de categoria.
-- 10. Menor preço de categoria.
-- 11. Nome dos hóspedes que nasceram após 1° de janeiro de 1970.
-- 12. Quantidade de hóspedes.
-- 13. Altere a tabela Hóspede, acrescentando o campo "Nacionalidade".
-- 14. A data de nascimento do hóspede mais velho.
-- 15. A data de nascimento do hóspede mais novo.
-- 16. O nome do hóspede mais velho
-- 17. Reajuste em 10% o valor das diárias das categorias.
-- 18. O número do apartamento mais caro ocupado pelo João.
-- 19. O nome dos hóspedes que nunca se hospedaram no apartamento 201.
-- 20. O nome dos hóspedes que nunca se hospedaram em apartamentos da categoria LUXO.
-- 21. O nome do hóspede mais velho que foi atendido pelo atendente mais novo.
-- 22. O nome da categoria mais cara que foi ocupado pelo hóspede mais velho.


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
WHERE HO.DT_ENT >= '2017-01-01' AND HO.DT_SAIDA <= '2017-12-31'
GROUP BY AP.NUM_AP, C.NOME

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
AND HO.DT_ENT >= '2017-01-01' AND HO.DT_SAIDA <= '2017-12-31'


-- 18. O nome das categorias que foram reservadas pela Maria ou que foram ocupadas pelo João
-- quando ele foi atendido pelo Joaquim.
SELECT C.NOME FROM CATEGORIA C
JOIN APARTAMENTO AP ON C.COD_CAT = AP.COD_CAT
JOIN HOSPEDAGEM HO ON HO.NUM_AP = AP.NUM_AP
JOIN FUNCIONARIO F ON HO.COD_FUNC = F.COD_FUNC
JOIN HOSPEDE H ON HO.COD_HOSP = H.COD_HOSP
WHERE H.NOME ILIKE 'João%' AND F.NOME ILIKE 'Joaquim%' OR H.NOME ILIKE 'Maria%'
AND F.NOME ILIKE 'Joaquim%'


-- 19. O nome e a data de nascimento dos funcionários, além do valor de diária mais cara
-- reservado por cada um deles.
SELECT F.NOME, F.DT_NASC, MAX(C.PRECO) FROM FUNCIONARIO F
JOIN HOSPEDAGEM HO ON HO.COD_FUNC = F.COD_FUNC
JOIN APARTAMENTO AP ON AP.NUM_AP = HO.NUM_AP
JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT
GROUP BY F.NOME, F.DT_NASC


-- 20. A quantidade de apartamentos ocupados por cada um dos hóspedes (mostrar o nome)
SELECT H.NOME, COUNT(AP.NUM_AP) FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON HO.COD_HOSP = H.COD_HOSP
JOIN APARTAMENTO AP ON HO.NUM_AP = AP.NUM_AP
GROUP BY H.NOME

-- 21. A relação com o nome dos hóspedes, a data de entrada, a data de saída e o valor total
-- pago em diárias (não é necessário considerar a hora de entrada e saída, apenas as datas).
SELECT H.NOME, HO.DT_ENT, HO.DT_SAIDA, C.PRECO * (HO.DT_SAIDA - HO.DT_ENT) FROM HOSPEDE H
JOIN HOSPEDAGEM HO ON HO.COD_HOSP = H.COD_HOSP
JOIN APARTAMENTO AP ON HO.NUM_AP = AP.NUM_AP
JOIN CATEGORIA C ON C.COD_CAT = AP.COD_CAT


-- 22. O nome dos hóspedes que já se hospedaram em todos os apartamentos do hotel.

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
