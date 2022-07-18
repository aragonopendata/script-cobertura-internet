#!/bin/bash
# Script por: danidemingo (por si tiene cualquier duda sobre el script)
# NOTA: Este script se ejecuta automáticamente, no requiere entrada por parte del usuario mas que rellenar correctamente las variables abajo descritas.

source [CARPETA DONDE ESTÉ EL ARCHIVO DE LAS VARIABLES]/script_coberturas-APIaPostgreSQL-PROD-variables.sh

echo "-Descargamos el CSV de todos los datos de cobertura mediante la API"

# Se usará la URL especificada en urlAPI para descargar todo el histórico de coberturas y se guardará en la carpeta indicada con el formato AÑOMESDÍA.csv (por ejemplo, 300522; 30 de mayo del 2022)
curl --header "Accept: text/csv" -v $urlAPI -o $rutaficheroCSV && echo "-Se ha descargado el CSV de la API correctamente-" || { echo "-Ha habido un problema al descargar el CSV de la API-" && exit 1; }

echo "-Realizamos un if. Si detecta que el fichero CSV descargado contiene encabezados borrará dicha línea. Si no hay encabezado nos mostrará un mensaje diciendo que dicha línea ya está eliminada-"
if cat $rutaficheroCSV | head -n1 | grep "fecha" ; then
        echo "-Se ha detectado la primera línea de encabezados. Se procede borrarla-"
        sed -i '1d' $rutaficheroCSV && echo "-Se ha borrado la línea de encabezados correctamente-" || { echo "Ha habido un problema al borrar la primera línea de encabezados" && exit 1; }
else
        echo "-La primera línea de encabezados no existe, se procede a continuar con el script-"
fi

# Este comando borra el contenido de la tabla
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "TRUNCATE TABLE $esquemaBBDD.$tablaBBDD" && echo "-Contenido de la tabla: $tablaBBDD borrada correctamente-" || { echo "-Ha habido un error al borrar la tabla: $tablaBBDD-" && exit 1; }

echo "-Importamos el CSV que hemos descargado a la tabla: $tablaBBDD-"
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "\copy $esquemaBBDD.$tablaBBDD (fecha, categoria, calidad, municipio, ine, modelo, so, tipored, operador, coordenadax, coordenaday, latitud, longitud, valorintensidadsenial, rangointensidadsenial, velocidadbajada, rangovelocidadbajada, velocidadsubida, rangovelocidadsubida, latencia, rangolatencia) FROM $rutaficheroCSV DELIMITER ';' CSV;" && echo "-CSV importado correctamente-" || { echo "-Ha habido un problema al importar el CSV-" && exit 1; }

# Este comando hace el POINT con un SRC 4326 de los campos latitud y longitud de la tabla. Por tanto, los datos de la tabla deben de importarse antes de hacer este comando para que los campos latitud y longitud estén llenos.
echo "-Poblamos la columna geom utilizando las columnas latitud y longitud de esta misma tabla-"
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "UPDATE $nombreBBDD.$esquemaBBDD.$tablaBBDD SET geom = ST_SetSRID(ST_MakePoint(longitud, latitud), 4326);" && echo "-Columna geom poblada correctamente-" || { echo "-Ha habido un problema al poblar la columna geom-" && exit 1; }

# Este comando transforma el SRC del campo anterior (geom) al SRC 25830 haciendo un UPDATE en la columna geom_28530. Por tanto, tendremos una columna llamada geom con un SRC de 4326 y una columna (esta) llamaada geom_25830 que tendrá un SRC de 25830
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "UPDATE ddemingo.nombretablajulio SET geom_25830 = ST_Transform(geom, 25830);" && echo "-Conversión de SRC 4326 a 25830 que se vuelca en columna "geom_25830" completado con éxito-" || { echo "Error al convertir de 4326 a 25830 volcando el resultado en la columna geom_25830" && exit 1; }

# Usamos la columna geom_25830 que tiene un SRC de 25830 para hacer un búfer cuadrado de 250 metros desde el punto central (por lo cual te saldrá un cuadrado de 500mx500m). Cabe decir que el campo que se coge (geom_25830) tiene que estar en SRC 25830, por eso hacemos toda la conversión en los pasos anteriores
psql postgresql://$usuarioBBDD:$passwordBBDD@$hostBBDD/$nombreBBDD -c "UPDATE ddemingo.nombretablajulio SET cuadricula = ST_Buffer(geom_25830, 250, 'endcap=square join=round');" && echo "Cuadrícula de 500x500 poblada en el campo cuadricula" || { echo "Fallo en poblar la cuadrícula de 500x500 poblada en el campo cuadricula" && exit 1; }

echo "-Fin del script-"
