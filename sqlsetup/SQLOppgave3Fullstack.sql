/*
Erlend B. Ugelstad
Kristiansund
*/

--Reset
drop database if exists Oppgave3Fullstack
GO

--Create
create database Oppgave3Fullstack
GO

--Set Active
use Oppgave3Fullstack
GO

--Initialize
set dateformat dmy
GO

--Setup
create table t_User (
	UserID bigint primary key identity(1,1) not null,
	UserName nvarchar(100) unique not null,
	Email nvarchar(100) unique not null,
	Password varbinary(4000) not null,
	Salt nvarchar(4000)
)
GO

create table t_UserTokens (
	ID bigint primary key identity(1,1) not null,
	DateCreated datetime default getDate() not null,
	UserID bigint unique not null,
	Token varbinary(4000) not null,
	TokenValidDate datetime not null
)
GO

create table t_InsertLog (
	ID bigint primary key identity(1,1) not null,
	DateCreated datetime default getDate() not null,
	UserID bigint,
	Type nvarchar(50),
	Info nvarchar(1000)
)
GO

create table t_UpdateLog (
	ID bigint primary key identity (1,1) not null,
	DateCreated datetime default getdate() not null,
	UserID bigint,
	Type nvarchar(50),
	Info nvarchar(1000)
)
GO