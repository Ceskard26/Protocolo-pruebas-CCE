# Prueba de ancho de banda entre servidores en diferentes regiones con iperf3

Este proyecto documenta la verificación de ancho de banda entre dos **Virtual Servers (VSI)** en **IBM Cloud**, ubicados en diferentes regiones.  
Se utilizó la herramienta **iperf3** para medir la capacidad de red entre un servidor en **Washington (América)** y otro en **Londres (Europa)**.

---

## 📌 Requerimiento
El proveedor debe:
- Aprovisionar **dos servidores** en diferentes centros de datos (uno en América y otro fuera de América).  
- Realizar una **prueba de ancho de banda** entre ambos servidores utilizando la herramienta `iperf`.  
- El proveedor puede configurar los servidores y parámetros de red como considere necesario.  

---

## ⚙️ Prerrequisitos

1. **IBM Cloud** con acceso a:
   - Una VSI en una región de América (ejemplo: Washington).  
   - Una VSI en una región fuera de América (ejemplo: Londres).  
2. **Sistema Operativo:** Linux (CentOS en este caso).  
3. **Conectividad entre servidores** (red privada o pública).  
   - Se recomienda **usar la red privada de IBM Cloud**.  
4. **Reglas de red abiertas**:
   - Permitir **puerto TCP 5201** (por defecto de iperf3).  
   - Permitir **ICMP** (opcional, para verificar conectividad vía `ping`).  

👉 Ejemplo de Security Group / ACL en IBM Cloud:  
*(inserta aquí la captura de pantalla de las reglas de seguridad)*

---

## 🏗️ Infraestructura utilizada

- **Servidor Washington (América)**  
  - IP privada: `10.241.1.4`  
  - IP pública: `169.63.98.163`  

- **Servidor Londres (Europa)**  
  - IP privada: `10.242.1.4`  
  - IP pública: `158.175.182.210`  

---

## 🚀 Procedimiento paso a paso

### 1. Instalar iperf3
En ambos servidores (Washington y Londres):

```bash
sudo yum install -y epel-release
sudo yum install -y iperf3
