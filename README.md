> **Warning**:
> Proyecto en pruebas 👷‍♀️🚧👷‍. **No cambiar visualización a repositorio público**

> **Note**
> Se deberán separar ciertas secciones de este README.md que quedarán para el README.md privado y se eliminarán del README.md público. Es decir, aquí se puede encontrar una mezcla de ambos.
# De Vodafone API a PostgreSQL con mapa incluido

## Intención
Se pretende el siguiente flujo:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/schema.png)

## Creación de la tabla
Procederemos a **crear la tabla** desde la que después partiremos:
```sql
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
        geom geometry(geometry, 4326)
);
```

## Logs (duplicado en Automatización. Este apartado quedará para README.md público, y Automatización para el README.md privado)
Guardaremos un archivo de log en /var/log/script-cobertura-internet/AÑOMESDÍA.log

Para ello debemos crear la carpeta /var/log/script-cobertura-internet con el comando: ```sudo mkdir /var/log/script-cobertura-internet``` y dar permisos de escritura al usuario con el que estemos trabajando con el comando: ```sudo chown [TU USUARIO]:[TU USUARIO] /var/log/script-cobertura-internet```, es decir, por ejemplo: ```sudo chown pedro:pedro /var/log/script-cobertura-internet``` (aquí realmente estamos cambiando el autor de la carpeta /var/log/script-cobertura-internet de root:root a pedro:pedro, o el usuario que hayas introducido. Así tendremos permisos de escritura sobre esta carpeta

## Explicación
### Script para las variables
El fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL-PROD-variables.sh](./script_coberturas-APIaPostgreSQL-PROD-variables.sh)** **contiene todas las variables necesarias** para que el script del proyecto funcione correctamente. Asimismo se explica qué función tiene cada variable.
#### Variable urlAPI
La variable urlAPI se consigue mediante la aplicación web Swagger, publicada en Aragon Open Data. Se muestra dicho proceso de obtención:
##### Obtención
**La existencia de esta sección tiene como objetivo mantener la url de la variable urlAPI actualizada aún en en el caso de que ésta cambie.**

Para obtener la url de la API y rellenar la variable urlAPI nos dirigiremos a: https://opendataei2a.aragon.es/cobertura/api/swagger/index.html
Uniremos los campos marcados en rojo tal y como se muestra en la siguiente imagen:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/swagger.png)
La URL final, por tanto, sería: https://opendataei2a.aragon.es/cobertura/api/ + data/getData quedándose en: https://opendataei2a.aragon.es/cobertura/api/data/getData

### Script general
En el fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL-PROD.sh](./script_coberturas-APIaPostgreSQL-PROD.sh) se explica la ejecución del script** paso a paso.

## Automatización
### ¿Cómo la haremos?
Este proyecto **se automatizará con el demonio cron**. A continuación se verá un ejemplo de cómo proceder con dicha automatización.
### ¿Por qué añadimos 2>&1 y qué quiere decir?
**Se añade "2>&1"** al final para **mostrar** tanto **stdout como stderr**, para que así **podamos ver** en el log **cualquier error**, **incluyendo** los **errores que pueda provocar el sistema** y que no estén contemplados en el script a través de los "OR".
### Automatizaciones cada X minutos
En  ejemplo se muestra una actualización de 5 minutos. Es decir, cada 5 minutos se ejecutará el script:

**INPUT:** ```*/5 * * * * [RUTA AL SCRIPT.sh] > /var/log/`date +\%G\%m\%d`.log 2>&1```

**OUTPUT:** El script se ejecutará y dejará un log como el siguiente ejemplo: /var/log/script-cobertura-internet/220724.log cuyo formato quiere decir AÑOMESDÍA.log, para lo cual **primero de todo debemos crear la carpeta /var/log/script-cobertura-internet** con el comando: ```sudo mkdir /var/log/script-cobertura-internet``` y dar permisos de escritura al usuario con el que estemos trabajando con el comando: ```sudo chown [TU USUARIO]:[TU USUARIO] /var/log/script-cobertura-internet```, es decir, por ejemplo: ```sudo chown pedro:pedro /var/log/script-cobertura-internet``` (aquí realmente estamos cambiando el autor de la carpeta /var/log/script-cobertura-internet de root:root a pedro:pedro, o el usuario que hayas introducido. Así tendremos permisos de escritura sobre esta carpeta

#### ¿Cómo las añadimos al cron?
**Para añadirlo al cron ejecutamos:**
```crontab -e```. Es probable que nos solicite un editor de texto. Para facilitar la tarea es recomendable seleccionar el editor "**nano**" (es el más amigable para usuarios que no conocen otras alternativas en entornos Linux).
Ahora sí, **pegaremos la línea del cron arriba descrita con el patrón de actualización que queramos**. A continuación se muestra el patrón que usa cron para establecer el período de actualización deseado:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/cron.png)

### Algunas aclaraciones
Es interesante saber que "1 \* \* \* \*" querrá decir que el comando se ejecutará en el minuto 1 de todas las horas, mientras que "\*\/1 \* \* \* \*" quiere decir que se ejecutará cada minuto.

Lo mismo pasa con las horas; "\* 1 \* \* \*" querrá decir que el comando se ejecutará a la 1:00 AM, mientras que "\* \*\/1 \* \* \*" quiere decir que se ejecutará cada hora del día.

Se pueden combinar entre sí, dando multitud de opciones.

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
