CREATE DATABASE TestTask
GO
USE TestTask

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


-------Task 1-------
-------Task 2-------
-------Task 3-------
-------Task 4-------
-------Task 5-------
-------Task 6-------
-------Task 7-------
-------Task 8-------