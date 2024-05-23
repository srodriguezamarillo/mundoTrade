/*     DATOS DE PRUEBA INCORRECTOS     */

BEGIN 

INSERT INTO Sucursal
VALUES  ('urusuc0002','Datauru','Uruguay','Tacuarembo','Rodriguez','urucenter@mundotrade.com','01159802123457'),
		('brasuc0003','Omundo','Brasil','Brasilia','Dominguez','telebrasil@mundotrade.com','00569802123458') 
		
		--El mail de cada Sucursal debe ser unico.


INSERT INTO Isp
VALUES	('isp arg','00549802123458','Pedro Varela','prov@ispuru.com','Argentina'),
		('isp bra','00569802123458','Manuel Oribe','prov@ispuru.com','Brasil')

		--El mail de cada Isp debe ser unico


INSERT INTO tipo_enlace
VALUES	('tipotr0001','Otro tipo de conexion','Otros','0','25'),
		('tipwif0001','Conexion mediante wifi','Wifi','10','75')

		--Los tipos de conexion deben ser ('Fibra','Ethernet','Cable','Aire','Otros')
		--El ancho de banda siempre es mayor o igual a 1


INSERT INTO equipos
VALUES	('abc-555588','ABC','20151212','20181004',21),
		('cis-955588','Cisco','20151212','20181004',21)
		
		--Los 3 caracteres alfabeticos del codigo del equipo deben estar en mayusculas


INSERT INTO trunk
VALUES	('brasuc0001','argsuc0002','20150705','W'),
		('brasuc0001','argsuc0001','20150305','F')

		--El estado del trunk debe ser A=Activo, D=Desactivado, I=Inestable, X=Desconocido.

end