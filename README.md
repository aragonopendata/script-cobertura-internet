> **Warning**:
> Proyecto en pruebas 👷‍♀️🚧👷‍. **No cambiar visualización a repositorio público**
# De Vodafone API a PostgreSQL con mapa incluido
## Intención
Se pretende el siguiente flujo:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/schema.png)

## Explicación
El fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL-PROD-variables.sh](./script_coberturas-APIaPostgreSQL-PROD-variables.sh)** **contiene todas las variables necesarias** para que el script del proyecto funcione correctamente. Asimismo se explica qué función tiene cada variable.

En el fichero **script-cobertura-internet/[script_coberturas-APIaPostgreSQL-PROD.sh](./script_coberturas-APIaPostgreSQL-PROD.sh) se explica la ejecución del script** paso a paso.

## Automatización
Este proyecto **se automatizará con el demonio cron**. A continuación se ve un ejemplo de cómo proceder con dicha automatización. **Se añade "2>&1"** al final para **mostrar** tanto **stdout como stderr**, para que así **podamos ver** en el log **cualquier error**, **incluyendo** los **errores que pueda provocar el sistema** y que no estén contemplados en el script a través de los "OR" (en el ejemplo se muestra una actualización de 5 minutos. Es decir, cada 5 minutos se ejecutará el script):

**INPUT**: ```*/5 * * * * [RUTA AL SCRIPT.sh] > /var/log/`date +\%G\%m\%d`.log 2>&1```

**OUTPUT**: El script se ejecutará y dejará un log como el siguiente ejemplo: /var/log/220724.log cuyo formato quiere decir AÑOMESDÍA.log

**Para añadirlo al cron ejecutamos:**
```crontab -e```. Es probable que nos solicite un editor de texto. Para facilitar la tarea es recomendable seleccionar el editor "**nano**" (es el más amigable para usuarios que no conocen otras alternativas en entornos Linux).
Ahora sí, **pegaremos la línea del cron arriba descrita con el patrón de actualización que queramos**. A continuación se muestra el patrón que usa cron para establecer el período de actualización deseado:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/cron.png)

Es interesante saber que "1 \* \* \* \*" querrá decir que el comando se ejecutará en el minuto 1 de todas las horas, mientras que "\*\/1 \* \* \* \*" quiere decir que se ejecutará cada minuto.

Lo mismo pasa con las horas; "\* 1 \* \* \*" querrá decir que el comando se ejecutará a la 1:00 AM, mientras que "\* \*\/1 \* \* \*" quiere decir que se ejecutará cada hora del día.

Se pueden combinar entre sí, dando multitud de opciones.

## Licencia
Este proyecto está sujeto a la **European Union Public License (EUPL)**, como así se podrá encontrar en el archivo: **script-cobertura-internet/[LICENSE.md](./LICENSE.md)**
