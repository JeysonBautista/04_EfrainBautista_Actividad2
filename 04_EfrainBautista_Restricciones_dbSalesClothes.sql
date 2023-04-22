/* Poner en uso db_SalesClothes */
USE db_SalesClothes
GO

/* Ver SQL Collate en SQL Server */
SELECT SERVERPROPERTY('collation') AS ServerCollation
GO

/* Ver idioma de SQL Server */
SELECT @@language AS 'Idioma'
GO

/* Ver idiomas disponibles en SQL Server */
EXEC sp_helplanguage
GO

/* Configurar idioma español en el servidor */
SET LANGUAGE Español
GO
SELECT @@language AS 'Idioma'
GO

/* Ver formato de fecha y hora del servidor */
SELECT sysdatetime() as 'Fecha y  hora'
GO

/* Configurar el formato de fecha */
SET DATEFORMAT dmy
GO

/* Listar tablas de la base de datos db_SalesClothes */
SELECT * FROM INFORMATION_SCHEMA.TABLES
GO

/* Ver estructura de una tabla */
EXEC sp_help 'dbo.client'
GO

/* Campo autoincrementable en client */
ALTER TABLE client
	ALTER COLUMN id int identity(1,1) -- esto no funciona
GO


/* Ver relaciones creadas entre las tablas de la base de datos */
SELECT 
    fk.name [Constraint],
    OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna FK],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna PK]
FROM 
    sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
GO


/* Eliminar relación sale_client */
ALTER TABLE sale
	DROP CONSTRAINT sale_client
GO


ALTER TABLE client
	DROP CONSTRAINT client_pk
GO

/* Quitar columna id en tabla cliente */
ALTER TABLE client
	DROP COLUMN id
GO

/* Agregar columna client */
ALTER TABLE client
	ADD id int identity(1,1)
GO

/* Agregar restricción primary key */
ALTER TABLE client
	ADD CONSTRAINT client_pk 
	PRIMARY KEY (id)
GO

/* Relacionar tabla sale con tabla client */
ALTER TABLE sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES client (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* El tipo de documento puede ser DNI ó CNE */
ALTER TABLE client
	DROP COLUMN type_document
GO

/* Agregar restricción para tipo documento */
ALTER TABLE client
	ADD type_document char(3)
	CONSTRAINT type_document_client 
	CHECK(type_document ='DNI' OR type_document ='CNE')
GO

/* Eliminar columna number_document de tabla client */
ALTER TABLE client
	DROP COLUMN number_document
GO

/* El número de documento sólo debe permitir dígitos de 0 - 9 */
ALTER TABLE client
	ADD number_document char(9)
	CONSTRAINT number_document_client
	CHECK (number_document like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][^A-Z]')
GO

/* Eliminar columna email de tabla client */
ALTER TABLE client
	DROP COLUMN email
GO

/* Agregar columna email */
ALTER TABLE client
	ADD email varchar(80)
	CONSTRAINT email_client
	CHECK(email LIKE '%@%._%')
GO

/* Eliminar columna celular */
ALTER TABLE client
	DROP COLUMN cell_phone
GO

/* Validar que el celular esté conformado por 9 números */
ALTER TABLE client
	ADD cell_phone char(9)
	CONSTRAINT cellphone_client
	CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

/* Eliminar columna fecha de nacimiento */
ALTER TABLE client
	DROP COLUMN birthdate
GO

/* Sólo debe permitir el registro de clientes mayores de edad */
ALTER TABLE client
	ADD  birthdate date
	CONSTRAINT birthdate_client
	CHECK((YEAR(GETDATE())- YEAR(birthdate )) >= 18)
GO

/* Eliminar columna active de tabla client */
ALTER TABLE client
	DROP COLUMN active
GO

/* El valor predeterminado será activo al registrar clientes */
ALTER TABLE client
	ADD active bit DEFAULT (1)
GO

/* Listar las restricciones de la tabla client */
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'client'
GO

/* Insertar 6 registros */
INSERT INTO client 
(type_document, number_document, names, last_name, email, cell_phone, birthdate)
VALUES
('DNI', '78451233', 'Fabiola', 'Perales Campos', 'fabiolaperales@gmail.com', '991692597', '19/01/2005'),
('DNI', '14782536', 'Marcos', 'Dávila Palomino', 'marcosdavila@gmail.com', '982514752', '03/03/1990'),
('DNI', '78451236', 'Luis Alberto', 'Barrios Paredes', 'luisbarrios@outlook.com', '985414752', '03/10/1995'),
('CNE', '352514789', 'Claudia María', 'Martínez Rodríguez', 'claudiamartinez@yahoo.com', '995522147', '23/09/1992'),
('CNE', '142536792', 'Mario Tadeo', 'Farfán Castillo', 'mariotadeo@outlook.com', '973125478', '25/11/1997'),
('DNI', '58251433', 'Ana Lucrecia', 'Chumpitaz Prada', 'anachumpitaz@gmail.com', '982514361', '17/10/1992')
GO


/* Listar registros de tabla client */
SELECT * FROM client 
GO


/* Listar apellidos, nombres, celular y fecha de nacimiento */
SELECT
	last_name as 'APELLIDOS',
	names as 'NOMBRES',
	cell_phone as 'CELULAR',
	format(birthdate, 'd', 'es-ES') as 'FEC. NACIMIENTO'
FROM
	client
GO


/* Listar apellidos, nombres, email y celular de clientes que tienen DNI y su respectivo número*/
SELECT
	last_name as 'APELLIDOS',
	names as 'NOMBRE',
	email as 'EMAIL',
	type_document as 'DOCUMENTO',
	number_document as '# DOC.'
FROM
	client
WHERE
	type_document = 'DNI'
GO


/* Listar apellidos, nombres, edad, email y fecha de cumpleaños */
SELECT
	id as 'ITEM',
	CONCAT(UPPER(last_name), ',', names) as 'CLIENTE',
	(YEAR(GETDATE()) - YEAR(birthdate)) as 'EDAD',
	email as 'EMAIL',
	FORMAT(birthdate, 'dd-MMM', 'es-ES') as 'CUMPLEAÑOS'
FROM
	client 
GO

/* Eliminar lógicamente el cliente cuyo DNI es 58251433  */
UPDATE client
SET active = '0' 
WHERE number_document = '58251433'
GO

/* Listar clientes */
SELECT * FROM client
GO

/* La fecha de nacimiento de Marcos Dávila Palomino es el 16/06/1989 */
UPDATE client 
SET birthdate = '16/06/1989'
WHERE names = 'Marcos' and last_name = 'Dávila Palomino'
GO

/* Listar los nuevos datos de Marcos Dávila Palomino */
SELECT * FROM client 
WHERE names = 'Marcos' AND last_name = 'Dávila Palomino'
GO

/* El nuevo número de celular del cliente de CNE # 142536792 es 977815352 */
UPDATE client
SET cell_phone = '977815352'
WHERE type_document = 'CNE' AND number_document = '142536792'
GO

/* Verificar que el cambio de celular se ha realizado */
SELECT 
       * 
FROM CLIENT
WHERE cell_phone = '977815352'
GO


/* Eliminar físicamente los clientes nacidos en el año 1992 */
 DELETE FROM client 
 WHERE YEAR (birthdate) = '1992'
 GO

/* Listar clientes y verificar */
 SELECT * FROM client
 GO

 
/* Eliminar cliente de número de celular 991692597 */
DELETE FROM client
WHERE cell_phone = '991692597'
GO

/* Verificar la eliminación listando los registros */
SELECT * FROM client
GO

/* Eliminar los registros de la tabla cliente */
DELETE FROM client
GO

/* Listar los registros de la tabla cliente */
SELECT * FROM client
GO










