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
git clone git@github.com:Ceskard26/Creacion-de-varias-VSI-en-IBMCloud-con-terraform.git
```

<img width="412" height="380" alt="Captura de pantalla 2025-08-04 a la(s) 5 00 55 p  m" src="https://github.com/user-attachments/assets/c27520c6-c26f-4c20-861c-9ff7c32b9478" />

Una vez copiado editan lo siguientes valores adaptandolos a sus recursos:

<img width="289" height="129" alt="Captura de pantalla 2025-08-04 a la(s) 5 21 36 p  m" src="https://github.com/user-attachments/assets/a17136c4-7206-405c-bd14-cc1d0612d4c0" />

## Paso 2(Editar terraform.tfvars)
```bash
region         = "region en la que van a desplegar sus máquinas"
zone_number    = "Número de la zona(usualmente 1)"
ssh_keyname    = "Nombre de la secure Shell"
vpc_name       = "Nombre de la vpc"
subnet_name    = "subnet-dallas"
vsi_count      = el número de máquinas que quieran desplegar
resource_group = "cce-ibm"
environment    = "development"
```

En el archivo script.sh editar los siguientes valores:

<img width="220" height="35" alt="Captura de pantalla 2025-08-04 a la(s) 5 26 23 p  m" src="https://github.com/user-attachments/assets/a7c6263f-b638-4548-8bcd-0a82b3848266" />

## Paso 3(Ejecución)
Una vez editado el script tenemos que loggearnos a la CLI de IBM:
con el comando:
```bash
ibmcloud login 
```
o pegar este comando luego de ir a **Perfil** y darle click a **Log in into CLI and API**

<img width="276" height="320" alt="Captura de pantalla 2025-08-04 a la(s) 5 33 02 p  m" src="https://github.com/user-attachments/assets/1de14778-852f-4de3-9cc7-c730f64ed916" />

Copiar lo siguiente y pegarlo en su CLI:

<img width="691" height="325" alt="Captura de pantalla 2025-08-04 a la(s) 5 36 22 p  m" src="https://github.com/user-attachments/assets/56f8434a-50d4-4fb5-9866-fe21128e4ea6" />

**Y listo**, ya tienen todo lo necesario para desplegar sus máquinas, si realizaron correctamente los pasos anteriores solo deberían de ejecutar el siguiente comando para empezar con la creación de VSI's:
```bash
./script.sh
```
Les debería de salir lo siguiente:

<img width="1326" height="982" alt="image" src="https://github.com/user-attachments/assets/9d02cb1e-6c80-4423-a84e-669b0274051f" />

## Paso 4(Opcional)
Si quieren eliminar las máquinas que crearon tienen que editar los siguientes valores de **delete-scripts**:

<img width="232" height="38" alt="Captura de pantalla 2025-08-04 a la(s) 6 05 45 p  m" src="https://github.com/user-attachments/assets/d7ad4452-ba49-4607-8ece-c8a156ceed4d" />

Y luego de eso ejecutar el comando:
```bash
./delete-script.sh
```
Deberían de ver algo como esto:

<img width="663" height="736" alt="Captura de pantalla 2025-08-04 a la(s) 6 11 22 p  m" src="https://github.com/user-attachments/assets/fe110840-ca05-47bb-8e60-3703b222a338" />

De esta manera eliminas las máquinas creadas previamente
