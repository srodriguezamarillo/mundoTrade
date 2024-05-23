USE MASTER

/*Creacion de la Base de Datos del Obligatorio "MundoTrade"*/
CREATE DATABASE MundoTrade  --DROP DATABASE MundoTrade 
USE MundoTrade 

begin /* Creacion de Tablas */

/*Sucursal: Son las oficinas alrededor del mundo de la empresa, están identificadas por un código, se conoce
el nombre, el país, la ciudad, el nombre del gerente, el mail y el teléfono, se sabe que el mail de cada 
sucursal es único.*/

CREATE TABLE sucursal (codSuc CHAR(10) not null,
                       nomSuc VARCHAR(30) not null,
					   paisSuc VARCHAR(30) not null,
					   ciuSuc VARCHAR(30) not null,
					   gteSuc VARCHAR(30) not null,
					   mailSuc VARCHAR(50) not null,
					   telSuc VARCHAR(30) not null)


/*ISP: Son los proveedores de Internet que tienen las sucursales, se conoce un código que lo identifica, 
el nombre, teléfono, persona de contacto, mail y país.*/

CREATE TABLE isp(codIsp int identity(1,1) not null,
                 nomIsp VARCHAR(30) not null,
				 telIsp VARCHAR(30) not null,
				 cotactIsp VARCHAR(30) not null,
				 mailIsp VARCHAR(30) not null,
				 paiIsp VARCHAR(30) not null)


/*Tipo_Enlace: Son los diferentes tipos de enlace que existen, la empresa los tiene identificados con un 
código, se conoce la descripción, el medio físico que puede ser “Fibra”, “Ethernet”, “Cable”, “Aire”, “Otros”, 
el ancho de banda medido en mbs siempre es mayor o igual a 1 y el precio en dólares del tipo de enlace.*/

CREATE TABLE tipo_enlace(codTipo CHAR(10) not null,
                         dscTipo VARCHAR(30) not null,
						 medioTipo VARCHAR(30) not null,
						 anchoTipo NUMERIC(4) not null,
						 precioTipo NUMERIC(12,2) not null)


/*Enlace: Son los enlaces que proveen cada ISP a las sucursales, se conoce la fecha del contrato del enlace, 
la fecha de finalización, el tipo de enlace, la IP, la máscara, la puerta de enlace y los DNS.*/

CREATE TABLE enlace(idEnlace int identity(1,1) not null,
                    codSuc CHAR(10) not null,
                    codIsp int not null,
					fchEnlace datetime not null,
					fchFin datetime not null,
					codTipo CHAR(10) not null,
					ipEnlace VARCHAR(15) not null,
					maskEnlace VARCHAR(15) not null,
					gatewayEnlace VARCHAR(15) not null,
					dns1Enlace VARCHAR(15) not null,
					dns2Enlace VARCHAR(15) not null)

 
/*Equipos: Son los equipos de comunicaciones de la empresa, poseen un código que los identifica, marca, 
fecha de compra, fecha de vencimiento de la garantía y a que enlace está conectado. Se sabe que el código 
de cada equipo siempre comienza con 3 letras mayúsculas seguido de un guion “-“ y luego 6 números.*/

CREATE TABLE equipos(codEquipo CHAR(10) not null,
                     marcaEquipo VARCHAR(30) not null,
					 fchEquipo datetime not null,
					 vtoEquipo datetime not null,
					 idEnlace int not null)


/*Trunk: Son los túneles que se levantan entre las sucursales, están identificados con un código, se conoce 
la fecha de creado y el estado que puede ser A=Activo, D=Desactivado, I=Inestable, X=Desconocido.*/

CREATE TABLE trunk(idTrunk int identity(1,1) not null,
                   codSucOri CHAR(10) not null,
                   codSucDes CHAR(10) not null,
				   fchTrunk datetime not null,
				   stsTrunk CHAR(1) not null)


/*Enlace_Trunk
Determina cuales enlaces forman parte de cada Trunk, por cada Trunk participan dos enlaces, uno de cada 
sucursal.*/

CREATE TABLE Enlace_Trunk(idTrunk int not null,
                          idEnlace int not null)                      
                          
end