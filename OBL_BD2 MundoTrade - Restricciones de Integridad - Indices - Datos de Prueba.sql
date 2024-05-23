begin /* 1 - Restricciones de Integridad */

/*TABLA SUCURSAL*/

ALTER TABLE Sucursal
ADD CONSTRAINT [Suc_Id_codSuc] 
PRIMARY KEY ([codSuc]);

ALTER TABLE Sucursal
ADD CONSTRAINT [mailSuc_Unique] 
UNIQUE ([mailSuc]);


/*TABLA ISP*/

ALTER TABLE Isp
ADD CONSTRAINT [Isp_Id] 
PRIMARY KEY ([codIsp]);

ALTER TABLE Isp
ADD CONSTRAINT [mailIsp_Unique] 
UNIQUE ([mailIsp]);


/*TABLA TIPOS DE ENLACE*/

ALTER TABLE Tipo_Enlace
ADD CONSTRAINT [TipoEnlace_Id_codTipo] 
PRIMARY KEY ([codTipo]);

ALTER TABLE Tipo_Enlace
ADD CONSTRAINT [CK_tipoEnlace_medioTipo]
CHECK ([medioTipo] in ('Fibra','Ethernet','Cable','Aire','Otros'));

ALTER TABLE Tipo_Enlace
ADD CONSTRAINT [CK_tipoEnlace_anchoTipo]
CHECK ([anchoTipo]>=1);


/*TABLA ENLACE*/

ALTER TABLE Enlace
ADD CONSTRAINT [Enlace_Id_idEnlace] 
PRIMARY KEY ([idEnlace]);

ALTER TABLE Enlace
ADD CONSTRAINT [FK_enlace_codSuc]
FOREIGN KEY ([codSuc]) 
REFERENCES sucursal (codSuc);

ALTER TABLE Enlace
ADD CONSTRAINT [FK_enlace_codIsp]
FOREIGN KEY ([codIsp]) 
REFERENCES isp(codIsp);

ALTER TABLE Enlace
ADD CONSTRAINT [FK_enlace_codTipo]
FOREIGN KEY ([codTipo]) 
REFERENCES tipo_enlace([codTipo]);


/*TABLA EQUIPOS*/

ALTER TABLE Equipos
ADD CONSTRAINT [Equipos_Id_codEquipo] 
PRIMARY KEY ([codEquipo]);

ALTER TABLE Equipos
ADD CONSTRAINT [FK_equipos_idEnlace]
FOREIGN KEY ([idEnlace]) 
REFERENCES enlace([idEnlace]);

ALTER TABLE Equipos
ADD CONSTRAINT [CK_Equipos_codEquipo]
CHECK ([codEquipo] like '[A-Z][A-Z][A-Z][-][0-9][0-9][0-9][0-9][0-9][0-9]');


/*TABLA TRUNK*/

ALTER TABLE Trunk
ADD CONSTRAINT [Trunk_Id_idTrunk] 
PRIMARY KEY ([idTrunk]);

ALTER TABLE Trunk
ADD CONSTRAINT [FK_trunk_codSucOri]
FOREIGN KEY ([codSucOri]) 
REFERENCES sucursal([codSuc]);

ALTER TABLE Trunk
ADD CONSTRAINT [FK_trunk_codSucDes]
FOREIGN KEY ([codSucDes]) 
REFERENCES sucursal([codSuc]);

ALTER TABLE trunk
ADD CONSTRAINT [CK_trunk_estado]
CHECK ([stsTrunk] in ('A','D','I','X'));


/*TABLA ENLACE TRUNK*/

ALTER TABLE Enlace_Trunk
ADD CONSTRAINT [E_Trunk_Id_idTrunk_idEnlace] 
PRIMARY KEY ([idTrunk],[idEnlace]);

ALTER TABLE Enlace_Trunk
ADD CONSTRAINT [FK_enlaceTrunk_idEnlace]
FOREIGN KEY ([idEnlace]) 
REFERENCES enlace([idEnlace]);

ALTER TABLE Enlace_Trunk
ADD CONSTRAINT [FK_enlaceTrunk_idTrunk]
FOREIGN KEY ([idTrunk]) 
REFERENCES trunk([idTrunk]);

end

begin /* 2 - CREACION DE INDICES */

CREATE INDEX I1 ON Enlace([codSuc]);
CREATE INDEX I2 ON Enlace([codIsp]);
CREATE INDEX I3 ON Enlace([codTipo]);
CREATE INDEX I4 ON Equipos([idEnlace]);
CREATE INDEX I5 ON Trunk([codSucOri]);
CREATE INDEX I6 ON Trunk([codSucDes]);

end

begin /* 3 - DATOS DE PRUEBA */

INSERT INTO Sucursal
VALUES  ('urusuc0001','Urucenter','Uruguay','Montevideo','Perez','urucenter@mundotrade.com' ,'01159802123456'),
		('urusuc0002','Datauru','Uruguay','Tacuarembo','Rodriguez','datauru@mundotrade.com','01159802123457'),
		('argsuc0001','Bairescom','Argentina','Buenos Aires','Fernandez','bairescom@mundotrade.com','00549802123456'),
		('argsuc0002','Enlace Cordoba','Argentina','Cordoba','Hernandez','enlacecordoba@mundotrade.com','00549802123456'),
		('brasuc0001','Red Brasil','Brasil','Rio','Martinez','redbrasil@mundotrade.com','00569802123456'),		
		('brasuc0002','Tele Brasil','Brasil','São Paulo','Dominguez','telebrasil@mundotrade.com','00569802123457')
		
INSERT INTO Isp
VALUES	('isp uru','01159802123458','Jose Artigas','prov@ispuru.com','Uruguay'),
		('isp arg','00549802123458','Pedro Varela','prov@isparg.com','Argentina'),
		('isp bra','00569802123458','Manuel Oribe','prov@ispbra.com','Brasil')

INSERT INTO tipo_enlace
VALUES	('tipfib0001','Conexion con uso de fibra','Fibra','100','85'),
		('tipeth0001','Conexion con estandar ethernet','Ethernet','10','65'),
		('tipcab0001','Conexion via cable','Cable','1000','35'),
		('tipair0001','Conexion via aire','Aire','100','75'),
		('tipotr0001','Otro tipo de conexion','Otros','10','25')
		
INSERT INTO enlace 
VALUES	('urusuc0001',1,'20140608','20160608','tipfib0001','192.168.1.1','255.255.255.0','192.168.0.0','192.168.22.28','192.168.22.28'),
		('urusuc0001',1,'20140321','20150321','tipfib0001','192.168.1.2','255.255.255.0','192.168.0.0','192.168.22.28','192.168.22.28'),
		('urusuc0001',1,'20130422','20150422','tipfib0001','192.168.1.3','255.255.255.0','192.168.0.0','192.168.22.28','192.168.22.28'),
		('urusuc0001',2,'20150605','20160605','tipeth0001','192.168.2.1','255.255.255.0','192.168.0.0','192.168.22.28','192.168.22.28'),
		('urusuc0002',2,'20140903','20150903','tipcab0001','192.168.2.2','255.255.255.0','192.168.0.0','192.168.22.28','192.168.22.28'),
		('urusuc0002',3,'20131110','20151110','tipair0001','192.168.3.1','255.255.255.0','192.168.0.0','192.168.22.28','192.168.22.28'),
		('urusuc0002',3,'20150611','20161211','tipotr0001','192.168.3.2','255.255.255.0','192.168.0.0','192.168.22.28','192.168.22.28'),
		('argsuc0001',1,'20141008','20151008','tipcab0001','192.169.1.1','255.255.255.0','192.169.0.0','192.168.22.28','192.168.22.28'),
		('argsuc0001',1,'20130121','20150121','tipcab0001','192.169.1.2','255.255.255.0','192.169.0.0','192.168.22.28','192.168.22.28'),
		('argsuc0001',1,'20140522','20160622','tipotr0001','192.169.1.3','255.255.255.0','192.169.0.0','192.168.22.28','192.168.22.28'),
		('argsuc0001',2,'20150705','20150705','tipeth0001','192.169.2.1','255.255.255.0','192.169.0.0','192.168.22.28','192.168.22.28'),
		('argsuc0002',2,'20140203','20150203','tipair0001','192.169.2.2','255.255.255.0','192.169.0.0','192.168.22.28','192.168.22.28'),
		('argsuc0002',3,'20140910','20160910','tipcab0001','192.169.3.1','255.255.255.0','192.169.0.0','192.168.22.28','192.168.22.28'),
		('argsuc0002',3,'20140411','20150411','tipeth0001','192.169.3.2','255.255.255.0','192.169.0.0','192.168.22.28','192.168.22.28'),
		('brasuc0001',1,'20140802','20150808','tipfib0001','192.167.1.1','255.255.255.0','192.167.0.0','192.168.22.28','192.168.22.28'),
		('brasuc0001',1,'20140921','20160921','tipfib0001','192.167.1.2','255.255.255.0','192.167.0.0','192.168.22.28','192.168.22.28'),
		('brasuc0001',1,'20141210','20151210','tipfib0001','192.167.1.3','255.255.255.0','192.167.0.0','192.168.22.28','192.168.22.28'),
		('brasuc0001',2,'20130627','20150627','tipeth0001','192.167.2.1','255.255.255.0','192.167.0.0','192.168.22.28','192.168.22.28'),
		('brasuc0002',2,'20140109','20160109','tipcab0001','192.167.2.2','255.255.255.0','192.167.0.0','192.168.22.28','192.168.22.28'),
		('brasuc0002',3,'20150719','20150719','tipair0001','192.167.3.1','255.255.255.0','192.167.0.0','192.168.22.28','192.168.22.28'),
		('brasuc0002',3,'20130101','20160101','tipotr0001','192.167.3.2','255.255.255.0','192.167.0.0','192.168.22.28','192.168.22.28')

INSERT INTO equipos
VALUES	('CIS-111110','Cisco','20150528','20150928',1),
		('CIS-111111','Cisco','20150503','20160503',2),
		('NOR-222220','Nortel','20150417','20160417',3),
		('NOR-222221','Nortel','20150820','20130705',4),
		('COM-333330','3com','20150714','20170820',5),
		('COM-333331','3com','20150516','20140618',6),
		('HPE-444440','HP','20151004','20181004',7),
		('HPE-444441','HP','20151120','20161120',8),
		('JUN-555550','Juniper','20150213','20180213',9),
		('JUN-555551','Juniper','20150110','20140921',10),
		('NOR-666660','Nortel','20151216','20171216',11),
		('NOR-666661','Nortel','20150623','20130204',12),
		('COM-777770','3com','20150318','20171216',13),
		('COM-777771','3com','20150903','20181004',14),
		('HPE-888880','HP','20151120','20171216',15),
		('HPE-888881','HP','20150428','20190423',16),
		('JUN-999990','Juniper','20140715','20181004',17),
		('JUN-999991','Juniper','20140809','20171216',18),
		('CIS-111119','Cisco','20141219','20190423',4),
		('CIS-111118','Cisco','20140228','20170820',2),
		('NOR-222227','Nortel','20140422','20170820',17),
		('NOR-222226','Nortel','20140608','20181004',19),
		('COM-333335','3com','20140909','20190423',5),
		('COM-333334','3com','20141112','20170820',8),
		('HPE-444443','HP','20141223','20181004',18),
		('HPE-444442','HP','20140401','20170820',19),
		('JUN-555599','Juniper','20140120','20190423',20),
		('JUN-555588','Juniper','20151212','20181004',21)	

INSERT INTO trunk
VALUES	('urusuc0001','urusuc0002','20150305','A'),
		('argsuc0001','argsuc0002','20150605','D'),
		('brasuc0001','brasuc0002','20150305','I'),
		('urusuc0001','argsuc0001','20150605','X'),
		('urusuc0001','argsuc0002','20150305','A'),
		('brasuc0001','urusuc0001','20150305','D'),
		('brasuc0001','urusuc0002','20150705','I'),
		('brasuc0001','argsuc0002','20150705','X'),
		('brasuc0001','argsuc0001','20150305','A')

end

begin /* 3 - DATOS DE PRUEBA INCORRECTOS*/

INSERT INTO Sucursal
VALUES  ('urusuc0022','Datauru','Uruguay','Tacuarembo','Rodriguez','urucenter@mundotrade.com','01159802123457'),
		('brasuc0033','Omundo','Brasil','Brasilia','Dominguez','telebrasil@mundotrade.com','00569802123458') 
		
		--El mail de cada Sucursal debe ser unico.


INSERT INTO Isp
VALUES	('isp arg','00549802123458','Pedro Varela','prov@ispuru.com','Argentina'),
		('isp bra','00569802123458','Manuel Oribe','prov@ispuru.com','Brasil')

		--El mail de cada Isp debe ser unico


INSERT INTO tipo_enlace
VALUES	('tipotr0007','Otro tipo de conexion','Otros','0','25'),
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