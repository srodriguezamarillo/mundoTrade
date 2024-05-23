begin /* 6 - CONSULTAS SQL */

/* A) Mostrar para todas las sucursales los datos de las que tienen más de 2 enlaces de tipo Fibra.*/

SELECT S.codSuc, S.nomSuc, S.paisSuc, S.ciuSuc, S.gteSuc, S.mailSuc, S.mailSuc, S.telSuc, TE.medioTipo 
FROM sucursal S, enlace E, tipo_enlace TE 
WHERE S.codSuc=E.codSuc AND E.codTipo=TE.codTipo AND TE.medioTipo='Fibra' 
GROUP BY S.codSuc, S.nomSuc, S.paisSuc, S.ciuSuc, S.gteSuc, S.mailSuc, S.mailSuc, S.telSuc, TE.medioTipo 
HAVING COUNT(*)>2


/* B) Para todos los tipos de enlace definidos mostrar un listado con el código, descripción, cantidad de 
enlaces de dicho tipo, cantidad de sucursales diferentes que tienen enlaces de dicho tipo y cantidad de 
proveedores (isp) que proveen servicios de dicho tipo, si algún tipo de enlace no tiene un enlace activo 
también deben mostrarse sus datos.*/

SELECT TE.codTipo, TE.dscTipo, COUNT(TE.codTipo), COUNT(S.codSuc), COUNT(I.codIsp)  
FROM TIPO_ENLACE TE LEFT JOIN ENLACE E ON TE.codTipo = E.codTipo
LEFT JOIN SUCURSAL S ON S.codSuc = E.codSuc
LEFT JOIN ISP I ON I.codIsp=E.codIsp
GROUP BY TE.codTipo, TE.dscTipo


/* C) Mostrar código y nombre de los proveedores isp que tienen más de 5 enlaces de Fibra con la empresa pero
no tienen ningún enlace de Aire. */

SELECT codIsp, nomIsp 
FROM ISP
WHERE codIsp IN (SELECT I.codIsp 
				FROM ISP I, ENLACE E, TIPO_ENLACE TE
				WHERE I.codIsp=E.codIsp AND E.codTipo=TE.codTipo AND TE.medioTipo='Fibra'
				GROUP BY I.codIsp
				HAVING COUNT(*)>5)
AND codIsp NOT IN (SELECT I.codIsp 
				FROM ISP I, ENLACE E, TIPO_ENLACE TE
				WHERE I.codIsp=E.codIsp AND E.codTipo=TE.codTipo AND TE.medioTipo='AIRE')


/*  D) Devolver para cada sucursal, el costo promedio de todos sus enlaces, solo mostrar aquellos cuyo costo 
promedio es mayor a 50 dólares. */

SELECT S.codSuc, AVG(TE.precioTipo)
FROM SUCURSAL S, ENLACE E, TIPO_ENLACE TE
WHERE S.codSuc=E.codSuc AND E.codTipo=TE.codTipo 
GROUP BY S.codSuc
HAVING AVG(TE.precioTipo)>50


/*  E) Para cada proveedor isp, devolver la cantidad de enlaces de tipo Aire que tiene, tomar en cuenta solo 
los proveedores isp que no tienen enlaces de tipo Fibra. */

SELECT I.codIsp[Codigo ISP], I.nomIsp[Nombre ISP], COUNT(TE.medioTipo) [Enlaces Aire]
FROM ISP I, ENLACE E, TIPO_ENLACE TE
WHERE I.codIsp=E.codIsp AND E.codTipo=TE.codTipo AND TE.medioTipo='Aire'
AND I.codIsp NOT IN(SELECT I.codIsp
					FROM ISP I, ENLACE E, TIPO_ENLACE TE
					WHERE I.codIsp=E.codIsp AND E.codTipo=TE.codTipo
					AND TE.medioTipo='Fibra')
GROUP BY I.codIsp, I.nomIsp

end

begin /* 7 VISTAS */

/* Crear una vista view7 que muestre nombre, país y ciudad de cada sucursal que componen cada Trunk  */

CREATE VIEW view7 AS
(
SELECT T.idTrunk, S.nomSuc, S.paisSuc, S.ciuSuc
FROM SUCURSAL S, TRUNK T
WHERE S.codSuc=T.codSucOri
OR S.codSuc=T.codSucDes
GROUP BY T.idTrunk, S.nomSuc, S.paisSuc, S.ciuSuc
)

SELECT * FROM view7 