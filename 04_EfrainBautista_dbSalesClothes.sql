/* Poner en uso base de datos MASTER */
USE master
GO

/* Si la base de datos ya existe la eliminamos */
DROP DATABASE IF EXISTS db_SalesClothes
GO

/* Crear base de datos Sales Clothes */
CREATE DATABASE db_SalesClothes
GO

/* Poner en uso la base de datos */
USE db_SalesClothes
GO

/* Crear tabla client */
CREATE TABLE client
(
	id int identity(1,1),
	type_document char(3),
	number_document char(15),
	names varchar(60),
	last_name varchar(90),
	email varchar(80),
	cell_phone char(9),
	birthdate date,
	active bit
	CONSTRAINT client_pk PRIMARY KEY (id)
)
GO

/* Crear tabla seller */
CREATE TABLE  seller
(
	id int identity(1,1),
	type_document char(3),
	numer_document char(15),
	names varchar(60),
	last_name varchar(90),
	salary decimal(8,2),
	cell_phone char(9),
	email varchar(80),
	active bit
	CONSTRAINT seller_pk PRIMARY KEY (id)
)
GO

/* Crear tabla clothes */
CREATE TABLE clothes
(
	id int identity(1,1),
	descriptions varchar(60),
	brand varchar(60),
	amount int,
	size varchar(10),
	price decimal(8,2),
	active bit
	CONSTRAINT clothes_pk PRIMARY KEY (id)
)
GO

/* Crear tabla sale */
CREATE TABLE sale
(
	id int identity(1,1),
	date_time datetime,
	seller_id int,
	client_id int,
	active bit
	CONSTRAINT sale_pk PRIMARY KEY (id)
)
GO

/* Crear tabla sale_detail */
CREATE TABLE sale_detail
(
	id int identity(1,1),
	sale_id int,
	clothes_id int,
	amount int
)
GO

/* Relacionar tabla sale con tabla client */
ALTER TABLE sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES client (id)
	ON UPDATE CASCADE 
	ON DELETE CASCADE
GO

/* Relacionar tabla sale con seller */
ALTER TABLE sale
	ADD CONSTRAINT sale_seller FOREIGN KEY (seller_id)
	REFERENCES seller (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
GO

/* Relacionar tabla sale_detail con clothes */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_clothes FOREIGN KEY (clothes_id)
	REFERENCES clothes (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
GO

/* Relacionar tabla sale con sale_detail */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
	REFERENCES sale (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
GO