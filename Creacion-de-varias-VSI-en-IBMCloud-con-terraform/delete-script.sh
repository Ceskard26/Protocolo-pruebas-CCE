#!/bin/bash

#####################################################################################################
# Script para eliminar VSIs de Dallas
#####################################################################################################

# Iniciar timer
start_time=$(date +%s)

region="us-south"
resourcegroup="cce-ibm"
ids_file="vsis-dallas-ids.txt"

echo "=== Iniciando eliminación de VSIs en Dallas ==="
echo "Región: $region"
echo "Archivo de IDs: $ids_file"
echo "Inicio: $(date)"

# Verificar si existe el archivo de IDs
if [ ! -f "$ids_file" ]; then
    echo "❌ Error: Archivo '$ids_file' no encontrado"
    echo "Asegúrate de haber ejecutado el script de creación primero"
    exit 1
fi

# Verificar si el archivo tiene contenido
if [ ! -s "$ids_file" ]; then
    echo "❌ Error: Archivo '$ids_file' está vacío"
    exit 1
fi

# Cambiar a región Dallas
echo "Cambiando a región $region..."
ibmcloud target -r $region -g "$resourcegroup"

# Contar total de IDs
total_ids=$(wc -l < "$ids_file")
echo "Total de VSIs a eliminar: $total_ids"

# Eliminar instancias en paralelo
echo "=== Eliminando VSIs en paralelo ==="
deleted_count=0
failed_count=0
counter=0

while read -r id; do
    if [ -n "$id" ]; then
        (
            echo "Eliminando VSI ID: $id"
            if ibmcloud is instance-delete "$id" -f >/dev/null 2>&1; then
                echo "✓ VSI $id eliminada exitosamente"
            else
                echo "✗ Error eliminando VSI $id"
            fi
        ) &
        
        ((counter++))
        
        # Controlar procesos paralelos (cada 20 eliminaciones)
        if [ $((counter % 20)) -eq 0 ]; then
            echo "Esperando lote de 20 eliminaciones..."
            wait
        fi
    fi
done < "$ids_file"

# Esperar a que terminen todas las eliminaciones
echo "Esperando a que terminen todas las eliminaciones..."
wait

# Verificar cuántas se eliminaron realmente
echo "Verificando eliminaciones..."
remaining_count=0
while read -r id; do
    if [ -n "$id" ]; then
        if ibmcloud is instance "$id" >/dev/null 2>&1; then
            ((remaining_count++))
            ((failed_count++))
        else
            ((deleted_count++))
        fi
    fi
done < "$ids_file"

echo "=== Resumen de eliminación ==="
echo "VSIs a eliminar: $total_ids"
echo "VSIs eliminadas: $deleted_count"
echo "VSIs con error: $failed_count"

if [ "$failed_count" -eq 0 ]; then
    echo "✓ Todas las VSIs fueron eliminadas exitosamente"
    echo "Limpiando archivo de IDs..."
    rm -f "$ids_file"
    echo "Archivo $ids_file eliminado"
else
    echo "⚠ Algunas VSIs no pudieron ser eliminadas"
    echo "Revisa manualmente las instancias restantes"
fi

echo "Eliminación completada: $(date)"

# Calcular tiempo total
end_time=$(date +%s)
total_time=$((end_time - start_time))
minutes=$((total_time / 60))
seconds=$((total_time % 60))

echo ""
echo "⏱️  TIEMPO TOTAL DE ELIMINACIÓN: ${minutes}m ${seconds}s"
echo "  Promedio por VSI: $((total_time * 1000 / total_ids))ms"

if [ "$failed_count" -eq 0 ]; then
    echo "🗑️  ELIMINACIÓN COMPLETADA EXITOSAMENTE"
else
    echo "⚠️  ELIMINACIÓN PARCIAL - $failed_count VSIs con errores"
fi