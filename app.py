from flask import Flask, render_template
from datetime import datetime
import os
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-key-change-this')

@app.route('/')
def index():
    current_year = datetime.now().year
    return render_template('index.html', year=current_year)

if __name__ == '__main__':
    # Solo para desarrollo
    app.run(debug=True)


