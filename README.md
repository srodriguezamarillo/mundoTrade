# MundoTrade

Proyecto SQL de gestión de equipamiento y enlaces a Internet para la empresa de logística "Mundo Trade". Implementa técnicas avanzadas de SQL para garantizar la integridad y eficiencia del sistema y la correcta administración de datos.

## Descripción del Proyecto

La realidad de este proyecto referencia a un sistema de gestión de equipamiento y enlaces a Internet de la empresa "Mundo Trade" dedicada a la logística internacional que tiene todas sus sucursales interconectadas. Una versión simplificada de un esquema de bases de datos para este sistema podría ser el siguiente:

- **sucursal** (codSuc, nomSuc, paisSuc, ciuSuc, gteSuc, mailSuc, telSuc)
- **isp** (codIsp, nomIsp, telIsp, cotactIsp, mailIsp, paiIsp)
- **tipo_enlace** (codTipo, dscTipo, medioTipo, anchoTipo, precioTipo)
- **enlace** (idEnlace, codSuc, codIsp, fchEnlace, fchFin, codTipo, ipEnlace, maskEnlace, gatewayEnlace, dns1Enlace, dns2Enlace)
- **equipos** (codEquipo, marcaEquipo, fchEquipo, vtoEquipo, idEnlace)
- **trunk** (idTrunk, codSucOri, codSucDes, fchTrunk, stsTrunk)
- **Enlace_Trunk** (idTrunk, idEnlace)

### Descripción de Tablas

#### Sucursal
Son las oficinas alrededor del mundo de la empresa, están identificadas por un código, se conoce el nombre, el país, la ciudad, el nombre del gerente, el mail y el teléfono. Se sabe que el mail de cada sucursal es único.

#### ISP
Son los proveedores de Internet que tienen las sucursales, se conoce un código que lo identifica, el nombre, teléfono, persona de contacto, mail y país.

#### Tipo_Enlace
Son los diferentes tipos de enlace que existen, la empresa los tiene identificados con un código, se conoce la descripción, el medio físico que puede ser "Fibra", "Ethernet", "Cable", "Aire", "Otros", el ancho de banda medido en Mbps siempre es mayor o igual a 1 y el precio en dólares del tipo de enlace.

#### Enlace
Son los enlaces que proveen cada ISP a las sucursales, se conoce la fecha del contrato del enlace, la fecha de finalización, el tipo de enlace, la IP, la máscara, la puerta de enlace y los DNS.

#### Equipos
Son los equipos de comunicaciones de la empresa, poseen un código que los identifica, marca, fecha de compra, fecha de vencimiento de la garantía y a qué enlace está conectado. Se sabe que el código de cada equipo siempre comienza con 3 letras mayúsculas seguido de un guion "-" y luego 6 números.

#### Trunk
Son los túneles que se levantan entre las sucursales, están identificados con un código, se conoce la fecha de creación y el estado que puede ser A=Activo, D=Desactivado, I=Inestable, X=Desconocido.

#### Enlace_Trunk
Determina cuáles enlaces forman parte de cada Trunk. Por cada Trunk participan dos enlaces, uno de cada sucursal.

## Informe de la Solución

La solución entregada, en cada instancia (restricciones, índices, datos de prueba, funciones y procedimientos, disparadores, consultas y vistas) se apega fielmente al pedido de la letra. Los casos en los que no fue posible cumplir exactamente con la letra son descritos a continuación, con una respectiva solución alternativa.

### Casos de Ambigüedad 

#### Disparador trig5_a
"Crear el disparador trig5_a para que una vez ingresado un Trunk se genere un registro Enlace_Trunk para cada sucursal que compone dicho Trunk".

En este caso la letra presenta una ambigüedad, nos pide generar un registro Enlace_Trunk por cada sucursal que compone dicho Trunk. Esto quiere decir que el flujo normal del disparador sería insertar 2 registros en la tabla Enlace_Trunk, uno por cada sucursal implicada en el Trunk (sucursal de origen y sucursal de destino).

En cambio, el disparador genera tantos registros como enlaces relacionados a esas sucursales existan en la tabla Enlace. Esto se debe a que en la tabla Enlace puede existir más de un registro que implique la misma sucursal, ya que las sucursales pueden tener enlaces con diferentes ISP (proveedores de internet) y/o diferentes tipos de enlace.

Entonces al hacer el insert en la tabla Trunk, se activa el disparador trig5_a que inserta en Enlace_Trunk, tantas filas como registros en la tabla Enlace exista con las sucursales (Sucursal de Origen y Destino) ingresadas en la inserción del Trunk.

Una solución alternativa, pero que no aplica a la realidad, sería limitar a uno la cantidad de veces que puede presentarse cada sucursal en la tabla Enlace, esto implicaría que cada sucursal pueda contratar solo un tipo de conexión, de un solo proveedor. Irreal, pero evitaría las múltiples inserciones en la tabla Enlace_Trunk.

#### Función fun4_b
"Implementar una función fun4_b que reciba un código de sucursal y retorne el promedio pagado por enlaces en el año actual por dicha sucursal".

La manera en la que se entiende la consigna, cambia la forma de resolverlo. Podría ser tomar como fecha el año en que se contrató el enlace (fchEnlace) o que, en el año en que se contrató el enlace esté comprendido el año de la fecha actual.

Ejemplifico:

En el primer caso retornaría un promedio pagado por los enlaces contratados en el año actual 2015 (fchEnlace=2015). En el segundo caso, tomaría en cuenta para el promedio todos los enlaces cuyas fechas comprendan el 2015. Ejemplo: (fchEnlace=2014) y (fchFin=2017). Opté por la segunda opción, justificando mi decisión en que es de interés prioritario retornar un promedio que tenga en cuenta además de los enlaces contratados en el año actual, aquellos que aún están vigentes pero fueron contratados en años anteriores.

## Estructura del Proyecto

El proyecto está estructurado de la siguiente manera:

- **1_Creacion de Tablas.sql:** Contiene la creación de las tablas principales del sistema.
- **2_Restricciones de Integridad - Indices - Datos de Prueba.sql:** Contiene las restricciones de integridad, índices y datos de prueba.
- **3_Procedimientos - Funciones.sql:** Contiene los procedimientos y funciones necesarias para la operación del sistema.
- **4_Triggers.sql:** Contiene los disparadores para asegurar la consistencia de los datos.
- **5_Consultas - Vistas.sql:** Contiene las consultas y vistas para obtener información del sistema.
- **6_Juego de datos valido.sql:** Contiene un conjunto de datos de prueba válido.
- **7_Juego de datos incorrectos.sql:** Contiene un conjunto de datos de prueba incorrectos.
- **Defensa.sql:** Contiene la defensa del proyecto.

## Contribución

Si deseas contribuir a este proyecto, por favor sigue los siguientes pasos:

1. Haz un fork del repositorio.
2. Crea una nueva rama para tus cambios:
   ```bash
   git checkout -b feature-nueva-funcionalidad

3. Realiza tus cambios y haz commit de los mismos:
   ```bash
   git commit -m 'Agregar nueva funcionalidad'

4. Sube tus cambios a tu repositorio fork:
   ```bash
   git push origin feature-nueva-funcionalidad

5. Abre un Pull Request en el repositorio original.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Para más detalles, consulta el archivo LICENSE.

## Contacto

Si tienes alguna pregunta o sugerencia, no dudes en ponerte en contacto:

- **Email:** srodriguezamarillo@gmail.com
- **LinkedIn:** https://www.linkedin.com/in/srodriguezamarillo
