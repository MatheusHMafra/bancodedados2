--[[Criar Tabelas]]--
CREATE TABLE Cliente (
    ID_Cliente INT PRIMARY KEY,
    Nome VARCHAR(100),
    Data_Nasc DATE,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20),
    Email VARCHAR(75)
);

CREATE TABLE Pedido (
    ID_Pedido INT PRIMARY KEY,
    DataHora TIMESTAMP WITHOUT TIME ZONE,
    ID_Cliente INT REFERENCES Cliente(ID_Cliente) ON UPDATE CASCADE ON DELETE CASCADE,
    Status VARCHAR(255),
    Total VARCHAR(75)
);

CREATE TABLE Item_Cardapio (
    ID_Item INT PRIMARY KEY,
    Nome VARCHAR(100),
    Descrição TEXT,
    Preço DECIMAL(10,2)
);

CREATE TABLE Item_Pedido (
    ID_Pedido INT REFERENCES Pedido(ID_Pedido) ON UPDATE CASCADE ON DELETE CASCADE,
    ID_Item INT REFERENCES Item_Cardapio(ID_Item) ON UPDATE CASCADE ON DELETE CASCADE,
    Quantidade INT,
    PRIMARY KEY (ID_Pedido, ID_Item)
);

--[[Inserir valores]]--
INSERT INTO Cliente VALUES
(1,'Anna Briggs','2023-11-06','Lawson Square, 13356','732-864-7316','martinpatricia@cain-smith.com'),
(2,'Jeremy Thompson','1998-05-04','USS Medina, 21470','523-272-4776','kimberlycannon@quinn.info'),
(3,'Dakota Lloyd','1976-10-27','Reed Ferry, 305','01-566-218-0500','wmoore@gutierrez-cole.com'),
(4,'Danny Potter','1958-03-18','USS Gibson, 424','01-441-053-3778','joel28@thomas-rosales.org'),
(5,'Carolyn Stevens','1948-07-07', 'Willie Walks Suite 019','001-183-448-8354','williamgreen@gmail.com'),
(6,'Kara Perkins','1992-08-07','Esparza Pines, 86115','001-372.224.2758','melodyholt@yahoo.com'),
(7,'Luis Evans','1968-02-23','John Island Suite, 074','+1-894-341-5025','qtucker@gmail.com'),
(8,'Amber West','1999-07-10', 'Peters Mountain Suite, 063','(164)470-2706','rhorton@wright-reed.biz'),
(9,'Stephanie Fox','1998-05-04','Myers Field, 385','001-391-492-3087','halljessica@yahoo.com'),
(10,'Tamara Schwartz','2010-01-20','USNS Long, 58200','+1-942-840-1333','charlotte91@gmail.com');

INSERT INTO Item_Cardapio VALUES
(1,'Pizza Margherita','Tradicional pizza com molho de tomate, queijo mozzarella e manjericão',44.21),
(2,'Hambúrguer Gourmet','Hambúrguer de carne bovina com queijo, alface, tomate e molho especial',16.95),
(3,'Salada Caesar','Salada com alface romana, croutons, queijo parmesão e molho Caesar', 47.67),
(4,'Sushi Sashimi','Variedade de sashimi de salmão, atum e peixe branco',14.70),
(5,'Spaghetti Carbonara','Espaguete com molho cremoso de ovos, queijo parmesão, bacon e pimenta preta',20.92),
(6,'Frango Assado','Frango assado com ervas e especiarias, servido com vegetais',45.45),
(7,'Tacos Mexicanos','Tacos com carne moída, alface, queijo, tomate e molho picante',19.79),
(8,'Sorvete de Baunilha','Sorvete cremoso de baunilha com opções de cobertura',35.38),
(9,'Lasanha à Bolonhesa','Camadas de massa, carne moída, molho de tomate e queijo',40.56),
(10,'Pad Thai','Macarrão tailandês frito com camarões, amendoim, broto de feijão e limão',46.65);

INSERT INTO Pedido VALUES
(1,'2024-02-14 03:53:23.704596',4,'Cancelado',45.76),
(2,'2024-01-31 19:50:23.704699',10,'Finalizado',57.11),
(3,'2024-01-28 11:32:23.704728',4,'Finalizado',25.19),
(4,'2024-02-20 10:08:23.704749',2,'Cancelado',88.64),
(5,'2024-02-11 10:40:23.704769',3,'Finalizado',54.01),
(6,'2024-02-10 02:06:23.704789',5,'Pendente',63.14),
(7,'2024-02-13 10:44:23.704807',10,'Finalizado',33.45),
(8,'2024-02-01 07:15:23.704826',3,'Pendente',20.43),
(9,'2024-02-01 02:02:23.704845',9,'Pendente',87.72),
(10,'2024-02-04 04:23:23.704864',2,'Cancelado',21.87);

INSERT INTO Item_Pedido VALUES
(1,8,2),(2,1,5),(3,2,1),(4,6,4),(5,1,5),
(6,1,5),(7,6,1),(8,3,1),(9,9,2),(10,4,1),
(2,2,3),(2,7,2),(5,2,3),(5,7,3),(7,5,2),
(7,10,4),(8,5,3),(8,10,5),(8,9,1),(7,4,1);

--[[Queries]]
-- a. Apresentar todos os clientes em ordem alfabética;
SELECT * FROM Cliente ORDER BY Nome;

-- b. Torne a coluna Telefone como não nula e única.
ALTER TABLE Cliente 
ALTER COLUMN Telefone SET NOT NULL,
ADD CONSTRAINT unique_telefone UNIQUE (Telefone);

-- c. Apresentar os itens do cardápio que não contêm “queijo”;
SELECT * FROM Item_Cardapio WHERE LOWER(Nome) NOT LIKE '%queijo%';

-- d. Exibir todos os pedidos, incluindo os nomes dos respectivos clientes;
SELECT Pedido.*, Cliente.Nome AS Nome_Cliente 
FROM Pedido 
INNER JOIN Cliente ON Pedido.ID_Cliente = Cliente.ID_Cliente;

-- e. Delete o pedido número 5.
DELETE FROM Pedido WHERE ID_Pedido = 5;

-- f. Calcular a idade de cada cliente e apresentá-los de forma crescente.
SELECT *, EXTRACT(YEAR FROM AGE(NOW(), Data_Nasc)) AS idade FROM Cliente ORDER BY idade;

-- g. Excluir clientes menores de 18 anos.
DELETE FROM Cliente WHERE EXTRACT(YEAR FROM AGE(NOW(), Data_Nasc)) < 18;

-- h. Crie a coluna Data_Cadastro na tabela Cliente, usando como valor Default a data atual.
ALTER TABLE Cliente ADD COLUMN Data_Cadastro DATE DEFAULT CURRENT_DATE;

-- i. Crie a coluna "Gluten_Free" e "Is_Vegano" na tabela "Item_Cardapio", defina ambas as colunas como False.
ALTER TABLE Item_Cardapio ADD COLUMN Gluten_Free BOOLEAN DEFAULT FALSE;
ALTER TABLE Item_Cardapio ADD COLUMN Is_Vegano BOOLEAN DEFAULT FALSE;

-- j. Apresente os pedidos, os respectivos clientes, nome do item pedido, a quantidade total deste item e o valor total. O resultado deve ser ordenado pelo número do pedido.
SELECT Pedido.ID_Pedido, Cliente.Nome AS Nome_Cliente, Item_Cardapio.Nome AS Nome_Item, 
SUM(Item_Pedido.quantidade) AS Quantidade_Total, SUM(Item_Pedido.quantidade * Item_Cardapio.Preco) AS Valor_Total
FROM Pedido
INNER JOIN Cliente ON Pedido.ID_Cliente = Cliente.ID_Cliente
INNER JOIN Item_Pedido ON Pedido.ID_Pedido = Item_Pedido.ID_Pedido
INNER JOIN Item_Cardapio ON Item_Pedido.ID_Item = Item_Cardapio.ID_Item
GROUP BY Pedido.ID_Pedido, Cliente.Nome, Item_Cardapio.Nome
ORDER BY Pedido.ID_Pedido;

-- k. Altere o nome da coluna "Data_Cadastro" da tabela "Cliente" para "Dt_Cadastro".
ALTER TABLE Cliente RENAME COLUMN Data_Cadastro TO Dt_Cadastro;

-- l. Atualizar o campo “Total” da tabela “Pedido”, com base no valor dos itens do pedido multiplicados pela quantidade.
UPDATE Pedido
SET Total = subquery.total_pedido
FROM (
    SELECT ID_Pedido, SUM(quantidade * preco) AS total_pedido
    FROM Item_Pedido
    INNER JOIN Item_Cardapio ON Item_Pedido.ID_Item = Item_Cardapio.ID_Item
    GROUP BY ID_Pedido
) AS subquery
WHERE Pedido.ID_Pedido = subquery.ID_Pedido;

-- m. Apresentar o número de pedidos de cada cliente, apresentando os atributos código do cliente, nome do cliente, número de pedidos e o valor total dos pedidos. Apresente o resultado ordenado decrescente por gastos.
SELECT Cliente.ID_Cliente, Cliente.Nome, COUNT(Pedido.ID_Pedido) AS Numero_Pedidos, SUM(Pedido.Total) AS Valor_Total_Pedidos
FROM Cliente
LEFT JOIN Pedido ON Cliente.ID_Cliente = Pedido.ID_Cliente
GROUP BY Cliente.ID_Cliente
ORDER BY Valor_Total_Pedidos DESC;

-- n. Listar todos os itens de cada Pedido, incluindo o nome do item e a quantidade.
SELECT Pedido.ID_Pedido, Item_Cardapio.Nome AS Nome_Item, Item_Pedido.quantidade
FROM Pedido
INNER JOIN Item_Pedido ON Pedido.ID_Pedido = Item_Pedido.ID_Pedido
INNER JOIN Item_Cardapio ON Item_Pedido.ID_Item = Item_Cardapio.ID_Item
ORDER BY Pedido.ID_Pedido;

-- o. Apresentar os clientes que fizeram mais de 1 pedido, mostrando o número total de pedidos e o valor total correspondente
SELECT Cliente.ID_Cliente, Cliente.Nome, COUNT(Pedido.ID_Pedido) AS Numero_Pedidos, SUM(Pedido.Total) AS Valor_Total_Pedidos
FROM Cliente
INNER JOIN Pedido ON Cliente.ID_Cliente = Pedido.ID_Cliente
GROUP BY Cliente.ID_Cliente
HAVING COUNT(Pedido.ID_Pedido) > 1;

--[[Criar View]]
CREATE VIEW VisaoDetalhesPedidos AS SELECT Cliente.Nome AS Nome_Cliente, Pedido.DataHora AS Data_Hora, Pedido.Total AS Total, Item_Cardapio.Nome AS Item, Item_Pedido.quantidade AS Quantidade 
FROM Pedido 
INNER JOIN Cliente ON Pedido.ID_Cliente = Cliente.ID_Cliente 
INNER JOIN Item_Pedido ON Pedido.ID_Pedido = Item_Pedido.ID_Pedido 
INNER JOIN Item_Cardapio ON Item_Pedido.ID_Item = Item_Cardapio.ID_Item;