> **Warning**:
> Proyecto en pruebas 👷‍♀️🚧👷‍. **No cambiar visualización a repositorio público**

> **Note**
> Se deberán separar ciertas secciones de este README.md que quedarán para el README.md privado y se eliminarán del README.md público. Es decir, aquí se puede encontrar una mezcla de ambos.
# De Vodafone API a PostgreSQL con mapa y teselas incluidas

## Intención
Se pretende el siguiente flujo:\
![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/schema.png)

## Privacidad
**La privacidad es uno de los pilares de este proyecto.** Para entender a qué punto la hemos tenido en cuenta debes saber que **hemos dividido Aragón en teselas de 500x500 metros**. Cuando un dispositivo hace una medición y envía su ubicación nosotros **sólo guardamos la parcela de 500x500 metros a la que pertenece el dispositivo** (basado, como se ha dicho, en su ubicación), por lo que ni nosotros ni nadie podrá saber la ubicación exacta del dispositivo una vez haya finalizado el test y se hayan guardado los datos correctamente.

Pongamos un ejemplo; digamos que hemos enviado los datos exactamente desde esta posición:

**Nuestra posición exacta está marcada como un punto amarillo en el mapa**\
![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/ubicacion_exacta.png)

Una vez haya finalizado el test, la información que quedará guardada será que se ha hecho una medición dentro de esta parcela:

**No se podrá saber desde qué punto exacto se ha hecho la medición. Sólo se mostrará que la medición se ha hecho en esa parcela de 500x500 metros, tal y como se ha explicado antes**\
![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/ubicacion_guardada.png)

## Creación de la tabla
Procederemos a **crear la tabla** desde la que después partiremos:
```sql
psql postgresql://[usuarioBBDD]:[passwordBBDD]@[hostBBDD]/[nombreBBDD] -c "
CREATE TABLE IF NOT EXISTS [nombreBBDD].[esquemaBBDD].[tablaBBDD] (
        fecha timestamp,
        categoria varchar,
        calidad varchar,
        municipio varchar,
        ine int4,
        modelo varchar,
        so varchar,
        tipored varchar,
        operador varchar,
        coordenadax int4,
        coordenaday int4,
        latitud float8,
        longitud float8,
        valorintensidadsenial float8,
        rangointensidadsenial int4,
        velocidadbajada float8,
        rangovelocidadbajada int4,
        velocidadsubida float8,
        rangovelocidadsubida int4,
        latencia float8,
        rangolatencia int4,
        geom geometry(geometry, 4326),
        geom_25830 geometry(geometry, 25830),
        cuadricula geometry(geometry, 25830)
);"
```

## Explicación
### Script para las variables
El fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL-variables.sh](./script_coberturas-APIaPostgreSQL-variables.sh)** **contiene todas las variables necesarias** para que el script del proyecto funcione correctamente. Asimismo se explica qué función tiene cada variable.
#### Variable urlAPI
La variable urlAPI se consigue mediante la aplicación web Swagger, publicada en Aragon Open Data. Se muestra dicho proceso de obtención:
##### Obtención
**La existencia de esta sección tiene como objetivo mantener la url de la variable urlAPI actualizada aún en en el caso de que ésta cambie, por lo que lo importante es seguir los pasos (e ignorar el contenido que haya podido cambiar. Por ejemplo, ha podido cambiar el aspecto de la página web que se muestra abajo como pantallazo).**

Para obtener la url de la API y rellenar la variable urlAPI nos dirigiremos a: https://opendataei2a.aragon.es/cobertura/api/swagger/index.html
Uniremos los campos marcados en rojo tal y como se muestra en la siguiente imagen:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/swagger.png)

La URL final, por tanto, sería: https://opendataei2a.aragon.es/cobertura/api/ + data/getData quedándose en: https://opendataei2a.aragon.es/cobertura/api/data/getData

#### Variable rutacarpetaCSV

rutacarpetaCSV="[RUTA CARPETA DONDE SE GUARDARÁ EL CSV DE LA API, ACABADO EN '/

Antes de ejecutar script es necesario tener creada la carpeta  donde se dejará el fichero CSV que se obtiene de la API.

### Script general
En el fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL.sh](./script_coberturas-APIaPostgreSQL.sh) se explica la ejecución del script** paso a paso.

### Ruta para el fichero variables
**El fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL-variables.sh](./script_coberturas-APIaPostgreSQL-variables.sh)** debe guardarse en una ruta donde se tenga permisos de lectura y escritura**. De hecho, **deberemos acceder al fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL.sh](./script_coberturas-APIaPostgreSQL.sh)** y cambiar a mano el corchete "[CARPETA DONDE ESTÉ EL ARCHIVO DE LAS VARIABLES]"** visualizable en el comando "source" (línea 5 del script) **por la ruta de la carpeta donde se encuentre el fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL-variables.sh](./script_coberturas-APIaPostgreSQL-variables.sh)** y en la que se cumplan los requisitos explicados en este párrafo.**

La línea del fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL.sh](./script_coberturas-APIaPostgreSQL.sh)** a la que se hace referencia es la siguiente:
```bash
source [CARPETA DONDE ESTÉ EL ARCHIVO DE LAS VARIABLES]/script_coberturas-APIaPostgreSQL-variables.sh
```

## Infraestructura necesaria para este proyecto
- (Recomendado) Gestor de bases de datos PostgreSQL con PostGIS para ir viendo los cambios mediante una GUI. Por ejemplo, DBeaver (https://dbeaver.io/)
- (Requerido) Máquina Linux Debian/Fedora (la distribución es prácticamente indiferente pues usamos comandos que suelen estar en todas ellas) con comandos:
    - curl
    - psql
    - sed
    - grep
    - head
- los cuales son comandos básicos que se incluyen prácticamente siempre, como se ha mencionado anteriormente.

## Licencia
Este proyecto está sujeto a la **European Union Public License (EUPL)**, como así se podrá encontrar en el archivo: **script-cobertura-internet/[LICENSE.md](./LICENSE.md)**
