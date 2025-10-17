# Guía de Deployment - Sal Terræ

Esta guía te ayudará a desplegar la aplicación Flask en un servidor de producción usando Nginx y Gunicorn.

## Requisitos Previos

- Servidor Ubuntu/Debian (20.04 LTS o superior)
- Acceso root o sudo
- Dominio apuntando a tu servidor (opcional pero recomendado)
- Python 3.8 o superior

## Paso 1: Preparar el Servidor

```bash
# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias
sudo apt install python3-pip python3-venv nginx git -y

# Crear usuario para la aplicación (opcional)
sudo useradd -m -s /bin/bash salterrae
```

## Paso 2: Clonar y Configurar la Aplicación

```bash
# Crear directorio de la aplicación
sudo mkdir -p /var/www/salterrae
sudo chown -R www-data:www-data /var/www/salterrae

# Navegar al directorio
cd /var/www/salterrae

# Clonar tu repositorio (o copiar archivos)
# git clone https://github.com/tu-usuario/salterrae.git .

# Crear entorno virtual
python3 -m venv venv

# Activar entorno virtual
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Crear archivo .env desde el ejemplo
cp .env.example .env

# Editar .env con tus valores
nano .env
# Cambia SECRET_KEY por una clave segura generada con:
# python -c "import secrets; print(secrets.token_hex(32))"
```

## Paso 3: Crear Directorios de Logs

```bash
# Crear directorios para logs
sudo mkdir -p /var/log/salterrae
sudo mkdir -p /var/run/salterrae
sudo chown -R www-data:www-data /var/log/salterrae
sudo chown -R www-data:www-data /var/run/salterrae
```

## Paso 4: Configurar Gunicorn como Servicio

```bash
# Copiar el archivo de servicio
sudo cp salterrae.service /etc/systemd/system/

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar el servicio
sudo systemctl enable salterrae

# Iniciar el servicio
sudo systemctl start salterrae

# Verificar el estado
sudo systemctl status salterrae
```

## Paso 5: Configurar Nginx

```bash
# Copiar configuración de nginx
sudo cp nginx.conf /etc/nginx/sites-available/salterrae

# Editar la configuración con tu dominio
sudo nano /etc/nginx/sites-available/salterrae
# Cambia 'salterrae.com' por tu dominio real

# Crear enlace simbólico
sudo ln -s /etc/nginx/sites-available/salterrae /etc/nginx/sites-enabled/

# Eliminar configuración por defecto (opcional)
sudo rm /etc/nginx/sites-enabled/default

# Verificar configuración
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
```

## Paso 6: Configurar Firewall (UFW)

```bash
# Permitir SSH
sudo ufw allow OpenSSH

# Permitir HTTP
sudo ufw allow 'Nginx HTTP'

# Permitir HTTPS (para cuando configures SSL)
sudo ufw allow 'Nginx HTTPS'

# Habilitar firewall
sudo ufw enable

# Verificar estado
sudo ufw status
```

## Paso 7: Configurar SSL con Let's Encrypt (Recomendado)

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtener certificado SSL
sudo certbot --nginx -d salterrae.com -d www.salterrae.com

# El certificado se renovará automáticamente
# Verificar renovación automática:
sudo certbot renew --dry-run
```

Después de obtener el certificado SSL, descomenta la sección HTTPS en `nginx.conf` y reinicia nginx:

```bash
sudo systemctl restart nginx
```

## Comandos Útiles

### Gestión del Servicio

```bash
# Ver logs de la aplicación
sudo journalctl -u salterrae -f

# Reiniciar la aplicación
sudo systemctl restart salterrae

# Detener la aplicación
sudo systemctl stop salterrae

# Ver estado
sudo systemctl status salterrae
```

### Gestión de Nginx

```bash
# Reiniciar Nginx
sudo systemctl restart nginx

# Recargar configuración (sin downtime)
sudo systemctl reload nginx

# Ver logs de Nginx
sudo tail -f /var/log/nginx/salterrae_access.log
sudo tail -f /var/log/nginx/salterrae_error.log
```

### Actualizar la Aplicación

```bash
# Navegar al directorio
cd /var/www/salterrae

# Activar entorno virtual
source venv/bin/activate

# Obtener cambios (si usas git)
git pull origin main

# Instalar nuevas dependencias
pip install -r requirements.txt

# Reiniciar el servicio
sudo systemctl restart salterrae
```

## Solución de Problemas

### La aplicación no inicia

```bash
# Verificar logs
sudo journalctl -u salterrae -n 50
sudo tail -f /var/log/salterrae/error.log
```

### Error de permisos

```bash
# Asegurar permisos correctos
sudo chown -R www-data:www-data /var/www/salterrae
sudo chmod -R 755 /var/www/salterrae
```

### Nginx muestra 502 Bad Gateway

```bash
# Verificar que Gunicorn esté corriendo
sudo systemctl status salterrae

# Verificar logs
sudo journalctl -u salterrae -f
```

### Cambios en archivos estáticos no se reflejan

```bash
# Limpiar cache de navegador o usar:
# Ctrl + Shift + R (Chrome/Firefox)
# Cmd + Shift + R (Mac)
```

## Seguridad Adicional

1. **Cambiar puertos por defecto** (SSH)
2. **Configurar fail2ban** para protección contra ataques
3. **Mantener el sistema actualizado**
4. **Usar SSH keys** en lugar de contraseñas
5. **Configurar backups automáticos**

## Monitoreo

Considera instalar herramientas de monitoreo como:
- **Uptime Robot** - Monitoreo de disponibilidad
- **New Relic** - Monitoreo de rendimiento
- **Sentry** - Seguimiento de errores

## Backups

```bash
# Script simple de backup
#!/bin/bash
BACKUP_DIR="/backup/salterrae"
DATE=$(date +%Y%m%d_%H%M%S)

# Crear directorio de backup
mkdir -p $BACKUP_DIR

# Backup de la aplicación
tar -czf $BACKUP_DIR/salterrae_$DATE.tar.gz /var/www/salterrae

# Mantener solo los últimos 7 backups
find $BACKUP_DIR -name "salterrae_*.tar.gz" -mtime +7 -delete
```

## Soporte

Para más información sobre Flask en producción:
- [Flask Deployment Options](https://flask.palletsprojects.com/en/3.0.x/deploying/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)
- [Nginx Documentation](https://nginx.org/en/docs/)

