-----------------------------------------------
CREATE TABLE TIME (
    cod_time INT PRIMARY KEY,
    nome_time VARCHAR(100),
    num_maximo_contratados int not null,
    dt_fundacao date not null
);

INSERT INTO TIME VALUES
(1, 'Atlético Nacional', 2, '1900-09-09'),
(2, 'Grêmio', 2, '1901-09-09'),
(3, 'Boca Juniors', 2, '1902-09-09'),
(4, 'Corinthians', 2, '1903-09-09'),
(5, 'Flamengo', 2, '1904-09-09'),
(6, 'Palmeiras', 2, '1905-09-09');

----------------------------------------------------
CREATE TABLE JOGO (
    cod_time_mandante INT,
    cod_time_visitante INT,
    num_gols_time_mandante INT,
    num_gols_time_visitante INT,
    FOREIGN KEY (cod_time_mandante) REFERENCES TIME(cod_time),
    FOREIGN KEY (cod_time_visitante) REFERENCES TIME(cod_time)
);

-- Jogo 1: Atlético Nacional x Grêmio (2 a 1)
INSERT INTO JOGO VALUES 
(1, 2, 2, 1);

-- Jogo 2: Boca Juniors x Flamengo (0 a 3)
INSERT INTO JOGO VALUES
(3, 5, 0, 3);

-- Jogo 3: Grêmio x Corinthians (1 a 3)
INSERT INTO JOGO VALUES
(2, 4, 1, 3);

-- Jogo 4: Flamengo x Atlético Nacional (3 a 2)
INSERT INTO JOGO VALUES
(5, 1, 3, 2);

-- Jogo 5: Corinthians x Boca Juniors (1 a 0)
INSERT INTO JOGO VALUES
(4, 3, 1, 0);

-- Jogo 6: Atlético Nacinal x Boca Juniors (1 a 0)
INSERT INTO JOGO VALUES
(1, 3, 1, 0);

-------------------------------------------------------------
CREATE TABLE JOGADOR (
    cod_jogador INT PRIMARY KEY,
    nome VARCHAR(100),
    dt_nasc date not null
);

INSERT INTO JOGADOR VALUES
(1, 'Ronaldinho', '1999-03-02'),
(2, 'Ronaldo', '2000-03-09'),
(3, 'Romário', '1999-12-04'),
(4, 'Rivaldo', '2000-10-12'),
(5, 'Vampeta', '1998-10-10');

-----------------------------------------------------------
CREATE TABLE JOGATIME (
    cod_jogatime INT PRIMARY KEY,
    cod_time INTEGER NOT NULL,
    cod_jogador INTEGER NOT NULL,
    --o atributo "contratacao_ativa" controla se o jogador ainda está vinculado ao time. O atributo só pode receber os valores "s" ou "n" que representam SIM ou NÃO, respectivamente.
    contratacao_ativa char(1) check (contratacao_ativa='s' or contratacao_ativa='n'),
    FOREIGN KEY (cod_time) REFERENCES time(cod_time),
    FOREIGN KEY (cod_jogador) REFERENCES jogador(cod_jogador)
);

INSERT INTO JOGATIME VALUES
(1,1,1,'n'),
(2,2,2,'n'),
(3,1,2,'s'),
(4,2,1,'s'),
(5,3,3,'s'),
(6,3,4,'s'),
(7,5,5,'s');

-- 1. Para cada nome de time, obtenha a data de nascimento do jogador mais velho, independente se a contratação está ativa ou não.
-- Caso não possua, escreva a expressão não possui.

SELECT T.NOME_TIME, MAX(JG.DT_NASC) FROM TIME T
LEFT JOIN JOGATIME JT ON T.COD_TIME = JT.COD_TIME
LEFT JOIN JOGADOR JG ON JT.COD_JOGADOR = JG.COD_JOGADOR
GROUP BY T.NOME_TIME;

-- 2. Para cada código e nome de time, informe a quantidade de partidas disputadas. Ordene a sua resposta pelo código do time de forma crescente
-- Para facilitar a sua resposta, desconsidere os times que não participaram de nenhuma partida
SELECT T.NOME_TIME, T.COD_TIME, COUNT(J.COD_TIME_MANDANTE + J.COD_TIME_VISITANTE) FROM TIME T
LEFT JOIN JOGO J ON T.COD_TIME = J.COD_TIME_MANDANTE OR T.COD_TIME = J.COD_TIME_VISITANTE
GROUP BY T.NOME_TIME, T.COD_TIME
HAVING COUNT(J.COD_TIME_MANDANTE + J.COD_TIME_VISITANTE) > 0
ORDER BY T.COD_TIME ASC;


-- 4.CRIE UM TRIGGER NA TABELA JOGATIME QUE NÃO PERMITA QUE A QUANTIDADE MÁXIMA DE CONTRATAÇÕES ATIVAS DE JOGADORES
-- EM UM DETERMINADO TIME SEJA SUPERADA. LEMBRE-SE QUE O NÚMERO MÁXIMO DE CONTRATAÇÕES ATIVAS
-- PARA CADA TIME CONSTA NA TABELA TIME.
CREATE OR REPLACE TRIGGER TRG_IMPEDE_CONTRATACAO
BEFORE INSERT ON JOGATIME
FOR EACH ROW EXECUTE PROCEDURE TG_IMPEDE_CONTRATACAO();

CREATE OR REPLACE FUNCTION TG_IMPEDE_CONTRATACAO()
RETURNS TRIGGER AS $$
DECLARE
JOGADORES_TOTAIS_TIME INT;
MAX_CONTRATACOES INT;

BEGIN

	JOGADORES_TOTAIS_TIME = (SELECT COUNT(JT.COD_JOGADOR) FROM JOGATIME JT WHERE JT.CONTRATACAO_ATIVA = 's');
	MAX_CONTRATACOES = (SELECT MAX(NUM_MAXIMO_CONTRATADOS) FROM TIME);

	IF (JOGADORES_TOTAIS_TIME > MAX_CONTRATACOES) THEN
		RAISE EXCEPTION 'O limite de contratações ativas foi atingido.';
	END IF;

RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

INSERT INTO JOGATIME(COD_JOGATIME, COD_TIME, COD_JOGADOR, CONTRATACAO_ATIVA) VALUES
(7,3,5,'s'); -- O limite para o time 3 é dois jogadores e com esse insert é ultrapassado.
