#!/usr/bin/env bash
# ==============================================================================
# Sistema San Gabriel 5.4 - Script de Preparación de Entorno (Cloud Shell)
# Verifica y restablece extensiones PHP, configuración de MariaDB y permisos.
# ==============================================================================

set -e

echo "=== Verificando extensiones de PHP ==="
EXT_FALTANTES=""
if ! php -m | grep -q "^intl$"; then
    EXT_FALTANTES="$EXT_FALTANTES php8.3-intl"
fi

if ! php -m | grep -q "^sqlite3$"; then
    EXT_FALTANTES="$EXT_FALTANTES php8.3-sqlite3"
fi

if [ -n "$EXT_FALTANTES" ]; then
    echo "Instalando extensiones faltantes: $EXT_FALTANTES..."
    sudo apt-get update -y
    sudo apt-get install -y $EXT_FALTANTES
else
    echo "Extensiones PHP (intl, sqlite3) ya se encuentran instaladas."
fi

echo "=== Verificando configuración de zend.assertions ==="
if [ "$(php -r 'echo ini_get("zend.assertions");')" != "1" ]; then
    echo "Configurando zend.assertions = 1..."
    sudo bash -c 'cat << "EOF" > /etc/php/8.3/mods-available/cakephp-dev.ini
; Configuración para entorno de desarrollo CakePHP 5
zend.assertions = 1
EOF'
    sudo phpenmod cakephp-dev
    sudo sed -i 's/^zend.assertions\s*=\s*-1/zend.assertions = 1/' /etc/php/8.3/cli/php.ini
    echo "zend.assertions configurado a 1."
else
    echo "zend.assertions ya está configurado en 1."
fi

echo "=== Verificando MariaDB Server ==="
if ! command -v mariadbd >/dev/null 2>&1; then
    echo "Instalando MariaDB Server..."
    sudo apt-get update -y
    sudo apt-get install -y mariadb-server
fi

# Asegurar datadir persistente
if [ -d "/home/angelomarsanz/mariadb_data" ]; then
    echo "Asegurando permisos y configuración de datadir persistente..."
    chmod 755 /home/angelomarsanz
    sudo chown -R mysql:mysql /home/angelomarsanz/mariadb_data
    sudo bash -c 'cat << "EOF" > /etc/mysql/conf.d/persistencia.cnf
[mysqld]
datadir = /home/angelomarsanz/mariadb_data
EOF'
fi

# Iniciar MariaDB si no está corriendo
if ! sudo service mariadb status >/dev/null 2>&1; then
    echo "Iniciando servicio MariaDB..."
    sudo service mariadb start
else
    echo "Servicio MariaDB activo."
fi

echo "=== Entorno listo para CakePHP 5.4 ==="
php -v | head -n 1
bin/cake --version
