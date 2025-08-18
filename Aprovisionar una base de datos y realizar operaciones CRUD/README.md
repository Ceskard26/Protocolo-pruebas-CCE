# Guía: Base de Datos PostgreSQL en IBM Cloud

## Tabla de Contenidos
1. [Creación de la Base de Datos en IBM Cloud](#1-creación-de-la-base-de-datos-en-ibm-cloud)
2. [Obtener Credenciales de Conexión](#2-obtener-credenciales-de-conexión)
3. [Conexión a la Base de Datos con psql](#3-conexión-a-la-base-de-datos-con-psql)
4. [Operaciones en la Base de Datos](#4-operaciones-en-la-base-de-datos)
   - [Creación de Tablas](#creación-de-tablas)
   - [Inserción de Datos](#inserción-de-datos)
   - [Actualización de Datos](#actualización-de-datos)
   - [Eliminación de Datos](#eliminación-de-datos)

---

## 1. Creación de la Base de Datos en IBM Cloud

### Paso 1: Acceder al Catálogo de IBM Cloud

1. Inicie sesión en [IBM Cloud](https://cloud.ibm.com)
2. En el panel principal, haga clic en **"Catalog"** (Catálogo)

<img width="2880" height="1170" alt="image" src="https://github.com/user-attachments/assets/8ad8749b-6111-4e6b-be64-56826b6f8d32" />

### Paso 2: Buscar el Servicio PostgreSQL

1. En el catálogo, busque "PostgreSQL" en la barra de búsqueda
2. Seleccione **"Databases for PostgreSQL"**

<img width="2880" height="1464" alt="image" src="https://github.com/user-attachments/assets/e5fd5ce6-1771-4c22-81fb-226e96763fc0" />

### Paso 3: Configurar la Instancia

1. En la página de configuración, complete los siguientes campos:

   - **Service name**: Ingrese un nombre para su base de datos (ej: `mi-postgresql-db`)
   - **Location**: Seleccione la región más cercana a sus usuarios
   - **Resource group**: Mantenga "Default" o seleccione el grupo de recursos apropiado
   - **Hosting Model**: Seleccione el plan que se ajuste a sus necesidades

<img width="1090" height="770" alt="image" src="https://github.com/user-attachments/assets/4aac880f-1989-4c1e-a9a2-0686a8c763a2" />

### Paso 4: Crear la Instancia

1. Revise la configuración
2. Haga clic en **"Create"** (Crear)
3. Espere a que la instancia se aprovisione (puede tomar varios minutos)

**[Screenshot necesario: Pantalla de aprovisionamiento mostrando el progreso de creación]**

---

## 2. Obtener Credenciales de Conexión

### Paso 1: Obtener las Credenciales

1. Primero ir a la pestaña de settings en donde está la opción de generar contraseña.

<img width="2842" height="1512" alt="image" src="https://github.com/user-attachments/assets/78a0fd46-89a6-480f-9582-4b7f88123bb1" />

2. Luego de esto crear dar click en generar la contraseña y guardar los cambios.

   <img width="2200" height="678" alt="image" src="https://github.com/user-attachments/assets/48ee466e-0854-4187-8e53-6013ecba4c93" />

3. Luego ir a la vista **Overview** scrollear hasta el fondo y copiar el endpoint.

<img width="1165" height="624" alt="Captura de pantalla 2025-08-08 a la(s) 3 38 46 p  m" src="https://github.com/user-attachments/assets/715bb84d-c5dc-4c59-8f04-6ae24e480b95" />


## 3. Conexión a la Base de Datos con psql

### Instalación de psql (si no está instalado)

**En Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql-client
```

**En macOS:**
```bash
brew install postgresql
```

**En Windows:**
Descargue PostgreSQL desde [postgresql.org](https://www.postgresql.org/download/windows/)

### Comando de Conexión
1. Primero debemos conectarnos a la CLI de IBM Cloud, vamos a perfil:

<img width="276" height="320" alt="Captura de pantalla 2025-08-04 a la(s) 5 33 02 p  m" src="https://github.com/user-attachments/assets/f86eb79a-fc8c-4b45-8bd0-9c1eae87d498" />

damos click y copiamos
## 4. Operaciones en la Base de Datos

### Creación de Tablas

#### Ejemplo: Tabla de Productos
```sql
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    categoria VARCHAR(50),
    activo BOOLEAN DEFAULT true
);
```
### Inserción de Datos

#### Insertar productos:
```sql
INSERT INTO productos (nombre, precio, stock, categoria) VALUES 
('Laptop Dell', 899.99, 15, 'Electrónicos'),
('Mouse Inalámbrico', 25.50, 50, 'Accesorios'),
('Teclado Mecánico', 120.00, 20, 'Accesorios'),
('Monitor 24"', 199.99, 8, 'Electrónicos');
```

### Actualización de Datos

#### Actualizar precio de un producto:
```sql
UPDATE productos 
SET precio = 849.99 
WHERE id = 1;
```

#### Actualizar múltiples campos:
```sql
UPDATE productos 
SET precio = 22.99, stock = 45 
WHERE nombre = 'Mouse Inalámbrico';
```

### Eliminación de Datos

#### Eliminar un producto específico:
```sql
DELETE FROM productos 
WHERE id = 4;
```

#### Eliminar productos sin stock:
```sql
DELETE FROM productos 
WHERE stock = 0;
```

---

## Comandos Útiles Adicionales

### Ver las tablas creadas:
```sql
\dt
```

### Describir estructura de una tabla:
```sql
\d nombre_tabla
```

### Ver datos de una tabla:
```sql
SELECT * FROM productos;
```

### Salir de psql:
```sql
\q
```

---

## Verificación de Operaciones

Para verificar que todas las operaciones se ejecutaron correctamente:

```sql
-- Verificar datos en tablas
SELECT COUNT(*) as total_productos FROM productos;
```

---

## Notas Importantes

1. **Siempre use conexiones SSL** para mantener la seguridad de sus datos
2. **Haga respaldos regulares** de sus datos importantes
3. **Mantenga sus credenciales seguras** y no las comparta en repositorios públicos
4. **Monitore el uso de recursos** desde el panel de IBM Cloud
5. **Use transacciones** para operaciones complejas que requieran consistencia

---

## Solución de Problemas Comunes

### Error de conexión SSL:
Si recibe errores SSL, asegúrese de incluir `sslmode=require` en su cadena de conexión.

### Timeout de conexión:
Verifique que su IP esté permitida en las configuraciones de red de IBM Cloud.

### Permisos insuficientes:
Use las credenciales de administrador proporcionadas por IBM Cloud para operaciones DDL (CREATE, ALTER, DROP).

---
Autor: [CeskarD26](https://github.com/Ceskard26)
