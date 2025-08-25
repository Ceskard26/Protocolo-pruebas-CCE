# Pruebas de Rendimiento de Red con iperf3 en IBM Cloud

Esta documentación describe cómo realizar pruebas de rendimiento de red entre instancias de IBM Cloud utilizando iperf3, específicamente entre las regiones de Washington y Londres.

## Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Configuración del Entorno](#configuración-del-entorno)
- [Escenarios de Prueba](#escenarios-de-prueba)
- [Pruebas con Red Privada](#pruebas-con-red-privada)
- [Pruebas con Red Pública](#pruebas-con-red-pública)
- [Interpretación de Resultados](#interpretación-de-resultados)
- [Troubleshooting](#troubleshooting)

## Requisitos Previos

- Dos instancias de IBM Cloud Virtual Server en diferentes regiones
- Acceso SSH a ambas instancias
- iperf3 instalado en ambas instancias
- Configuración de red apropiada (VPC, subnets, security groups)

### Instalación de iperf3

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install iperf3

# RHEL/CentOS/Rocky Linux
sudo yum install iperf3
# o
sudo dnf install iperf3
```

## Configuración del Entorno

### Información de las Instancias

| Región | IP Privada | IP Pública | Rol en la Prueba |
|--------|------------|------------|------------------|
| **Washington** | `10.241.1.4` | `169.63.98.163` | Cliente iperf3 |
| **Londres** | `10.242.1.4` | `158.175.182.210` | Servidor iperf3 |

### Configuración de Security Groups

Asegúrate de que los security groups permitan el tráfico en el puerto 5201 (puerto por defecto de iperf3):

```bash
# Ejemplo de regla para IBM Cloud CLI
ibmcloud is security-group-rule-add <SECURITY_GROUP_ID> inbound tcp --port-min 5201 --port-max 5201
```

<img width="1526" height="738" alt="image" src="https://github.com/user-attachments/assets/5f7e18f7-e73f-4e03-8b6b-2ef00d77b917" />

## Escenarios de Prueba

### Escenario 1: Red Privada (Recomendado)
- **Propósito**: Medir el rendimiento de la red interna de IBM Cloud
- **Ventajas**: Resultados más precisos, sin interferencia de Internet
- **Uso**: Ideal para aplicaciones que se comunican internamente

### Escenario 2: Red Pública
- **Propósito**: Demostrar conectividad global a través de Internet
- **Ventajas**: Simula condiciones reales de usuarios externos
- **Uso**: Útil para validar conectividad desde clientes externos

## Pruebas con Red Privada (Recomendado)

### Paso 1: Configurar el Servidor en Londres

Conéctate a la instancia de Londres y ejecuta:

```bash
# Iniciar iperf3 como servidor
iperf3 -s
```

Deberías ver una salida similar a:
```
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```

<img width="441" height="181" alt="image" src="https://github.com/user-attachments/assets/2b68121e-ba5a-4b95-a12a-4b99512a1ab8" />

### Paso 2: Ejecutar Cliente desde Washington

Conéctate a la instancia de Washington y ejecuta:

```bash
# Conectar al servidor en Londres usando IP privada
iperf3 -c 10.242.1.4
```

<img width="581" height="381" alt="image" src="https://github.com/user-attachments/assets/3ae1f9bb-a145-4bb9-af7f-5d6481211f56" />


## Pruebas con Red Pública

### Paso 1: Configurar el Servidor en Londres

```bash
# Iniciar servidor iperf3 en Londres
iperf3 -s
```

### Paso 2: Ejecutar Cliente desde Washington

```bash
# Conectar usando IP pública de Londres
iperf3 -c 158.175.182.210
```

> ⚠️ **Nota de Seguridad**: Las pruebas por red pública exponen el puerto 5201. Considera limitar el acceso por IP source en los security groups.

## Interpretación de Resultados

### Ejemplo de Salida Típica

```
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   944 Mbits/sec  123    sender
[  5]   0.00-10.04  sec  1.09 GBytes   936 Mbits/sec           receiver
```

### Métricas Clave

- **Transfer**: Cantidad total de datos transferidos
- **Bitrate**: Velocidad de transferencia (Mbits/sec o Gbits/sec)
- **Retr**: Número de retransmisiones TCP (menor es mejor)
- **Jitter**: Variación en la latencia (solo en pruebas UDP)


### Interpretación de Rendimiento

| Resultado | Evaluación | Acción Recomendada |
|-----------|------------|-------------------|
| > 500 Mbps | Excelente | Óptimo para aplicaciones de alto rendimiento |
| 100-500 Mbps | Bueno | Adecuado para la mayoría de aplicaciones |
| 50-100 Mbps | Regular | Revisar configuración de red |
| < 50 Mbps | Deficiente | Investigar problemas de conectividad |

## 🔧 Troubleshooting

### Problemas Comunes

#### Error: "No route to host"
```bash
# Verificar conectividad básica
ping 10.242.1.4
traceroute 10.242.1.4
```

**Soluciones**:
- Verificar configuración de VPC peering/transit gateway
- Comprobar tablas de ruteo
- Validar security groups

#### Error: "Connection refused"
**Soluciones**:
- Verificar que iperf3 esté ejecutándose en el servidor
- Comprobar que el puerto 5201 esté abierto en el firewall
- Validar reglas de security group

#### Rendimiento Bajo
**Causas posibles**:
- Congestión de red
- Configuración subóptima de TCP window
- Limitaciones de CPU en las instancias



> 📸 **Imagen sugerida aquí**: Screenshots de comandos de troubleshooting y sus salidas típicas

### Comandos de Diagnóstico

```bash
# Verificar conectividad de red
ss -tuln | grep 5201          # Verificar que el puerto esté escuchando
netstat -rn                   # Mostrar tabla de ruteo
ip route get 10.242.1.4       # Verificar ruta específica

# Monitorear rendimiento del sistema
htop                          # Monitor de CPU/memoria
iotop                         # Monitor de I/O
```

## Notas Adicionales

- Las pruebas con red privada generalmente muestran mejor rendimiento
- Los resultados pueden variar según la hora del día debido a la congestión
- Para pruebas de producción, ejecuta múltiples iteraciones y calcula promedios
- Considera el impacto de la distancia geográfica en la latencia

## Referencias

- [Documentación oficial de iperf3](https://iperf.fr/iperf-doc.php)
- [IBM Cloud VPC Networking](https://cloud.ibm.com/docs/vpc)
- [IBM Cloud Security Groups](https://cloud.ibm.com/docs/vpc?topic=vpc-using-security-groups)

---

**Última actualización**: Agosto 2025  
**Versión**: 1.0
