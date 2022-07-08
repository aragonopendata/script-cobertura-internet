#!/bin/bash
# Host de PostgreSQL (dominio o IP)
hostBBDD="biv-idearagon-02.aragon.local"
# Usuario de acceso
usuarioBBDD="[USUARIO]"
# Contraseña de acceso
passwordBBDD="[CONTRASEÑA]"
# Nombre de la base de datos
nombreBBDD="bdideanteg"
# Esquema de la base de datos
esquemaBBDD="[USUARIO]"
# Tabla existente
tablaBBDD="[NOMBRE TABLA]"
# Ruta donde se guardará el fichero CSV de la API. Lógicamente debe ser una carpeta en la que tengas permisos de escritura
rutacarpetaCSV="[RUTA CARPETA DONDE SE GUARDARÁ EL CSV DE LA API, ACABADO EN '/'. Por ejemplo: /home/practicas/]"
# Combina la variable $rutacarpetaCSV con el nombre del archivo, que será la fecha con formato estilo 20220631 (AÑOMESDÍA)
rutaficheroCSV="$rutacarpetaCSV`date +%G%m%d`.csv"
# URL de la API de OpenData
urlAPI="https://opendataei2a.aragon.es/cobertura/api/data/getData"