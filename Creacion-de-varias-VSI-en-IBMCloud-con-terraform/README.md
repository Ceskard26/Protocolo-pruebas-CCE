# Creacion-de-varias-VSI-en-IBMCloud-con-terraform
En este repositorio tendrán el tutorial de creación de 100 máquinas virtuales(o las que necesiten) en IBM Cloud con terraform, el repositorio contiene el script de creación y eliminación de recursos creados ¡Empecemos!

# Pasos
## Pre-requisitos
Antes de descargar el script asegúrate de tener lo siguiente:
- Tener una cuenta en IBM Cloud
- [Instalar la CLI de IBMCloud](https://cloud.ibm.com/docs/cli?topic=cli-install-ibmcloud-cli&locale=es)
- Tener un grupo de recursos creado
- Tener la VPC en donde desplegarás las máquinas creada
- Subnet de la VPC lista
- SSH key
## Paso 1(Clonar repositorio)
Clonar este repositorio en sus máquinas:
```bash
git clone git@github.com:Ceskard26/Protocolo-pruebas-CCE.git
```

<img width="802" height="672" alt="image" src="https://github.com/user-attachments/assets/29bde613-3930-4de2-97a2-09557f366c1a" />



## Paso 2(Editar el script)

En este paso deben de adaptar el código, editen los siguientes valores del código que clonaron en el paso anterior
```bash
region         = "region en la que van a desplegar sus máquinas"<img width="401" height="188" alt="Captura de pantalla 2025-09-03 a la(s) 9 48 26 a  m" src="https://github.com/user-attachments/assets/31cdbd8e-c074-4a05-b18d-32dd9421b2aa" />

zone_number    = "Número de la zona(usualmente 1)"
ssh_keyname    = "Nombre de la secure Shell"
vpc_name       = "Nombre de la vpc"
subnet_name    = "subnet-dallas"
vsi_count      = el número de máquinas que quieran desplegar
resource_group = "cce-ibm"
environment    = "development"
```

## Paso 3(Ejecución)
Una vez editado el script tenemos que loggearnos a la CLI de IBM:
con el comando:
```bash
ibmcloud login 
```
o pegar este comando luego de ir a **Perfil** y darle click a **Log in into CLI and API**

<img width="276" height="320" alt="Captura de pantalla 2025-08-04 a la(s) 5 33 02 p  m" src="https://github.com/user-attachments/assets/c52e87d8-3290-448a-baba-51afc8866e08" />

Copiar lo siguiente y pegarlo en su CLI:

<img width="691" height="325" alt="Captura de pantalla 2025-08-04 a la(s) 5 36 22 p  m" src="https://github.com/user-attachments/assets/fd08a7e9-5700-479b-b9d9-5f7e06fc356e" />


**Y listo**, ya tienen todo lo necesario para desplegar sus máquinas, si realizaron correctamente los pasos anteriores solo deberían de ejecutar el siguiente comando para empezar con la creación de VSI's:
```bash
./script.sh
```
Les debería de salir lo siguiente:

<img width="828" height="520" alt="image" src="https://github.com/user-attachments/assets/1b1f20bd-2e0d-4414-a2e0-f9a6ce8986f6" />

## Paso 4(Opcional)

Para eliminar las máquinas que acabaron de crear deben ejecutar el siguiente comando comando:
```bash
./delete-script.sh
```
*Recordar que deben de editar el archivo al igual que los demás archivos*

Deberían de ver algo como esto:

<img width="600" height="379" alt="image" src="https://github.com/user-attachments/assets/2073ffb1-152e-4225-b3c4-90966dcabec3" />

De esta manera eliminas las máquinas creadas previamente
