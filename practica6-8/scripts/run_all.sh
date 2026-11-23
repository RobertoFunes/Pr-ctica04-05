#!/bin/sh
set -e

echo ">>> Ejecutando consultas de la Parte 2..."
psql -f /scripts/consultas_parte2.sql

echo ">>> Regenerando grupo de RelaX..."
psql -t -A -f /scripts/generar_relax.sql > /output/grupo_relax.txt

echo ">>> Proceso terminado sin errores."