> **Warning**:
> Queda pendiente adaptar el README.md de este repositorio a las reglas y criterios de Aragón Open Data
# De Vodafone API a PostgreSQL con mapa incluido
## Intención
Se pretende el siguiente flujo:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/schema.png)
## Automatización
Este proyecto se automatizará con el demonio cron. A continuación se ve un ejemplo de cómo proceder con dicha automatización. Se añade "2>&1" al final para mostrar tanto stdout como stderr, para que así podamos ver en el log cualquier error, incluyendo los errores que pueda provocar el sistema y que no estén contemplados en el script (en el ejemplo se muestra una actualización de 5 minutos. Es decir, cada 5 minutos se ejecutará el script):
```*/5 * * * * [RUTA AL SCRIPT.sh] > /var/log/`date +\%G\%m\%d`.log 2>&1```

Para añadirlo al cron ejecutamos:
```crontab -e```. Es probable que nos solicite un editor de texto. Para facilitar la tarea es recomendable seleccionar el editor "nano" (es el más amigable para usuarios que no conocen otras alternativas en entornos Linux).
Ahora sí, pegaremos la línea del cron arriba descrita con el patrón de actualización que queramos. A continuación se muestra el patrón que usa cron para establecer el período de actualización deseado:

![alt text](https://github.com/aragonopendata/script-cobertura-internet/blob/main/images/cron.png)

## Licencia
Este proyecto está sujeto a la European Union Public License (EUPL), como así se podrá encontrar en el archivo [LICENSE.md](./LICENSE.md)
