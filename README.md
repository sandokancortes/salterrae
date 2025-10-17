# Sal Terræ - Sitio Web

Aplicación web creada con Flask para el proyecto Sal Terræ. Presenta una página informativa con citas bíblicas y enlace al canal de YouTube.

## Estructura del Proyecto

```
salterrae/
├── app.py                    # Aplicación principal Flask
├── requirements.txt          # Dependencias del proyecto
├── gunicorn_config.py        # Configuración de Gunicorn
├── nginx.conf                # Configuración de Nginx
├── salterrae.service         # Servicio systemd
├── deploy.sh                 # Script de deployment automatizado
├── DEPLOYMENT.md             # Guía detallada de deployment
├── .env.example              # Ejemplo de variables de entorno
├── templates/
│   └── index.html           # Plantilla HTML principal
└── static/
    ├── css/
    │   └── style.css        # Estilos CSS
    └── images/
        ├── st_logo.png      # Logo del header
        ├── banner.png       # Imagen banner
        └── favicon.ico      # Favicon
```

## Desarrollo Local

### Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/tu-usuario/salterrae.git
cd salterrae
```

2. Crear un entorno virtual:
```bash
python -m venv venv
```

3. Activar el entorno virtual:
- Windows:
```bash
venv\Scripts\activate
```
- Linux/Mac:
```bash
source venv/bin/activate
```

4. Instalar las dependencias:
```bash
pip install -r requirements.txt
```

5. Crear archivo .env:
```bash
cp .env.example .env
```

### Ejecución

```bash
python app.py
```

La aplicación estará disponible en: http://127.0.0.1:5000/

## Deployment en Producción

### Método Automatizado

El método más rápido es usar el script de deployment:

```bash
sudo ./deploy.sh
```

### Método Manual

Para instrucciones detalladas paso a paso, consulta [DEPLOYMENT.md](DEPLOYMENT.md)

### Requisitos de Producción

- Ubuntu/Debian 20.04 LTS o superior
- Python 3.8+
- Nginx
- Gunicorn
- Dominio (opcional pero recomendado)

## Características

- **Header**: Logo centrado con fondo oscuro
- **Content**: 
  - Imagen banner centrada
  - Cita bíblica (Mateo 5:13-14)
  - Enlace a canal de YouTube
- **Footer**: Año actual centrado con fondo oscuro
- Diseño responsive
- Optimizado para producción con Gunicorn y Nginx

## Tecnologías

- **Backend**: Flask 3.0.0
- **Server**: Gunicorn 21.2.0
- **Web Server**: Nginx
- **Python**: 3.8+

## Configuración SSL

Para habilitar HTTPS con Let's Encrypt:

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d tudominio.com -d www.tudominio.com
```

## Comandos Útiles

```bash
# Ver logs de la aplicación
sudo journalctl -u salterrae -f

# Reiniciar la aplicación
sudo systemctl restart salterrae

# Reiniciar Nginx
sudo systemctl restart nginx

# Ver estado de servicios
sudo systemctl status salterrae
sudo systemctl status nginx
```

## Soporte

Para más información, consulta:
- [DEPLOYMENT.md](DEPLOYMENT.md) - Guía completa de deployment
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)

## Licencia

© 2025 Sal Terræ. Todos los derechos reservados.


