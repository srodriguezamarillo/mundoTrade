begin /* 4 PROCEDIMIENTOS Y FUNCIONES */

/* A) Crear un procedimiento almacenado proc4_a que dado un rango de fechas retorne por parámetro cuantos 
enlaces se dieron de alta en dicho rango y cuál fue el mayor ancho de banda contratado. */

CREATE PROCEDURE proc4_a
@fechaINI DATE,
@fechaFIN DATE,
@cantEnlaces INT OUTPUT,
@mayorAnchoBanda INT OUTPUT
AS 
BEGIN
	SET @cantEnlaces = (SELECT COUNT(idEnlace) FROM ENLACE
						WHERE fchEnlace BETWEEN @fechaINI AND @fechaFIN)
	SET @mayorAnchoBanda = (SELECT DISTINCT TE.anchoTipo
							FROM TIPO_ENLACE TE, ENLACE E
							WHERE TE.codTipo=E.codTipo
							AND E.fchEnlace BETWEEN @fechaINI AND @fechaFIN
							AND TE.anchoTipo >=ALL (SELECT MAX(anchoTipo) FROM TIPO_ENLACE))
	PRINT @cantEnlaces 
	PRINT @mayorAnchoBanda
END

DECLARE @fechaINI DATE, @fechaFIN DATE, @cantEnlaces VARCHAR , @mayorAnchoBanda VARCHAR
EXEC proc4_a '20130101', '20160101', @cantEnlaces OUTPUT, @mayorAnchoBanda OUTPUT


/* B) Implementar una función fun4_b que reciba un código de sucursal y retorne el promedio pagado por enlaces 
en el año actual por dicha sucursal. */

CREATE FUNCTION fun4_b
(
@codSuc CHAR(10)
)
RETURNS INT
AS
BEGIN
	DECLARE @avgEnlaces INT
	SELECT @avgEnlaces =AVG(TE.precioTipo) 
						FROM TIPO_ENLACE TE, ENLACE E
						WHERE TE.codTipo=E.codTipo
						AND YEAR(GETDATE()) BETWEEN DATEPART(YYYY,E.fchEnlace) AND DATEPART(YYYY,e.fchFin)
						--AND DATEPART(YYYY,E.fchEnlace)=DATEPART(YYYY,GETDATE())
						AND E.codSuc=@codSuc 
	RETURN @avgEnlaces
END

SELECT dbo.fun4_b('urusuc0001')



/* C) Crear un procedimiento almacenado proc4_c que dado un ISP, una sucursal y un importe genere un enlace 
con la fecha del día, 30 días de vencimiento y con un tipo de enlace cuyo precio sea el importe pasado como 
parámetro, si este precio no existe entonces el inmediatamente superior, los campos correspondientes a la ip, 
mascara, puerta de enlace y DNS deben quedar con 0.0.0.0 */

CREATE PROCEDURE proc4_c 
@codIsp INT,
@codSuc CHAR(10),
@importe INT
AS
BEGIN
	IF @importe in (SELECT precioTipo FROM TIPO_ENLACE)
	BEGIN
		INSERT INTO ENLACE 
		(codSuc,codIsp,fchEnlace,fchFin,codTipo,ipEnlace,
		maskEnlace,gatewayEnlace,dns1Enlace,dns2Enlace)
		VALUES 
		(@codSuc,@codIsp,(SELECT GETDATE()),(SELECT DATEADD(DAY,30,GETDATE())),
		(SELECT codTipo FROM TIPO_ENLACE WHERE precioTipo=@importe),'0.0.0.0',
		'0.0.0.0','0.0.0.0','0.0.0.0','0.0.0.0')
	END
	ELSE
	BEGIN
		INSERT INTO ENLACE 
		(codSuc,codIsp,fchEnlace,fchFin,codTipo,ipEnlace,
		maskEnlace,gatewayEnlace,dns1Enlace,dns2Enlace)
		VALUES 
		(@codSuc,@codIsp,(SELECT GETDATE()),(SELECT DATEADD(DAY,30,GETDATE())), 
		(SELECT codTipo FROM TIPO_ENLACE 
		WHERE precioTipo>@importe and precioTipo <=(select min(precioTipo) 
													FROM TIPO_ENLACE 
													WHERE precioTipo>@importe)),
		'0.0.0.0','0.0.0.0','0.0.0.0','0.0.0.0','0.0.0.0')
	END	
END
                                                                               
DECLARE @codIsp int, @codSuc CHAR(10), @importe int
EXEC proc4_c 1, 'argsuc0001', 36

select * from tipo_enlace
select * from enlace

/* D) Crear una función fun4_d que dada una IP retorne el código de equipo asociado a dicha IP que tenga la 
garantía vencida, si están todos vigentes la función debe retornar ‘VIGENTES’  */

CREATE FUNCTION fun4_d
(
@IP VARCHAR(15)
)
RETURNS CHAR(10)
AS
BEGIN
	DECLARE @codEquipo CHAR(10)
	
	IF  EXISTS(SELECT codEquipo FROM EQUIPOS WHERE vtoEquipo<GETDATE())
	BEGIN		
		SELECT @codEquipo = EQ.codEquipo
							FROM EQUIPOS EQ, ENLACE E
							WHERE EQ.idEnlace = E.idEnlace
							AND E.ipEnlace = @IP
							AND EQ.vtoEquipo<GETDATE()
	END
	ELSE
	BEGIN
		SELECT @codEquipo='Vigentes'
	END
	RETURN @codEquipo
END

	SELECT * FROM EQUIPOS
	SELECT ipEnlace FROM ENLACE WHERE idEnlace=12
	DELETE FROM EQUIPOS WHERE vtoEquipo<GETDATE()

	SELECT dbo.fun4_d('192.169.2.2')


/* E) Definir el procedimiento proc4_e que cambie los estados de los Trunk a Activo para todos los Trunk que 
tengan estado diferente a Activo y cuyo Enlace fuera dado de alta en el mes corriente. */

CREATE PROCEDURE proc4_e
AS 
BEGIN
	UPDATE TRUNK
	SET stsTrunk='A'
	WHERE stsTrunk<>'A'
	AND DATEPART(MM,fchTrunk)=DATEPART(MM,GETDATE())
END

SELECT * FROM TRUNK

INSERT INTO trunk
VALUES	('brasuc0001','brasuc0002','20150605','I')

EXEC proc4_e

end