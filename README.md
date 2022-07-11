> **Warning**:
> Queda pendiente adaptar el README.md de este repositorio a las reglas y criterios de Aragón Open Data
# De Vodafone API a PostgreSQL con mapa incluido
## Intención
Se pretende el siguiente flujo:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/schema.png)
## Automatización
Este proyecto se automatizará con el demonio cron. A continuación se ve un ejemplo de cómo proceder con dicha automatización. Se añade "2>&1" al final para mostrar tanto stdout como stderr, para que así podamos ver en el log cualquier error, incluyendo los errores que pueda provocar el sistema y que no estén contemplados en el script (en el ejemplo se muestra una actualización de 5 minutos. Es decir, cada 5 minutos se ejecutará el script):
*/5 * * * * [RUTA AL SCRIPT.sh] > /var/log/`date +\%G\%m\%d`.log 2>&1
## Licencia
Este proyecto está sujeto a la European Union Public License (EUPL), como así se podrá encontrar en el archivo script-cobertura-internet/LICENSE.md
