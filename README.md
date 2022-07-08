# De Vodafone API a PostgreSQL con mapa incluido
## Intención
Se pretende el siguiente flujo:
Crear una tabla para las coberturas con los campos deseados -> De la API de Vodafone descargar fichero en formato CSV -> Cargar el fichero CSV a la tabla -> Poblar el campo "geom" con POINTs con la información de las columnas: "latitud" y "longitud" importadas en el paso anterior
## Recomendación
Se recomienda hacer un commit a la rama dev, y luego hacer un merge a la rama main cuando se esté seguro de que está todo correcto. Así se evitarán problemas.
