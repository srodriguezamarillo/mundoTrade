begin /* 5 TRIGGERS */

/* A) Crear el disparador trig5_a para que una vez ingresado un Trunk se genere un registro Enlace_Trunk 
para cada sucursal que compone dicho Trunk. */

CREATE TRIGGER trig5_a 
ON TRUNK
AFTER INSERT
AS
BEGIN

	insert into LogTriggers ([tipoTrigger],[fecha])
	values ('A',getdate())

	INSERT INTO Enlace_Trunk (idTrunk,idEnlace)
	(SELECT I.idTrunk, E.idEnlace FROM INSERTED I, enlace E WHERE E.codSuc=I.codSucOri)	
	INSERT INTO Enlace_Trunk (idTrunk,idEnlace)
	(SELECT I.idTrunk, E.idEnlace FROM INSERTED I, enlace E WHERE E.codSuc=I.codSucDes)	
END; 

select * from trunk
select * from Enlace_Trunk


/* B) Implementar un disparador trig5_b que no permita ingresar Enlaces si el precio del tipo de enlace 
supera el promedio total de precios de todos los enlaces contratados, de ser este el caso se debe mostrar un 
aviso por pantalla. */

CREATE TRIGGER trig5_b
ON ENLACE
INSTEAD OF INSERT
AS
BEGIN

	insert into LogTriggers ([tipoTrigger],[fecha])
	values ('B',getdate())

	IF (SELECT TE.precioTipo 
		FROM INSERTED I, TIPO_ENLACE TE
		WHERE I.codTipo=TE.codTipo)>(SELECT AVG(TE.precioTipo) 
									FROM TIPO_ENLACE TE, ENLACE E
									WHERE E.codTipo=TE.codTipo)
	BEGIN
		PRINT('Precio del tipo de enlace es superior al promedio total
			de precios de enlaces contratados')
	END
	ELSE
	BEGIN 
		INSERT INTO ENLACE
		(codSuc,codIsp,fchEnlace,fchFin,codTipo,ipEnlace,maskEnlace,gatewayEnlace,dns1Enlace,dns2Enlace)
		SELECT codSuc,codIsp,fchEnlace,fchFin,codTipo,ipEnlace,maskEnlace,gatewayEnlace,dns1Enlace,dns2Enlace
		FROM INSERTED	
	END
END;


/* C) Crear un disparador trig5_c que al borrar un enlace permita borrar en cascada todos los registros 
asociados a dicho enlace. */

CREATE TRIGGER trig5_c
ON ENLACE
INSTEAD OF DELETE
AS		
BEGIN

	insert into LogTriggers ([tipoTrigger],[fecha])
	values ('C',getdate())

	DELETE FROM EQUIPOS
	WHERE idEnlace in (SELECT idEnlace FROM DELETED)
	DELETE FROM ENLACE_TRUNK
	WHERE idEnlace in (SELECT idEnlace FROM DELETED)
	DELETE FROM ENLACE
	WHERE idEnlace in (SELECT idEnlace FROM DELETED)
END

DELETE FROM ENLACE
WHERE idEnlace=5

SELECT * FROM ENLACE
select * from logtriggers


/* D) Con el disparador trig5_d cada vez que se ingrese un registro al trunk de una sucursal con otra 
(A con B), registrar su opuesto (B con A). */

CREATE TRIGGER trig5_d
ON TRUNK
INSTEAD OF INSERT 
AS 
BEGIN
	INSERT INTO TRUNK(codSucOri,codSucDes,fchTrunk,stsTrunk)
	SELECT I.codSucDes, I.codSucOri, I.fchTrunk, I.stsTrunk
	FROM INSERTED I	 
END

INSERT INTO trunk
VALUES	('urusuc0001','urusuc0002','20150305','A')

SELECT * FROM TRUNK

/* Disparador que pasa a mayusculas el codigo de equipo*/

CREATE TRIGGER Mayus_codEquipo 
ON EQUIPOS
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO EQUIPOS
	SELECT UPPER(codEquipo),marcaEquipo,fchEquipo,vtoEquipo,idEnlace
	FROM INSERTED  
END

end


