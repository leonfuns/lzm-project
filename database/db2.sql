/*
 * Name:	FinSense
 * Version: 0.1.0
 * Update:	28/02/2024
 * Author:	Zoe
 */

--  *****************************************************************************************

--	Create lzmdb database if it does not exist.
DROP DATABASE IF EXISTS lzmdb;
CREATE DATABASE lzmdb;
USE lzmdb;

--	Create Users table to hold personal information of users.
--  Only for developers, this table has a password field managed with encryption, change frequency, 2-factor authentication.
DROP TABLE IF EXISTS Users;

CREATE TABLE Users(
	userID			INT				NOT NULL AUTO_INCREMENT PRIMARY KEY,
	email			VARCHAR(100)	NOT NULL, 
		CHECK (email LIKE '%@%'),
	password		VARCHAR(20)		NOT NULL,
	title			VARCHAR(12)		NULL, 
		CHECK (title IN (
						'Mr', 
						'Miss', 
						'Ms', 
						'Mrs',
						NULL
						)), -- DEFAULT IS NULL but CHECK IS NOT incluted NULL, so we cannot enter NULL.
	firstName		VARCHAR(20)		NOT NULL,
	lastName		VARCHAR(20)		NOT NULL,
	mobile			CHAR(10)		NOT NULL, 
		CHECK (LENGTH(mobile) = 10),
	addrStreet		VARCHAR(50)		NULL,
	addrCity		VARCHAR(15)		NULL,
	addrPostcode	CHAR(4)			NULL, 
		CHECK (LENGTH(addrPostcode) = 4 OR addrPostcode IN (NULL)), -- Defult IS NULL but CHECK LENGTH TO 4
    createDate		DATETIME		NOT NULL DEFAULT CURRENT_TIMESTAMP);

   
-- Create Income table for storing income information.
DROP TABLE IF EXISTS Income;

CREATE TABLE Income(
	incomeID	INT				NOT NULL AUTO_INCREMENT PRIMARY KEY,
	userID		INT				NOT NULL, -- NO fk, it will allow ANY userID even it's NOT EXISTS.
	company		VARCHAR(200)	NULL,
	industry	VARCHAR(100)	NULL,
	jobType		VARCHAR(15)		NULL,
		CHECK (jobType IN (
							'FullTime', 
							'PartTime', 
							'Casual', 
							'OtherIncome', 
							NULL
							)),
	POSITION	VARCHAR(50)		NULL,
	location	VARCHAR(200)	NULL,
	startDate	DATE			NOT NULL, -- Maybe we can consider the data type as DATE, only save the date without time.
	endDate		DATE			NULL, -- (Leon note: Check with status.) Ignore my note, and I'll be back to look next time.
	frequency	VARCHAR(15)		NOT NULL, 
		CHECK (frequency IN (
							'OneTime',
							'Weekly',
							'Fornightly',
							'Monthly',
							'Quarterly',
							'Seminannually',
							'Annual'
							)),
    status		BIT				NOT NULL,  -- binary, use 0 for on, 1 for off
	CONSTRAINT	FKinc_userID	FOREIGN KEY (userID) REFERENCES Users(userID)
    ) AUTO_INCREMENT = 101; -- Double auto_increment -- Zoe: tested, can not assign starting value directly, should be in the CREATE TABLE statement according to chatGPT... 

    
-- Create Salaries table for storing income breakdown.
DROP TABLE IF EXISTS Salaries;

CREATE TABLE Salaries(
	salaryID	INT			NOT NULL AUTO_INCREMENT PRIMARY KEY,
	incomeID	INT			NOT NULL, -- NO fk
	amount		INT			NOT NULL,
    salaryDate	DATE		NOT NULL, -- Maybe we can consider the data type as DATE, only save the date without time.
	note		TEXT		NULL,
	CONSTRAINT	FKsal_incomeID	FOREIGN KEY (incomeID) REFERENCES Income(incomeID)) AUTO_INCREMENT = 1001; -- Double auto_increment


-- Create Categories table for the categories of spendings and goals.
DROP TABLE IF EXISTS Categories;

CREATE TABLE Categories(
	categoryID		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	categoryName	VARCHAR(20) NOT NULL DEFAULT 'Uncateggorised'-- The longest word IS 18 IN your CHECK.
		CHECK (categoryName IN (
								'Food', 
								'Education', 
								'Entertainment', 
								'Groceries',
								'Health', 
								'Home', 
								'Shopping', 
								'SuperContributions', 
								'TaxPaid',
								'Travel',
								'Transfers', 
								'Transport', 
								'Utilities', 
								'Uncategorised' -- We have an uncategorised label FOR the USER; consider setting it as default if the user forgets to enter something.
								))) AUTO_INCREMENT = 3001; -- Double auto_increment

		 
-- 	Create Spendings for storing user spending details.
DROP TABLE IF EXISTS Spendings;

CREATE TABLE Spendings(
	spendingID	INT			NOT NULL AUTO_INCREMENT PRIMARY KEY,
	userID		INT			NOT NULL, -- NO fk
	categoryID	INT			NOT NULL, -- NO fk
	spDateTime	DATETIME	NOT NULL, -- Maybe we can consider the data type as DATE, only save the date without time.
	amount		INT			NOT NULL,
	note		TEXT		NULL,
	CONSTRAINT	FKsp_userID	FOREIGN KEY (userID) REFERENCES Users(userID),
	CONSTRAINT	FKsp_categoryID	FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
	) AUTO_INCREMENT = 9001; -- Double auto_increment
	

-- 	Create Goals for storing the goals of users.
DROP TABLE IF EXISTS Goals;

CREATE TABLE Goals(
	goalID		INT				NOT NULL AUTO_INCREMENT PRIMARY KEY,
	userID		INT				NOT NULL, -- NO fk
	categoryID	INT				NOT NULL, -- NO fk
	gName		VARCHAR(100)	NOT NULL,
	startDate	DATE			NOT NULL, -- Maybe we can consider the data type as DATE, only save the date without time.
	finalDate	DATE			NOT NULL,
	amount		INT				NOT NULL,
	note		TEXT			NULL,
	CONSTRAINT	FKgo_userID	FOREIGN KEY (userID) REFERENCES Users(userID),
	CONSTRAINT	FKgo_categoryID	FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
	) AUTO_INCREMENT = 4001; -- Double auto_increment


-- Create Investment Types table for the investments.
DROP TABLE IF EXISTS InvestType;

CREATE TABLE InvestType(
	investTypeID	INT				NOT NULL AUTO_INCREMENT PRIMARY KEY,
	investType		VARCHAR(20)		NOT NULL, 
		CHECK (investType IN (
								'Stock', 
								'Bond',
								'Crypto', 
								'OtherInvestment'
								)) -- the longest word is 15
    ) AUTO_INCREMENT = 5001; -- Double auto_increment

   
-- Create Investments table for recording investments.
DROP TABLE IF EXISTS Investments;

CREATE TABLE Investments(
	investmentID	INT			NOT NULL AUTO_INCREMENT PRIMARY KEY,
	userID			INT			NOT NULL, -- NO fk
	categoryID		INT			NOT NULL, -- NO fk
	investAmount	INT			NOT NULL,
	startDate		DATE		NOT NULL, -- Maybe we can consider the data type as DATE, only save the date without time.
	maturityDate	DATE		NULL,
	marketValue		INT			NULL,
	investReturn	INT			NOT NULL DEFAULT 0,
	  CHECK (investReturn >= 0 AND investReturn <= 100),
	CONSTRAINT	FKinv_userID	FOREIGN KEY (userID) REFERENCES Users(userID),
	CONSTRAINT	FKinv_categoryID	FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
	) AUTO_INCREMENT = 6001; -- Double auto_increment

--	**************************************************************************************
--	Insert data into database.
--	**************************************************************************************
