--1

CREATE VIEW view1 AS
(
SELECT e.marcaEquipo, count(e.codEquipo)[cantidad]
FROM EQUIPOS e
GROUP BY e.marcaEquipo
HAVING COUNT(*)>3
)

select * from view1

--2
create table LogTriggers
(
	codigo int identity (1,1) primary key,
	tipoTrigger CHAR(1) check (tipoTrigger in ('A','B','C')),
	fecha date
)

--3
CREATE PROCEDURE proc3 
@pais varchar(15),
@cantSucursales INT OUTPUT
AS
BEGIN
	set @cantSucursales = (select count(*) from sucursal
							where paisSuc= @pais)

	print @cantSucursales
	
END

DECLARE @codIsp VARCHAR(15), @cantSucursales int
EXEC proc3 'uruguay', @cantSucursales OUTPUT


