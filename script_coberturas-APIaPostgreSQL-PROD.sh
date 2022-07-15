#!/bin/bash
# Script por: danidemingo (por si tiene cualquier duda sobre el script)
# NOTA: Este script se ejecuta automáticamente, no requiere entrada por parte del usuario mas que rellenar correctamente las variables abajo descritas.

source ./script_coberturas-APIaPostgreSQL-PROD-variables.sh

echo "-Descargamos el CSV de todos los datos de cobertura mediante la API"

# Se usará la URL especificada en urlAPI para descargar todo el histórico de coberturas y se guardará en la carpeta indicada con el formato AÑOMESDÍA.csv (por ejemplo, 300522; 30 de mayo del 2022)
curl --header "Accept: text/csv" -v $urlAPI -o $rutaficheroCSV && echo "-Se ha descargado el CSV de la API correctamente-" || (echo "-Ha habido un problema al descargar el CSV de la API-" && exit 1)

echo "-Realizamos un if. Si detecta que el fichero CSV descargado contiene encabezados borrará dicha línea. Si no hay encabezado nos mostrará un mensaje diciendo que dicha línea ya está eliminada-"
if cat $rutaficheroCSV | head -n1 | grep "fecha" ; then
        echo "-Se ha detectado la primera línea de encabezados. Se procede borrarla-"
        sed -i '1d' $rutaficheroCSV && echo "-Se ha borrado la línea de encabezados correctamente-" || (echo "Ha habido un problema al borrar la primera línea de encabezados" && exit 1)
else
        echo "-La primera línea de encabezados no existe, se procede a continuar con el script-"
fi

# Este comando borra el contenido de la tabla
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "TRUNCATE TABLE $tablaBBDD" && echo "-Contenido de la tabla: $tablaBBDD borrada correctamente-" || (echo "-Ha habido un error al borrar la tabla: $tablaBBDD-" && exit 1)

echo "-Importamos el CSV que hemos descargado a la tabla: $tablaBBDD-"
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "\copy $esquemaBBDD.$tablaBBDD (fecha, categoria, calidad, municipio, ine, modelo, so, tipored, operador, coordenadax, coordenaday, latitud, longitud, valorintensidadsenial, rangointensidadsenial, velocidadbajada, rangovelocidadbajada, velocidadsubida, rangovelocidadsubida, latencia, rangolatencia) FROM $rutaficheroCSV DELIMITER ';' CSV;" && echo "-CSV importado correctamente-" || (echo "-Ha habido un problema al importar el CSV-" && exit 1)

# Este comando hace el POINT de los campos latitud y longitud de la tabla. Por tanto, los datos de la tabla deben de importarse antes de hacer este comando para que los campos latitud y longitud estén llenos.
echo "-Poblamos la columna geom utilizando las columnas latitud y longitud de esta misma tabla-"
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "UPDATE $nombreBBDD.$esquemaBBDD.$tablaBBDD SET geom = ST_SetSRID(ST_MakePoint(longitud, latitud), 4326);" && echo "-Columna poblada correctamente-" || (echo "-Ha habido un problema al poblar la columna-" && exit 1)

echo "-Fin del script-"
