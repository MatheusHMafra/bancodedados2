/*
 Todas as questões devem ser feitas para que funcione no postgresql
 */
/*
 Questão 1 (1 ponto) – Desenvolva o código SQL da criação do banco de dados de acordo
 com a estrutura abaixo (todas as chaves primárias são do tipo SERIAL):
 */
SELECT schema_name
FROM information_schema.schemata;
SHOW search_path;
CREATE SCHEMA trabalho1;
SET search_path = Biblioteca;
/*------------------*/
CREATE TABLE mae (
    id SERIAL PRIMARY KEY,
    id_cidade INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    celular VARCHAR(15),
    FOREIGN KEY (id_cidade) REFERENCES cidade(id)
);
CREATE TABLE cidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    uf VARCHAR(2) NOT NULL
);
CREATE TABLE nascimento (
    id SERIAL PRIMARY KEY,
    id_mae INT NOT NULL,
    crm_medico INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    peso DECIMAL(5, 3),
    altura TINYINT(2),
    FOREIGN KEY (id_mae) REFERENCES mae(id)
);
CREATE TABLE agendamento (
    id SERIAL PRIMARY KEY,
    id_nascimento INT NOT NULL,
    inicio TIMESTAMP,
    fim TIMESTAMP,
    FOREIGN KEY (id_nascimento) REFERENCES nascimento(id)
);
/*
 Questão 2 (1 ponto) – Simule a inserção de, no mínimo, 3 registros em cada tabela do
 banco de dados criado na Questão 1.
 */
INSERT INTO cidade (nome, uf)
VALUES ('São Paulo', 'SP'),
    ('Rio de Janeiro', 'RJ'),
    ('Belo Horizonte', 'MG');
/*------------------*/
INSERT INTO mae (id_cidade, nome, celular)
VALUES (1, 'Maria', '11999999999'),
    (2, 'Ana', '21999999999'),
    (3, 'Joana', '31999999999');
/*------------------*/
INSERT INTO nascimento (
        id_mae,
        crm_medico,
        name,
        data_nascimento,
        peso,
        altura
    )
VALUES (1, 123456, 'João', '2021-01-01', 3.5, 50),
    (2, 123456, 'José', '2021-01-02', 3.6, 51),
    (3, 123456, 'Pedro', '2021-01-03', 3.7, 52);
/*------------------*/
INSERT INTO agendamento (id_nascimento, inicio, fim)
VALUES (1, '2021-01-01 08:00:00', '2021-01-01 08:30:00'),
    (2, '2021-01-02 08:00:00', '2021-01-02 08:30:00'),
    (3, '2021-01-03 08:00:00', '2021-01-03 08:30:00');
/*
 Questão 3 – De acordo com o banco de dados criado na Questão 1, faça os seguintes
 procedimentos armazenados:
 */
/*
 1. (1 ponto) Crie um procedimento armazenado, utilizando a linguagem SQL, que
 receba por parâmetro o mês (inteiro) e o ano (inteiro), e retorne a quantidade de
 nascimentos no período por médico, e o nome do médico. Ordenar por quantidade
 (decrescente) e por nome (alfabética).
 */
CREATE OR REPLACE FUNCTION nascimentos_por_medico(mes INT, ano INT) RETURNS TABLE (
        crm_medico INT,
        nome VARCHAR(100),
        quantidade INT
    ) AS $$
SELECT n.crm_medico,
    m.nome,
    COUNT(n.id) AS quantidade
FROM nascimento n
    JOIN mae m ON n.id_mae = m.id
WHERE EXTRACT(
        MONTH
        FROM n.data_nascimento
    ) = mes
    AND EXTRACT(
        YEAR
        FROM n.data_nascimento
    ) = ano
GROUP BY n.crm_medico,
    m.nome
ORDER BY quantidade DESC,
    m.nome;
$$ LANGUAGE SQL;
/*
 2. (1 ponto) Crie um procedimento armazenado, utilizando a linguagem PL/pgSQL,
 que receba por parâmetro os dados do bebê, e insira um registro na tabela
 “nascimento”. Faça uma validação, antes de inserir, para lançar uma exceção
 caso o ID da mãe não exista; e caso o CRM do médico informado não exista ou
 esteja inativo.
 */
CREATE OR REPLACE FUNCTION inserir_nascimento(
        id_mae INT,
        crm_medico INT,
        name VARCHAR(100),
        data_nascimento DATE,
        peso DECIMAL(5, 3),
        altura TINYINT(2)
    ) RETURNS VOID AS $$
DECLARE id_mae_exist INT;
BEGIN
SELECT id INTO id_mae_exist
FROM mae
WHERE id = id_mae;
IF id_mae_exist IS NULL THEN RAISE EXCEPTION 'ID da mãe não existe';
END IF;
IF NOT EXISTS (
    SELECT 1
    FROM nascimento
    WHERE crm_medico = crm_medico
) THEN RAISE EXCEPTION 'CRM do médico não existe ou está inativo';
END IF;
INSERT INTO nascimento (
        id_mae,
        crm_medico,
        name,
        data_nascimento,
        peso,
        altura
    )
VALUES (
        id_mae,
        crm_medico,
        name,
        data_nascimento,
        peso,
        altura
    );
END;
$$ LANGUAGE plpgsql;
/*
 3. (2 pontos) Crie um procedimento armazenado, utilizando a linguagem PL/pgSQL,
 que receba por parâmetro o CRM do médico, o mês (inteiro) e o ano (inteiro), e
 retorne o valor do salário líquido. O salário do médico é composto pelo salário fixo
 do médico mais R$ 4.000,00 por nascimento realizado no período. Caso o
 nascimento tenha sido em uma cidade (considerar a cidade da mãe) diferente da
 cidade que o médico mora, há um custo de R$ 500,00 de descolamento por
 nascimento. Faça uma validação para lançar uma exceção caso o CRM do
 médico informado não exista ou esteja inativo.
 */
CREATE OR REPLACE FUNCTION salario_medico(crm_medico INT, mes INT, ano INT) RETURNS DECIMAL AS $$
DECLARE salario DECIMAL;
cidade_medico VARCHAR(100);
cidade_mae VARCHAR(100);
valor_deslocamento DECIMAL;
BEGIN
SELECT salario_fixo INTO salario
FROM medico
WHERE crm = crm_medico;
IF salario IS NULL THEN RAISE EXCEPTION 'CRM do médico não existe ou está inativo';
END IF;
SELECT cidade INTO cidade_medico
FROM medico
WHERE crm = crm_medico;
SELECT cidade INTO cidade_mae
FROM mae
    JOIN nascimento n ON mae.id = n.id_mae
WHERE EXTRACT(
        MONTH
        FROM n.data_nascimento
    ) = mes
    AND EXTRACT(
        YEAR
        FROM n.data_nascimento
    ) = ano;
IF cidade_medico <> cidade_mae THEN valor_deslocamento = 500;
ELSE valor_deslocamento = 0;
END IF;
RETURN salario + 4000 + valor_deslocamento;
END;
/*
 Questão 4 – De acordo com o banco de dados criado na Questão 1, faça os seguintes
 gatilhos:
 */
/*
 1. (1 ponto) Crie uma função de gatilho que, ao inserir um registro na tabela
 “nascimento”, valide se o médico está ativo. Caso estiver inativo lançar uma
 mensagem de exceção: “médico inativo”.
 */
CREATE OR REPLACE FUNCTION validar_medico_ativo() RETURNS TRIGGER AS $$ BEGIN IF NOT EXISTS (
        SELECT 1
        FROM medico
        WHERE crm = NEW.crm_medico
    ) THEN RAISE EXCEPTION 'Médico inativo';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER validar_medico_ativo BEFORE
INSERT ON nascimento FOR EACH ROW EXECUTE FUNCTION validar_medico_ativo();
/*
 2. (1 ponto) Crie uma função de gatilho para não permitir valor nulo nas colunas nome,
 data_nascimento, peso e altura da tabela “nascimento”, ao atualizar um registro.
 Deve-se lançar uma exceção customizada para cada coluna.
 */
CREATE OR REPLACE FUNCTION validar_nulo() RETURNS TRIGGER AS $$ BEGIN IF NEW.name IS NULL THEN RAISE EXCEPTION 'Nome não pode ser nulo';
END IF;
IF NEW.data_nascimento IS NULL THEN RAISE EXCEPTION 'Data de nascimento não pode ser nula';
END IF;
IF NEW.peso IS NULL THEN RAISE EXCEPTION 'Peso não pode ser nulo';
END IF;
IF NEW.altura IS NULL THEN RAISE EXCEPTION 'Altura não pode ser nula';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER validar_nulo BEFORE
UPDATE ON nascimento FOR EACH ROW EXECUTE FUNCTION validar_nulo();
/*
 3. (2 pontos) Crie uma função de gatilho para não permitir agendamentos fora do
 expediente do hospital. Lance uma mensagem de exceção. Leve em
 consideração as seguintes regras de negócio:
 a. Expediente: 08:00 até 12:00; 13:30 até 17:30;
 b. Não há expediente no sábado e no domingo;
 c. Não é permitido que um agendamento ultrapasse o horário do expediente
 (exemplo: o agendamento que inicia às 11:50 e finaliza às 12:10 não é válido).
 */
CREATE OR REPLACE FUNCTION validar_expediente() RETURNS TRIGGER AS $$ BEGIN IF EXTRACT(
        DOW
        FROM NEW.inicio
    ) IN (0, 6) THEN RAISE EXCEPTION 'Não é permitido agendamento no sábado e no domingo';
END IF;
IF EXTRACT(
    HOUR
    FROM NEW.inicio
) < 8
OR EXTRACT(
    HOUR
    FROM NEW.inicio
) >= 17 THEN RAISE EXCEPTION 'Não é permitido agendamento fora do horário de expediente';
END IF;
IF EXTRACT(
    HOUR
    FROM NEW.inicio
) = 12
AND EXTRACT(
    MINUTE
    FROM NEW.inicio
) > 0 THEN RAISE EXCEPTION 'Não é permitido agendamento fora do horário de expediente';
END IF;
IF EXTRACT(
    HOUR
    FROM NEW.inicio
) = 17
AND EXTRACT(
    MINUTE
    FROM NEW.inicio
) > 30 THEN RAISE EXCEPTION 'Não é permitido agendamento fora do horário de expediente';
END IF;
IF EXTRACT(
    HOUR
    FROM NEW.fim
) < 8
OR EXTRACT(
    HOUR
    FROM NEW.fim
) >= 17 THEN RAISE EXCEPTION 'Não é permitido agendamento fora do horário de expediente';
END IF;
IF EXTRACT(
    HOUR
    FROM NEW.fim
) = 12
AND EXTRACT(
    MINUTE
    FROM NEW.fim
) > 0 THEN RAISE EXCEPTION 'Não é permitido agendamento fora do horário de expediente';
END IF;
IF EXTRACT(
    HOUR
    FROM NEW.fim
) = 17
AND EXTRACT(
    MINUTE
    FROM NEW.fim
) > 30 THEN RAISE EXCEPTION 'Não é permitido agendamento fora do horário de expediente';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER validar_expediente BEFORE
INSERT ON agendamento FOR EACH ROW EXECUTE FUNCTION validar_expediente();
CREATE TRIGGER validar_expediente BEFORE
UPDATE ON agendamento FOR EACH ROW EXECUTE FUNCTION validar_expediente();