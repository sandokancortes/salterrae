# Proyecto Web Flask

Aplicación web simple creada con Flask que muestra una página con una imagen centrada y un footer con el año actual.

## Estructura del Proyecto

```
salterrae/
├── app.py                 # Aplicación principal Flask
├── requirements.txt       # Dependencias del proyecto
├── templates/
│   └── index.html        # Plantilla HTML principal
└── static/
    ├── css/
    │   └── style.css     # Estilos CSS
    └── images/
        └── banner.jpg    # Imagen banner (agregar tu imagen aquí)
```

## Instalación

1. Crear un entorno virtual:
```bash
python -m venv venv
```

2. Activar el entorno virtual:
- Windows:
```bash
venv\Scripts\activate
```
- Linux/Mac:
```bash
source venv/bin/activate
```

3. Instalar las dependencias:
```bash
pip install -r requirements.txt
```

4. Agregar tu imagen en `static/images/banner.jpg`

## Ejecución

```bash
python app.py
```

La aplicación estará disponible en: http://127.0.0.1:5000/

## Características

- **Content**: Imagen widescreen centrada verticalmente con fondo blanco
- **Footer**: Altura de 30px, fondo oscuro, texto claro, muestra el año actual centrado
- Diseño responsive que se adapta a diferentes tamaños de pantalla


