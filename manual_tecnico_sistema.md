# Manual Técnico - Sistema San Gabriel 5.4

## 1. Arquitectura y Entorno de Desarrollo (Cloud Shell Editor)

### 1.1 Naturaleza del Entorno Cloud Shell
Google Cloud Shell opera dentro de un contenedor Docker efímero sobre una máquina virtual de Google Cloud. En este entorno:
- **Almacenamiento Persistente:** Únicamente el directorio `/home/angelomarsanz/` (asignado a un disco persistente de usuario) sobrevive al reinicio o apagado por inactividad.
- **Sistema Base Efímero:** Los directorios raíz del sistema (`/usr`, `/var`, `/etc`, etc.) se restablecen a la imagen base limpia de Google cada vez que la sesión de Cloud Shell se cierra o expira.

### 1.2 Estrategia de Persistencia y Automatización
Para garantizar la continuidad del desarrollo sin perder configuraciones ni datos:

1. **Automatización de Paquetes (`~/.customize_environment`):**
   - Script nativo de Cloud Shell ubicado en `/home/angelomarsanz/.customize_environment`.
   - Se ejecuta automáticamente con privilegios de `root` cada vez que el contenedor se aprovisiona.
   - Instala las dependencias del sistema: `php8.3-intl`, `php8.3-sqlite3`, `lftp` y `mariadb-server`.

2. **Persistencia de Base de Datos (`/home/angelomarsanz/mariadb_data`):**
   - El directorio de datos (`datadir`) de MariaDB se encuentra alojado dentro del almacenamiento persistente del usuario en `/home/angelomarsanz/mariadb_data`.
   - La configuración se aplica en `/etc/mysql/conf.d/persistencia.cnf`:
     ```ini
     [mysqld]
     datadir = /home/angelomarsanz/mariadb_data
     ```
   - Gracias a esta arquitectura, la base de datos `angeltest_sangabriel` con sus 41 tablas y todos los datos reales (volcado de 175 MB) no se pierden tras el reinicio del contenedor.

3. **Script de Verificación y Restauración Rápida (`preparar_entorno.sh`):**
   - Ubicación: `/home/angelomarsanz/sistemasangabriel_54/preparar_entorno.sh`
   - Permite verificar o restaurar manualmente en segundos el estado de las extensiones PHP, permisos del home y servicio MariaDB.
   - Uso:
     ```bash
     ./preparar_entorno.sh
     ```

### 1.3 Ejecución del Servidor Web de Desarrollo
Para iniciar el servidor integrado de CakePHP 5.4 en Cloud Shell:
```bash
bin/cake server -H 0.0.0.0 -p 8080
```
La aplicación queda accesible mediante la funcionalidad de "Vista previa en la web" (puerto 8080) de Cloud Shell Editor.
