#!/bin/bash

# Script de deployment automatizado para Sal Terræ
# Uso: sudo ./deploy.sh

set -e  # Detener en caso de error

echo "=========================================="
echo "  Deployment de Sal Terræ"
echo "=========================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Por favor ejecuta como root (sudo)${NC}"
    exit 1
fi

# Variables
APP_DIR="/var/www/salterrae"
VENV_DIR="$APP_DIR/venv"
LOG_DIR="/var/log/salterrae"
RUN_DIR="/var/run/salterrae"

echo -e "${YELLOW}[1/8] Actualizando sistema...${NC}"
apt update && apt upgrade -y

echo -e "${YELLOW}[2/8] Instalando dependencias...${NC}"
apt install -y python3-pip python3-venv nginx git

echo -e "${YELLOW}[3/8] Creando directorios...${NC}"
mkdir -p $APP_DIR
mkdir -p $LOG_DIR
mkdir -p $RUN_DIR

echo -e "${YELLOW}[4/8] Copiando archivos de la aplicación...${NC}"
# Copiar archivos al directorio de producción
# Asume que el script está en el directorio del proyecto
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cp -r $SCRIPT_DIR/* $APP_DIR/

echo -e "${YELLOW}[5/8] Configurando entorno virtual...${NC}"
cd $APP_DIR
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo -e "${YELLOW}[6/8] Configurando permisos...${NC}"
chown -R www-data:www-data $APP_DIR
chown -R www-data:www-data $LOG_DIR
chown -R www-data:www-data $RUN_DIR
chmod -R 755 $APP_DIR

echo -e "${YELLOW}[7/8] Configurando servicios...${NC}"
# Copiar y habilitar servicio systemd
cp $APP_DIR/salterrae.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable salterrae
systemctl restart salterrae

# Configurar Nginx
cp $APP_DIR/nginx.conf /etc/nginx/sites-available/salterrae
ln -sf /etc/nginx/sites-available/salterrae /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Verificar configuración de Nginx
nginx -t

# Reiniciar Nginx
systemctl restart nginx

echo -e "${YELLOW}[8/8] Configurando firewall...${NC}"
ufw allow 'Nginx Full'
ufw allow 'OpenSSH'
echo "y" | ufw enable

echo ""
echo -e "${GREEN}=========================================="
echo "  ¡Deployment completado exitosamente!"
echo "==========================================${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Edita /var/www/salterrae/.env y configura SECRET_KEY"
echo "2. Edita /etc/nginx/sites-available/salterrae y pon tu dominio"
echo "3. Reinicia los servicios:"
echo "   sudo systemctl restart salterrae"
echo "   sudo systemctl restart nginx"
echo ""
echo "Para configurar SSL:"
echo "   sudo apt install certbot python3-certbot-nginx"
echo "   sudo certbot --nginx -d tudominio.com"
echo ""
echo "Verificar estado:"
echo "   sudo systemctl status salterrae"
echo "   sudo systemctl status nginx"
echo ""

