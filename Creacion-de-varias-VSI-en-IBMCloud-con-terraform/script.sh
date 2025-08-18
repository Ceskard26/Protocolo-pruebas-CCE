#!/bin/bash

#####################################################################################################
# Variables de despliegue - Solo Dallas
#####################################################################################################

# Iniciar timer
start_time=$(date +%s)

# Región única
region="us-south"

# Configuración Dallas
vpc_name="cce-dallas"
subnet_name="subnet-dallas"
key_name="ssh-dallas"

BaseName="vsi-cce"
resourcegroup="cce-ibm"
profile="cx2-4x8"
total_vsis=100

#####################################################################################################
# Script principal
#####################################################################################################

echo "=== Iniciando despliegue de $total_vsis VSIs en Dallas ==="
echo "Región: $region"
echo "VPC: $vpc_name"
echo "Inicio: $(date)"

# Cambiar a región Dallas
echo "Cambiando a región $region..."
ibmcloud target -r $region -g "$resourcegroup"

# Obtener imagen pública de CentOS
echo "Obteniendo imagen de CentOS..."
imageid=$(ibmcloud is images --visibility public | grep -Ei "ibm-centos.*stream.*9.*available.*amd64" | head -n1 | awk '{print $1}')

if [ -z "$imageid" ]; then
    echo "Error: No se pudo obtener el image ID"
    exit 1
fi

# Obtener recursos de Dallas
echo "Obteniendo IDs de recursos..."
vpcid=$(ibmcloud is vpcs | grep -i "$vpc_name" | awk '{print $1}')
keyid=$(ibmcloud is keys | grep -i "$key_name" | awk '{print $1}')
subnetid=$(ibmcloud is subnets | grep -i "$subnet_name" | awk '{print $1}')

# Validar recursos
if [ -z "$vpcid" ]; then
    echo "Error: VPC '$vpc_name' no encontrada"
    exit 1
fi

if [ -z "$keyid" ]; then
    echo "Error: SSH Key '$key_name' no encontrada"
    exit 1
fi

if [ -z "$subnetid" ]; then
    echo "Error: Subnet '$subnet_name' no encontrada"
    exit 1
fi

echo "Recursos encontrados:"
echo "  Image ID: $imageid"
echo "  VPC ID: $vpcid"
echo "  Key ID: $keyid"
echo "  Subnet ID: $subnetid"

# Limpiar archivos previos
> vsis-dallas-ids.txt
rm -f tmp-id-dallas-*.txt

echo "=== Creando $total_vsis VSIs en paralelo ==="

# Crear instancias en paralelo
for i in $(seq 1 $total_vsis); do
  (
    name="$BaseName-$i"
    echo "Creando instancia: $name"
    
    output=$(ibmcloud is instance-create "$name" "$vpcid" "$region-1" "$profile" "$subnetid" \
             --image "$imageid" --keys "$keyid" --resource-group-name "$resourcegroup" 2>&1)
    
    if [ $? -eq 0 ]; then
        echo "✓ Instancia $name creada exitosamente"
        # Múltiples métodos para extraer el ID
        id=$(echo "$output" | grep -i "^ID" | awk '{print $2}')
        if [ -z "$id" ]; then
            id=$(echo "$output" | grep -o '[0-9a-f]\{4\}_[0-9a-f-]\{36\}')
        fi
        if [ -z "$id" ]; then
            id=$(echo "$output" | sed -n 's/.*ID[[:space:]]*\([0-9a-f_-]*\).*/\1/p')
        fi
        
        if [ -n "$id" ]; then
            echo "$id" > "tmp-id-dallas-$i.txt"
            echo "  ID capturado: $id"
        else
            echo "  ⚠ No se pudo extraer el ID del output"
            echo "  Output completo:"
            echo "$output" | head -5
        fi
    else
        echo "✗ Error creando instancia $name: $output"
    fi
  ) &
  
  # Limitar procesos paralelos (cada 25 instancias)
  if [ $((i % 25)) -eq 0 ]; then
      echo "Esperando lote de 25 instancias..."
      wait
  fi
done

# Esperar a que terminen todas las instancias
echo "Esperando a que terminen todas las creaciones..."
wait

# Recopilar IDs
echo "Recopilando IDs de instancias..."
for i in $(seq 1 $total_vsis); do
  if [ -f "tmp-id-dallas-$i.txt" ]; then
    if [ -s "tmp-id-dallas-$i.txt" ]; then
      cat "tmp-id-dallas-$i.txt" >> vsis-dallas-ids.txt
      echo "ID de VSI-$i guardado"
    else
      echo "⚠ Archivo tmp-id-dallas-$i.txt está vacío"
    fi
  else
    echo "⚠ Archivo tmp-id-dallas-$i.txt no encontrado"
  fi
done

# Limpiar archivos temporales
rm -f tmp-id-dallas-*.txt

# Mostrar resultados
created_count=$(wc -l < vsis-dallas-ids.txt 2>/dev/null || echo "0")
echo "=== Resumen ==="
echo "VSIs solicitadas: $total_vsis"
echo "VSIs creadas (IDs capturados): $created_count"

if [ "$created_count" -lt "$total_vsis" ]; then
    echo "⚠ No se capturaron todos los IDs durante la creación"
    echo "Intentando obtener IDs desde IBM Cloud..."
    
    # Método alternativo: obtener IDs de instancias existentes
    > vsis-dallas-ids-alt.txt
    for i in $(seq 1 $total_vsis); do
        instance_name="$BaseName-$i"
        echo "Buscando ID para: $instance_name"
        id=$(ibmcloud is instances --output json | grep -A 5 "\"name\": \"$instance_name\"" | grep '"id"' | sed 's/.*"id": "\([^"]*\)".*/\1/')
        if [ -n "$id" ]; then
            echo "$id" >> vsis-dallas-ids-alt.txt
            echo "  ✓ ID encontrado: $id"
        else
            echo "  ✗ No encontrado"
        fi
    done
    
    alt_count=$(wc -l < vsis-dallas-ids-alt.txt)
    echo ""
    echo "IDs obtenidos alternativamente: $alt_count"
    
    if [ "$alt_count" -gt "$created_count" ]; then
        echo "Usando archivo alternativo como principal..."
        mv vsis-dallas-ids-alt.txt vsis-dallas-ids.txt
        created_count=$alt_count
    else
        rm -f vsis-dallas-ids-alt.txt
    fi
fi

echo "IDs guardados en: vsis-dallas-ids.txt"

if [ "$created_count" -eq "$total_vsis" ]; then
    echo "✓ Todas las instancias fueron creadas exitosamente"
else
    echo "⚠ Se crearon instancias pero faltan algunos IDs"
    echo "Verifica manualmente con: ibmcloud is instances"
fi

echo "Despliegue completado: $(date)"

# Calcular tiempo total
end_time=$(date +%s)
total_time=$((end_time - start_time))
minutes=$((total_time / 60))
seconds=$((total_time % 60))

echo ""
echo "⏱️  TIEMPO TOTAL DE EJECUCIÓN: ${minutes}m ${seconds}s"
echo "  Promedio por VSI: $((total_time * 1000 / total_vsis))ms"

if [ "$created_count" -eq "$total_vsis" ]; then
    echo "🚀 DESPLIEGUE COMPLETADO EXITOSAMENTE"
else
    echo "⚠️  DESPLIEGUE PARCIAL - Revisar instancias faltantes"
fi