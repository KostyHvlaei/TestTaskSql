CREATE DATABASE TestTaskTmp
GO
USE TestTaskTmp

-------DDL Part-------
CREATE TABLE dbo.Banks(
    Id int PRIMARY KEY IDENTITY(0, 1),
    Name varchar(20) NOT NULL,
)

CREATE TABLE dbo.SocialGroups(
    Id int PRIMARY KEY IDENTITY(0, 1),
    Name nvarchar(20)
)

CREATE TABLE dbo.Cities(
    Id int PRIMARY KEY IDENTITY(0, 1),
    Name varchar(20) NOT NULL
)
GO

CREATE TABLE dbo.Clients(
    Id int PRIMARY KEY IDENTITY(0, 1),
    FirstName nvarchar(20) NOT NULL ,
    LastName nvarchar(20) NOT NULL ,
    SocialGroupId INT NOT NULL,
    FOREIGN KEY (SocialGroupId) REFERENCES SocialGroups(Id)
)
GO

CREATE TABLE dbo.BranchOffices(
    Id int PRIMARY KEY IDENTITY(0, 1),
    CityId int NOT NULL,
    BankId int NOT NULL,
    FOREIGN KEY (CityId) REFERENCES Cities(Id),
    FOREIGN KEY (BankId) REFERENCES Banks(Id)
)

CREATE TABLE dbo.Accounts(
    BankId int NOT NULL,
    ClientId int NOT NULL,
    Amount money DEFAULT 0,
    PRIMARY KEY (ClientId, BankId),
    FOREIGN KEY (BankId) REFERENCES Banks(Id),
    FOREIGN KEY (ClientId) REFERENCES Clients(Id)
)
GO

CREATE TABLE dbo.Cards(
    Id int PRIMARY KEY IDENTITY(0, 1),
    Amount money DEFAULT 0,
    ClientID int,
    BankID int,
    FOREIGN KEY (ClientID, BankID) REFERENCES Accounts(ClientId, BankID)
)
GO
-------Inserting values-------
INSERT INTO Banks (Name) VALUES
('BelarusBank'),
('BelinvestBank'),
('SberBank'),
('Priorbank'),
('GazpromBank')

INSERT INTO SocialGroups (Name) VALUES
('Child'),
('Employer'),
('Unemployed'),
('Retiree'),
('VIP')

INSERT INTO Cities (Name) VALUES
('Minsk'),
('Brest'),
('Vitebsk'),
('Grodno'),
('Gomel')
GO

INSERT INTO Clients (FirstName, LastName, SocialGroupId) VALUES
('Ivan', 'Petrov', 0),
('Vitaly', 'Vasiliev', 1),
('Vladislav', 'Zaicev', 1),
('Maxim', 'Petrov', 3),
('Nikita', 'Buyanov', 2)

GO

INSERT INTO BranchOffices (CityId, BankId) VALUES
(0, 0),
(1, 0),
(2, 3),
(2, 4),
(3, 2)

INSERT INTO Accounts (ClientId, BankId, Amount) VALUES
(0, 0, 1000),
(0, 1, 1200),
(1, 1, 4000),
(2, 1, 900),
(3, 0, 1100)
GO

INSERT INTO Cards (Amount, ClientID, BankID) VALUES
(200, 0 , 0),
(300, 0 , 0),
(700, 0 , 1),
(3500, 1 , 1),
(150, 3 , 0)
GO

-------Task 1-------
DECLARE @CityX nvarchar(20) = 'Vitebsk'

SELECT b.Name, c.Name FROM BranchOffices as bo
JOIN Banks b on b.Id = bo.BankId
JOIN Cities c on c.Id = bo.CityId
WHERE c.Name = @CityX
GO

-------Task 2-------
SELECT c.FirstName AS HolderName, card.Amount as Amount, b.Name as BankName
FROM Cards card
JOIN Banks b ON card.BankID = b.Id
JOIN Clients c ON card.ClientID = c.Id
GO

-------Task 3-------
SELECT acc.BankId, acc.ClientId, acc.Amount, SUM(card.Amount) AS SumCardsAmount
FROM Accounts acc
JOIN Cards card ON acc.ClientId = card.ClientID AND acc.BankId = card.BankID
GROUP BY acc.BankId, acc.ClientId, acc.Amount
HAVING acc.Amount <> SUM(card.Amount)
GO

-------Task 4-------
SELECT sc.Name AS SoicailState, COUNT(card.ClientID) AS CountOfCards
FROM SocialGroups AS sc
JOIN Clients c ON c.SocialGroupId = sc.Id
JOIN Cards card ON card.ClientID = c.Id
GROUP BY sc.Name
GO

--TODO: Избавится от костыля
SELECT DISTINCT sc.Name AS SocialState,
       (SELECT COUNT(*) FROM Cards crd WHERE crd.ClientID = c.Id AND c.Id = sc.Id) AS CountOfCards
FROM SocialGroups AS sc
JOIN Clients c ON c.SocialGroupId = sc.Id
JOIN Cards card ON card.ClientID = c.Id
GO

-------Task 5-------
CREATE PROCEDURE AddTenDollarsToSocStatus @soc_state_id INT AS
BEGIN
    --Main proc
    IF (SELECT COUNT(*) FROM SocialGroups WHERE Id = @soc_state_id) = 0
    BEGIN
        PRINT 'There is no social status with this id'
        RETURN
    END;

    IF (SELECT COUNT(*) FROM Accounts
        JOIN Clients c on c.Id = Accounts.ClientId
        WHERE c.SocialGroupId = @soc_state_id) = 0
    BEGIN
        PRINT 'There is no account with holder with this social status'
        RETURN
    END;

    UPDATE Accounts SET Amount = Amount + 10
    WHERE (SELECT SocialGroupId FROM Clients c WHERE c.Id = ClientId) = @soc_state_id
END;
GO

--Test:
DECLARE @soc_state_id INT = 2

SELECT Amount, c.FirstName, c.SocialGroupId FROM Accounts
JOIN Clients c on c.Id = Accounts.ClientId
WHERE c.SocialGroupId = @soc_state_id

EXEC AddTenDollarsToSocStatus @soc_state_id

SELECT Amount, c.FirstName, c.SocialGroupId FROM Accounts
JOIN Clients c on c.Id = Accounts.ClientId
WHERE c.SocialGroupId = @soc_state_id
GO

-------Task 6-------


-------Task 7-------


-------Task 8-------