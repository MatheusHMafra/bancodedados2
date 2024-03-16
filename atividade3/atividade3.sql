-- PARA ESTA ATIVIDADE, EFETUE AS SEGUINTES ETAPAS:
--	1. EFETUE A CRIAÇÃO DAS TABELAS, LINHAS 12 A 64
-- 	2. EFETUE A INSERÇÃO DOS REGISTROS, LINAS 67 A 115
-- 	3. EFETUE A CRIAÇÃO DE FUNÇÕES PARA CADA UM DOS EXERCICIOS A PARTIR DA LINHA 118

-- clinica veterinaria
SELECT schema_name FROM information_schema.schemata;
SHOW search_path;
CREATE SCHEMA clinica_vet;
SET search_path = clinica_vet;

CREATE TABLE Endereco (
    cod serial PRIMARY KEY,
    logradouro varchar(100),
    numero integer,
    complemento varchar(50),
    cep varchar(12),
    cidade varchar(50),
    uf varchar(2)
);

CREATE TABLE Responsavel (
    cod serial PRIMARY KEY,
    nome varchar(100) NOT NULL,
    cpf varchar(12) NOT NULL,
    fone varchar(50) NOT NULL,
    email varchar(100) NOT NULL,
    cod_end integer,
    UNIQUE (cpf, email),
    FOREIGN KEY (cod_end) REFERENCES Endereco (cod) 
);

CREATE TABLE Pet (
    cod serial PRIMARY KEY,
    nome varchar(100),
    raca varchar(50),
    peso decimal(5,2),
    data_nasc date,
    cod_resp integer,
    FOREIGN KEY (cod_resp) REFERENCES Responsavel (cod) 
);

CREATE TABLE Veterinario (
    cod serial PRIMARY KEY,
    nome varchar(100),
    crmv numeric(10),
    especialidade varchar(50),
    fone varchar(50),
    email varchar(100),
    cod_end integer,
	FOREIGN KEY (cod_end) REFERENCES Endereco (cod) 
);

CREATE TABLE Consulta (
    cod serial PRIMARY KEY,
    dt date,
    horario time,
    cod_vet integer,
    cod_pet integer,
    FOREIGN KEY (cod_vet) REFERENCES Veterinario (cod), 
    FOREIGN KEY (cod_pet) REFERENCES Pet (cod) 
	ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- inserindo enderecos
INSERT INTO endereco(cod,logradouro,numero,complemento,cep,cidade,uf) 
	VALUES 	(1, 'Rua Tenente-Coronel Cardoso', '501', 'ap 1001','28035042','Campos dos Goytacazes','RJ'),
			(2, 'Rua Serra de Bragança', '980', null,'03318000','São Paulo','SP'),
			(3, 'Rua Barão de Vitória', '50', 'loja A','09961660','Diadema','SP'),
			(4, 'Rua Pereira Estéfano', '700', 'ap 202 a','04144070','São Paulo','SP'),
			(5, 'Avenida Afonso Pena', '60', null,'30130005','São Paulo','SP'),
			(6, 'Rua das Fiandeiras', '123', 'Sala 501','04545005','São Paulo','SP'),
			(7, 'Rua Cristiano Olsen', '2549', 'ap 506','16015244','Araçatuba','SP'),
			(8, 'Avenida Desembargador Moreira', '908', 'Ap 405','60170001','Fortaleza','CE'),
			(9, 'Avenida Almirante Maximiano Fonseca', '362', null,'88113350','Rio Grande','RS'),
			(10, 'Rua Arlindo Nogueira', '219', 'ap 104','64000290','Teresina','PI');

-- inserindo responsaveis
INSERT INTO responsavel(cod,nome,cpf,email,fone,cod_end) 
	VALUES 	(1, 'Márcia Luna Duarte', '1111111111', 'marcia.luna.duarte@deere.com','(63) 2980-8765',1),
			(2, 'Benício Meyer Azevedo','23101771056', 'beniciomeyer@gmail.com.br','(63) 99931-8289',2),
			(3, 'Ana Beatriz Albergaria Bochimpani Trindade','61426227400','anabeatriz@ohms.com.br', '(87) 2743-5198',3),
			(4, 'Thiago Edson das Neves','31716341124','thiago_edson_dasneves@paulistadovale.org.br','(85) 3635-5560',4),
			(5, 'Luna Cecília Alves','79107398','luna_alves@orthoi.com.br','(67) 2738-7166',5);

-- inserindo veterinarios
INSERT INTO veterinario(cod,nome,crmv,especialidade,email,fone,cod_end) 
	VALUES 	(1, 'Renan Bruno Diego Oliveira','35062','clinico geral','renanbrunooliveira@edu.uniso.br','(67) 99203-9967',6),
			(2, 'Clara Bárbara da Cruz','64121','dermatologista','clarabarbaradacruz@band.com.br','(63) 3973-7873',7),
			(3, 'Heloise Cristiane Emilly Moreira','80079','clinico geral','heloisemoreira@igoralcantara.com.br','(69) 2799-7715',8),
			(4, 'Laís Elaine Catarina Costa','62025','animais selvagens','lais-costa84@campanati.com.br','(79) 98607-4656',9),
			(5, 'Juliana Andrea Cardoso','00491','dermatologista','juliana_cardoso@br.ibn.com','(87) 98439-9604',10);

-- inserindo animais
INSERT INTO pet(cod,cod_resp,nome,peso,raca,data_nasc) 
	VALUES 	(1, 1, 'Mike', 12, 'pincher', '2010-12-20'),
			(2, 1, 'Nike', 20, 'pincher', '2010-12-20'),
			(3, 2, 'Bombom', 10, 'shitzu', '2022-07-15'),
 			(4, 3, 'Niro', 70, 'pastor alemao', '2018-10-12'),
			(5, 4, 'Milorde', 5, 'doberman', '2019-11-16'),
 			(6, 4, 'Laide', 4, 'coker spaniel','2018-02-27'),
 			(7, 4, 'Lorde', 3, 'dogue alemão', '2019-05-15'),
			(8, 5, 'Joe', 50, 'indefinido', '2020-01-01'),
			(9, 5, 'Felicia', 5, 'indefinido', '2017-06-07');

-- inserindo consultas
INSERT INTO consulta(cod,cod_pet, cod_vet, horario, dt) 
	VALUES 	(1,2,1,'14:30','2023-10-05'),
			(2,4,1,'15:00','2023-10-05'),
			(3,5,5,'16:30','2023-10-15'),
			(4,3,4,'14:30','2023-10-12'),
			(5,2,3,'18:00','2023-10-17'),
			(6,5,3,'14:10','2023-10-20'),
			(7,5,3,'10:30','2023-10-28');
			
			
-- EXERCÍCIOS:

-- 1 Crie uma função que insira um novo registro na tabela Endereco e 
--   retorne o código do endereço inserido.
CREATE OR REPLACE FUNCTION inserir_endereco(logradouro VARCHAR(100), numero INTEGER, complemento VARCHAR(50), cep VARCHAR(12), cidade VARCHAR(50), uf VARCHAR(2))
RETURNS INTEGER AS $$
DECLARE
    endereco_id INTEGER;
BEGIN
    INSERT INTO endereco(logradouro, numero, complemento, cep, cidade, uf) 
    VALUES (logradouro, numero, complemento, cep, cidade, uf) 
    RETURNING cod INTO endereco_id;
    RETURN endereco_id;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_endereco('Rua das Fiandeiras', 123, 'Sala 501', '04545005', 'São Paulo', 'SP');

-- 2 Crie um procedimento que atualize o email de um responsável com base no seu código.
CREATE OR REPLACE PROCEDURE atualizar_email_responsavel(cod_responsavel INTEGER, novo_email VARCHAR(100))
AS $$
BEGIN
    UPDATE responsavel SET email = novo_email WHERE cod = cod_responsavel;
END;
$$ LANGUAGE plpgsql;

CALL atualizar_email_responsavel(1, 'marcia.luna.duartee@deere.com');

-- 4 Faça um procedumento para excluir um responsável. 
--	 Excluir seus pets e endereços.
CREATE OR REPLACE PROCEDURE excluir_responsavel(cod_responsavel INTEGER)
AS $$
DECLARE
	endereco_cod INTEGER;
BEGIN
	SELECT cod_end INTO endereco_cod FROM responsavel WHERE cod = cod_responsavel;
    DELETE FROM pet WHERE cod_resp = cod_responsavel;
    DELETE FROM responsavel WHERE cod = cod_responsavel;
    DELETE FROM endereco WHERE cod = endereco_cod;
END;
$$ LANGUAGE plpgsql;

call excluir_responsavel(1);

-- 5 Faça uma função que liste todas as consultas agendadas para uma data específica.
--   Deve retornar uma tabela com os campos data da consulta, nome do responsavel, 
--   nome do pet, telefone do responsavel e nome do veterinario 
CREATE OR REPLACE FUNCTION listar_consultas_por_data(dt_consulta DATE)
RETURNS TABLE (
	data_consulta DATE,
	nome_responsavel VARCHAR(100),
	nome_pet VARCHAR(100),
	telefone_responsavel VARCHAR(50),
	nome_veterinario VARCHAR(100)) AS $$
BEGIN
    RETURN QUERY 
    SELECT c.dt, r.nome, p.nome, r.fone, v.nome
    FROM consulta c
    JOIN pet p ON c.cod_pet = p.cod
    JOIN responsavel r ON p.cod_resp = r.cod
    JOIN veterinario v ON c.cod_vet = v.cod
    WHERE c.dt = dt_consulta;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM listar_consultas_por_data('2023-10-05');

-- 6 Crie uma função que receba os dados do veterinario por parâmetro, armazene na tabela “veterinario” e retorne todos os dados da tabela.
CREATE OR REPLACE FUNCTION inserir_veterinario(
    v_nome VARCHAR(100), 
    v_crmv NUMERIC(10), 
    v_especialidade VARCHAR(50), 
    v_email VARCHAR(100), 
    v_fone VARCHAR(50), 
    v_logradouro VARCHAR(100), 
    v_numero INTEGER, 
    v_complemento VARCHAR(50), 
    v_cep VARCHAR(12), 
    v_cidade VARCHAR(50), 
    v_uf VARCHAR(2))
RETURNS TABLE (
    cod INTEGER, 
    nome VARCHAR(100), 
    crmv NUMERIC(10), 
    especialidade VARCHAR(50), 
    email VARCHAR(100), 
    fone VARCHAR(50), 
    cod_end INTEGER) AS $$
DECLARE
    endereco_id INTEGER;
BEGIN
    INSERT INTO endereco(logradouro, numero, complemento, cep, cidade, uf) 
    VALUES (v_logradouro, v_numero, v_complemento, v_cep, v_cidade, v_uf) 
    RETURNING endereco.cod INTO endereco_id;
    
    INSERT INTO veterinario(nome, crmv, especialidade, email, fone, cod_end) 
    VALUES (v_nome, v_crmv, v_especialidade, v_email, v_fone, endereco_id) 
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM inserir_veterinario('Renan Oliveira','350624','clinico geral','Renanoli@gmail.com','(67) 99203-9967','Rua das Fiandeiras', 123, 'Sala 501', '04545005', 'São Paulo', 'SP');

-- 7 Crie uma função para adicionar um novo pet, associando-o a um responsável existente.
CREATE OR REPLACE FUNCTION adicionar_novo_pet(
	cod_resp INTEGER,
	nome VARCHAR(100),
	peso DECIMAL(5,2),
	raca VARCHAR(50),
	data_nasc DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO pet(cod_resp, nome, peso, raca, data_nasc)
    VALUES (cod_resp, nome, peso, raca, data_nasc);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM adicionar_novo_pet(1, 'Mike', 12, 'pincher', '2010-12-20');

-- 8 Escreva uma função que conte quantos pets um determinado responsável possui.
CREATE OR REPLACE FUNCTION contar_pets_responsavel(cod_responsavel INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM pet WHERE cod_resp = cod_responsavel);
END;
$$ LANGUAGE plpgsql;

SELECT contar_pets_responsavel(1);

-- 9 Desenvolva uma função que retorne todos os veterinários com uma determinada especialidade.
CREATE OR REPLACE FUNCTION listar_veterinarios_por_especialidade(vet_espec VARCHAR(50))
RETURNS TABLE (
	cod INTEGER,
	nome VARCHAR(100),
	crmv NUMERIC(10),
	especialidade VARCHAR(50),
	email VARCHAR(100),
	fone VARCHAR(50),
	cod_end INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM veterinario WHERE especialidade = vet_espec;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM listar_veterinarios_por_especialidade('clinico geral');

-- 10 Crie um procedimento que atualize o endereço de um veterinário.
CREATE OR REPLACE PROCEDURE atualizar_endereco_veterinario(
	cod_vet INTEGER, 
	logr VARCHAR(100), 
	num INTEGER, 
	compl VARCHAR(50), 
	cep_in VARCHAR(12), 
	cidade_in VARCHAR(50), 
	uf_in VARCHAR(2))
AS $$
BEGIN
    UPDATE endereco SET 
    logradouro = logr, 
    numero = num, 
    complemento = compl, 
    cep = cep_in, 
    cidade = cidade_in, 
    uf = uf_in
    WHERE cod = (SELECT cod_end FROM veterinario WHERE cod = cod_vet);
END;
$$ LANGUAGE plpgsql;

CALL atualizar_endereco_veterinario(1, 'Rua das Fiandeiras', 123, 'Sala 501', '04545005', 'São Paulo', 'SP');

-- 11 Faça uma função que calcule a idade atual de um pet.
CREATE OR REPLACE FUNCTION calcular_idade_pet(cod_pet INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN DATE_PART('year', AGE(current_date, (SELECT data_nasc FROM pet WHERE cod = cod_pet)));
END;
$$ LANGUAGE plpgsql;

SELECT calcular_idade_pet(1);

-- 12 Crie uma função que retorne todos os endereços em uma cidade específica.
CREATE OR REPLACE FUNCTION listar_enderecos_por_cidade(
    cidade_in VARCHAR(50))
RETURNS TABLE (
    cod INTEGER, 
    logradouro VARCHAR(100), 
    numero INTEGER, 
    complemento VARCHAR(50), 
    cep VARCHAR(12), 
    uf VARCHAR(2)) AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM endereco WHERE cidade = cidade_in;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM listar_enderecos_por_cidade('São Paulo');

-- 13 Desenvolva um procedimento que associe um pet existente a um novo responsável.
CREATE OR REPLACE PROCEDURE associar_pet_a_novo_responsavel(cod_pet INTEGER, cod_novo_resp INTEGER)
AS $$
BEGIN
    UPDATE pet SET cod_resp = cod_novo_resp WHERE cod = cod_pet;
END;
$$ LANGUAGE plpgsql;

CALL associar_pet_a_novo_responsavel(1, 1);

-- 14 Elabore uma função que retorne todas as consultas agendadas de um determinado veterinário.
CREATE OR REPLACE FUNCTION listar_consultas_por_veterinario(cod_vet_in INTEGER)
RETURNS TABLE (
	cod_consulta INTEGER,
	data_consulta DATE,
	nome_responsavel VARCHAR(100),
	nome_pet VARCHAR(100),
	telefone_responsavel VARCHAR(50)) AS $$
BEGIN
    RETURN QUERY 
    SELECT c.cod, c.dt, r.nome, p.nome, r.fone
    FROM consulta c
    JOIN pet p ON c.cod_pet = p.cod
    JOIN responsavel r ON p.cod_resp = r.cod
    WHERE c.cod_vet = cod_vet_in;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM listar_consultas_por_veterinario(1);

-- 15 Função para Buscar Responsável pelo Nome do Pet: Desenvolva uma função que retorne o nome do responsável pelo nome do pet.
CREATE OR REPLACE FUNCTION buscar_responsavel_pelo_nome_pet(nome_pet VARCHAR(100))
RETURNS TABLE (nome_responsavel VARCHAR(100)) AS $$
BEGIN
    RETURN QUERY 
    SELECT r.nome
    FROM pet p
    JOIN responsavel r ON p.cod_resp = r.cod
    WHERE p.nome = nome_pet;
END;
$$ LANGUAGE plpgsql;  

SELECT * FROM buscar_responsavel_pelo_nome_pet('Mike');   

-- 16 Desenvolva uma função que recebe o CPF de um responsável e retorna seu nome se ele existir na base de dados; caso contrário, retorna uma mensagem "Responsável não encontrado".
CREATE OR REPLACE FUNCTION buscar_nome_responsavel_pelo_cpf(cpf_responsavel VARCHAR(12))
RETURNS VARCHAR(100) AS $$
DECLARE
    responsavel_nome VARCHAR(100);
BEGIN
    SELECT nome INTO responsavel_nome FROM responsavel WHERE cpf = cpf_responsavel;
    IF responsavel_nome IS NULL THEN
        RETURN 'Responsável não encontrado';
    ELSE
        RETURN responsavel_nome;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT buscar_nome_responsavel_pelo_cpf('1111111111');

-- 17 Crie uma função que receba um código de veterinário e retorne o total de consultas realizadas por ele, utilizando um loop WHILE.
CREATE OR REPLACE FUNCTION contar_consultas_veterinario(cod_vet_in INTEGER)
RETURNS INTEGER AS $$
DECLARE
    total_consultas INTEGER := 0;
    consulta_id INTEGER;
BEGIN
    SELECT INTO total_consultas COUNT(*) FROM consulta WHERE cod_vet = cod_vet_in;
    RETURN total_consultas;
END;
$$ LANGUAGE plpgsql;

SELECT contar_consultas_veterinario(1);