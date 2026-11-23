import os
import psycopg2
from flask import Flask, render_template, request

app = Flask(__name__)

# Credenciales del lado del servidor (coinciden con tu compose.yaml)
DB_HOST = os.getenv("PGHOST", "localhost")
DB_PORT = os.getenv("PGPORT", "5434")
DB_NAME = os.getenv("PGDATABASE", "uif_db")
DB_USER = os.getenv("PGUSER", "postgres")
DB_PASS = os.getenv("PGPASSWORD", "contrasena_de_prueba")

def obtener_conexion():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )

# Ruta 1: Muestra la página web con el formulario
@app.route("/", methods=["GET"])
def inicio():
    return render_template("index.html")

# Ruta 2: Recibe los datos del formulario y los guarda en PostgreSQL
@app.route("/registrar", methods=["POST"])
def registrar():
    id_notario = request.form["id_notario"]
    nombre_institucion = request.form["nombre_institucion"]
    sector_economico = request.form["sector_economico"]

    try:
        conn = obtener_conexion()
        cur = conn.cursor()
        # Consulta parametrizada (%s) para evitar inyección SQL
        cur.execute(
            """
            INSERT INTO entidad_norm (id_notario, nombre_institucion, sector_economico)
            VALUES (%s, %s, %s);
            """,
            (id_notario, nombre_institucion, sector_economico)
        )
        conn.commit()
        cur.close()
        conn.close()
        mensaje = f"Registro guardado correctamente (ID Notario: {id_notario})."
    except Exception as e:
        mensaje = f"Error al guardar en la base de datos: {e}"

    return render_template("index.html", mensaje=mensaje)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)