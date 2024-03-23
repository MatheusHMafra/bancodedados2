/*
Sistema de Gerenciamento de Biblioteca
Objetivo: Desenvolver um sistema de banco de dados para gerenciar as operações de
uma biblioteca, incluindo o controle de livros, empréstimos e membros, usando PostgreSQL.

Questão 1 – Desenvolva o código SQL da criação do banco de dados de acordo com a
estrutura abaixo:
1. Efetue a criação do esquema Biblioteca;
2. Efetue a criação das tabelas abaixo no esquema Biblioteca:
Livros:
id_livro (chave primária, inteiro, autoincremento)
titulo (texto, não nulo)
autor (texto, não nulo)
ano_publicacao (inteiro)
disponivel (booleano, padrão: true)
Membros:
id_membro (chave primária, inteiro, autoincremento)
nome (texto, não nulo)
email (texto, único, não nulo)
data_cadastro (data, não nulo)
Empréstimos:
id_emprestimo (chave primária, inteiro, autoincremento)
id_livro (inteiro, chave estrangeira para Livros)
id_membro (inteiro, chave estrangeira para Membros)
data_emprestimo (data, não nulo)
data_devolucao (data)
Relacionamentos:
• Um Livro pode estar em vários Empréstimos, mas cada Empréstimo está
relacionado a um único Livro.
• Um Membro pode ter vários Empréstimos, mas cada Empréstimo está relacionado
a um único Membro.

Questão 2 – Efetuar a criação das triggers informadas abaixo. Deve-se testar o dispara do
trigger executando a/as funções correspondentes.
a. Trigger de Auditoria de Empréstimos: Criar um trigger que registre em uma tabela de
auditoria cada vez que um empréstimo for realizado.
b. Trigger de Verificação de Disponibilidade: Antes de um empréstimo ser efetivado,
verificar se o livro está disponível.
c. Trigger de Atualização de Disponibilidade: Após um empréstimo ser efetivado, atualizar
a disponibilidade do livro para false.
d. Trigger de Devolução de Livro: Quando um livro é devolvido, atualizar a disponibilidade
do livro para true.
f. Trigger de Limite de Empréstimos: Impedir que um membro faça mais de 5 empréstimos
simultâneos.
g. Trigger de Histórico de Empréstimos: Criar um histórico de todos os empréstimos feitos
por um membro.
h. Trigger de Atualização de Livros: Sempre que as informações de um livro forem
atualizadas, registrar a alteração em uma tabela de histórico.
i. Trigger de Exclusão de Membro: Quando um membro for excluído, verificar se todos os
livros foram devolvidos antes de permitir a exclusão.
j. Trigger de Verificação de E-mail Único: Assegurar que o e-mail cadastrado para um
novo membro seja único. Como o atributo já está definido como UNIQUE, faça uma
trigger para emitir uma mensagem indicando que o Email está duplicado e a que
membro ele pertence.
ATENÇÃO: Deverá ser postado no Material Didático (Intranet → Portal do Aluno) o código
SQL do que foi solicitado em cada questão em um ÚNICO arquivo SQL, demarcando com
comentário o começo e o fim de cada questão e alternativa, até às 23:59 do dia 22/03.
Dados para teste:

Tabela livros:
('Dom Quixote', 'Miguel de Cervantes', 1605),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943),
('Hamlet', 'William Shakespeare', 1603),
('Cem Anos de Solidão', 'Gabriel Garcia Márquez', 1967),
('Orgulho e Preconceito', 'Jane Austen', 1813),
('1984', 'George Orwell', 1949),
('O Senhor dos Anéis', 'J.R.R. Tolkien', 1954),
('A Divina Comédia', 'Dante Alighieri', 1320);

Tabela membros:
('Ana Silva', 'ana.silva@example.com', '2022-01-10'),
('Bruno Gomes', 'bruno.gomes@example.com', '2022-02-15'),
('Carlos Eduardo', 'carlos.eduardo@example.com', '2022-03-20'),
('Daniela Rocha', 'daniela.rocha@example.com', '2022-05-05'),
('Eduardo Lima', 'eduardo.lima@example.com', '2022-06-10'),
('Fernanda Martins', 'fernanda.martins@example.com', '2022-07-15'),
('Gustavo Henrique', 'gustavo.henrique@example.com', '2022-08-20'),
('Helena Souza', 'helena.souza@example.com', '2022-09-25');

Emprestimos:
(1, 1, '2022-04-01', NULL),
(2, 2, '2022-04-03', '2022-04-10'),
(3, 3, '2022-04-05', NULL),
(4, 4, '2022-10-01', NULL),
(5, 5, '2022-10-03', '2022-10-17'),
(2, 3, '2022-10-06', NULL),
(1, 2, '2022-10-08', '2022-10-15'),
(3, 1, '2022-10-10', NULL),
(3, 2, '2022-11-01', NULL),
(2, 3, '2022-11-03', NULL),
(1, 4, '2022-11-05', NULL),
(5, 1, '2022-11-07', '2022-11-21'),
(4, 5, '2022-11-09', '2022-11-23'),
(2, 1, '2022-11-12', NULL),
(3, 4, '2022-11-14', '2022-11-28'),
(1, 3, '2022-11-16', NULL),
(5, 2, '2022-11-18', '2022-11-25'),
(4, 1, '2022-11-20', '2022-12-04');
*/

-- Questão 1
SELECT schema_name FROM information_schema.schemata;
SHOW search_path;
CREATE SCHEMA Biblioteca;
SET search_path = Biblioteca;

CREATE TABLE Livros (
    id_livro SERIAL PRIMARY KEY,
    titulo TEXT NOT NULL,
    autor TEXT NOT NULL,
    ano_publicacao INT,
    disponivel BOOLEAN DEFAULT TRUE
);

CREATE TABLE Membros (
    id_membro SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    data_cadastro DATE NOT NULL
);

CREATE TABLE Emprestimos (
    id_emprestimo SERIAL PRIMARY KEY,
    id_livro INT,
    id_membro INT,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    FOREIGN KEY (id_livro) REFERENCES Livros(id_livro),
    FOREIGN KEY (id_membro) REFERENCES Membros(id_membro)
);

CREATE TABLE Auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_emprestimo INT,
    id_livro INT,
    id_membro INT,
    data_emprestimo DATE,
    data_devolucao DATE
);

CREATE TABLE HistoricoEmprestimos (
    id_historico SERIAL PRIMARY KEY,
    id_membro INT,
    id_emprestimo INT,
    id_livro INT,
    data_emprestimo DATE,
    data_devolucao DATE
);

CREATE TABLE HistoricoLivros (
    id_historico SERIAL PRIMARY KEY,
    id_livro INT,
    titulo TEXT,
    autor TEXT,
    ano_publicacao INT,
    disponivel BOOLEAN
);

-- Questão 2

-- Trigger de Auditoria de Empréstimos
CREATE OR REPLACE FUNCTION registrar_auditoria() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Auditoria (id_emprestimo, data_emprestimo, acao)
    VALUES (NEW.id_emprestimo, NEW.data_emprestimo, 'EMPRESTIMO REALIZADO');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auditoria_emprestimos
AFTER INSERT ON Emprestimos
FOR EACH ROW EXECUTE PROCEDURE registrar_auditoria();

-- Trigger de Verificação de Disponibilidade
CREATE OR REPLACE FUNCTION verificar_disponibilidade() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Livros WHERE id_livro = NEW.id_livro AND disponivel = TRUE) THEN
        RAISE EXCEPTION 'Livro não disponível';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificacao_disponibilidade
BEFORE INSERT ON Emprestimos
FOR EACH ROW EXECUTE PROCEDURE verificar_disponibilidade();


-- Trigger de Atualização de Disponibilidade
CREATE OR REPLACE FUNCTION atualizar_disponibilidade() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Livros SET disponivel = FALSE WHERE id_livro = NEW.id_livro;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizacao_disponibilidade
AFTER INSERT ON Emprestimos
FOR EACH ROW EXECUTE PROCEDURE atualizar_disponibilidade();

-- Trigger de Devolução de Livro
CREATE OR REPLACE FUNCTION devolver_livro() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Livros SET disponivel = TRUE WHERE id_livro = OLD.id_livro;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER devolucao_livro
AFTER UPDATE ON Emprestimos
FOR EACH ROW
WHEN (NEW.data_devolucao IS NOT NULL AND OLD.data_devolucao IS NULL)
EXECUTE PROCEDURE devolver_livro();

-- Trigger de Limite de Empréstimos
CREATE OR REPLACE FUNCTION limite_emprestimos() RETURNS TRIGGER AS $$
BEGIN
    DECLARE total_emprestimos INT;
    SELECT COUNT(*) INTO total_emprestimos FROM Emprestimos WHERE id_membro = NEW.id_membro AND data_devolucao IS NULL;
    IF total_emprestimos >= 5 THEN
        RAISE EXCEPTION 'Limite de empréstimos atingido';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER limite_emprestimos
BEFORE INSERT ON Emprestimos
FOR EACH ROW EXECUTE PROCEDURE limite_emprestimos();

-- Trigger de Histórico de Empréstimos
CREATE OR REPLACE FUNCTION historico_emprestimos() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO HistoricoEmprestimos (id_membro, id_emprestimo, id_livro, data_emprestimo, data_devolucao)
    VALUES (NEW.id_membro, NEW.id_emprestimo, NEW.id_livro, NEW.data_emprestimo, NEW.data_devolucao);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER historico_emprestimos
AFTER INSERT ON Emprestimos
FOR EACH ROW EXECUTE PROCEDURE historico_emprestimos();

-- Trigger de Atualização de Livros
CREATE OR REPLACE FUNCTION atualizacao_livros() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO HistoricoLivros (id_livro, titulo, autor, ano_publicacao, disponivel)
    VALUES (NEW.id_livro, NEW.titulo, NEW.autor, NEW.ano_publicacao, NEW.disponivel);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizacao_livros
AFTER UPDATE ON Livros
FOR EACH ROW EXECUTE PROCEDURE atualizacao_livros();

-- Trigger de Exclusão de Membro
CREATE OR REPLACE FUNCTION exclusao_membro() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Emprestimos WHERE id_membro = OLD.id_membro AND data_devolucao IS NULL) THEN
        RAISE EXCEPTION 'Membro possui empréstimos pendentes';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exclusao_membro
BEFORE DELETE ON Membros
FOR EACH ROW EXECUTE PROCEDURE exclusao_membro();

-- Trigger de Verificação de E-mail Único
CREATE OR REPLACE FUNCTION verificar_email_unico() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Membros WHERE email = NEW.email) THEN
        RAISE EXCEPTION 'E-mail duplicado';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificacao_email_unico
BEFORE INSERT ON Membros
FOR EACH ROW EXECUTE PROCEDURE verificar_email_unico();

-- Inserção de dados para teste
INSERT INTO Livros (titulo, autor, ano_publicacao) VALUES
('Dom Quixote', 'Miguel de Cervantes', 1605),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943),
('Hamlet', 'William Shakespeare', 1603),
('Cem Anos de Solidão', 'Gabriel Garcia Márquez', 1967),
('Orgulho e Preconceito', 'Jane Austen', 1813),
('1984', 'George Orwell', 1949),
('O Senhor dos Anéis', 'J.R.R. Tolkien', 1954),
('A Divina Comédia', 'Dante Alighieri', 1320);

INSERT INTO Membros (nome, email, data_cadastro) VALUES
('Ana Silva', 'ana.silva@example.com', '2022-01-10'),
('Bruno Gomes', 'bruno.gomes@example.com', '2022-02-15'),
('Carlos Eduardo', 'carlos.eduardo@example.com', '2022-03-20'),
('Daniela Rocha', 'daniela.rocha@example.com', '2022-05-05'),
('Eduardo Lima', 'eduardo.lima@example.com', '2022-06-10'),
('Fernanda Martins', 'fernanda.martins@example.com', '2022-07-15'),
('Gustavo Henrique', 'gustavo.henrique@example.com', '2022-08-20'),
('Helena Souza', 'helena.souza@example.com', '2022-09-25');

INSERT INTO Emprestimos (id_livro, id_membro, data_emprestimo, data_devolucao) VALUES
(1, 1, '2022-04-01', NULL),
(2, 2, '2022-04-03', '2022-04-10'),
(3, 3, '2022-04-05', NULL),
(4, 4, '2022-10-01', NULL),
(5, 5, '2022-10-03', '2022-10-17'),
(2, 3, '2022-10-06', NULL),
(1, 2, '2022-10-08', '2022-10-15'),
(3, 1, '2022-10-10', NULL),
(3, 2, '2022-11-01', NULL),
(2, 3, '2022-11-03', NULL),
(1, 4, '2022-11-05', NULL),
(5, 1, '2022-11-07', '2022-11-21'),
(4, 5, '2022-11-09', '2022-11-23'),
(2, 1, '2022-11-12', NULL),
(3, 4, '2022-11-14', '2022-11-28'),
(1, 3, '2022-11-16', NULL),
(5, 2, '2022-11-18', '2022-11-25'),
(4, 1, '2022-11-20', '2022-12-04');

SELECT * FROM Auditoria;

SELECT * FROM HistoricoEmprestimos;

SELECT * FROM HistoricoLivros;