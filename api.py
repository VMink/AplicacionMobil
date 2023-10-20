import pyodbc
from flask import Flask, request, jsonify

conn_str = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=10.14.255.85;"
    "DATABASE=Donation_Tracking_DB;"
    "UID=SA;"
    "PWD=Shakira123.;"
    "TrustServerCertificate=yes"
)

app = Flask(__name__)

def get_db_connection():
    try:
        conn = pyodbc.connect(conn_str)
        return conn
    except Exception as e:
        return None

#ROUTES
#########################################################################
#Login testeo de API (sin sql)
@app.route('/login', methods=['GET'])
def login():
    if True:
        return jsonify({'message': 'Funciona'}), 200
#########################################################################



#########################################################################
#Para checar que Put sirve
@app.route('/getAllRecibos', methods=['GET'])
def get_bitacora_pagos_donativos():
    try:
        connection = pyodbc.connect(conn_str)
        cursor = connection.cursor()
        cursor.execute("""
            SELECT
                OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE,
                OPE_BITACORA_PAGOS_DONATIVOS.IMPORTE,
                OPE_BITACORA_PAGOS_DONATIVOS.ESTATUS_PAGO,
                OPE_DONANTES.TEL_CASA,
                OPE_DONANTES.TEL_MOVIL,
                OPE_DIRECCIONES_COBRO.DIRECCION,
                OPE_DIRECCIONES_COBRO.REFERENCIA_DOMICILIO,
                OPE_DIRECCIONES_COBRO.COMENTARIOS,
                OPE_RECOLECTORES.UsuarioRecolector
            FROM OPE_BITACORA_PAGOS_DONATIVOS
            INNER JOIN OPE_DONANTES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE = OPE_DONANTES.ID_DONANTE
            INNER JOIN OPE_DIRECCIONES_COBRO ON OPE_DONANTES.ID_DIRECCION_COBRO = OPE_DIRECCIONES_COBRO.ID_DIRECCION_COBRO
            INNER JOIN OPE_RECOLECTORES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_RECOLECTOR = OPE_RECOLECTORES.ID_RECOLECTOR
        """)
        results = cursor.fetchall()
        cursor.close()
        connection.close()
        data = []
        for row in results:
            data.append({
                "ID_DONANTE": row.ID_DONANTE,
                "IMPORTE": row.IMPORTE,
                "ESTATUS_PAGO": row.ESTATUS_PAGO,
                "TEL_CASA": row.TEL_CASA,
                "TEL_MOVIL": row.TEL_MOVIL,
                "DIRECCION": row.DIRECCION,
                "REFERENCIA_DOMICILIO": row.REFERENCIA_DOMICILIO,
                "COMENTARIOS": row.COMENTARIOS,
                "UsuarioRecolector": row.UsuarioRecolector
            })
        return jsonify(data), 200

    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500
#########################################################################



#########################################################################
# Envio de Datos, actualizacion por botón
@app.route('/actualizarRecibo', methods=['PUT'])
def actualizar_recibo_especifico():
    try:
        # Get JSON data from the request
        data = request.get_json()
        idDonativo = data['ID_DONATIVO']
        estatusPago = data['ESTATUS_PAGO']
        comentarios = data['COMENTARIOS']

        connection = pyodbc.connect(conn_str)
        cursor = connection.cursor()
        cursor.execute("EXEC ActualizarBitacoraPagosDonativos @ID_DONATIVO = ?, @ESTATUS_PAGO = ?, @COMENTARIOS = ?", idDonativo, estatusPago, comentarios)
        connection.commit()
        cursor.close()
        connection.close()

        return 'Recibo actualizado exitosamente', 200
    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500
#########################################################################



#########################################################################
# Obtención de datos de todos los repartidores, de todas las fechas
@app.route('/datosDiarios', methods=['GET'])
def obtener_datos_diarios():
    try:
        connection = pyodbc.connect(conn_str)
        cursor = connection.cursor()
        cursor.execute("EXEC ObtenerDatosDiarios")
        datos = [{'id': row[0], 'IMPORTE': row[1], 'ESTATUS_PAGO': row[2], 'TEL_CASA': row[3], 'TEL_MOVIL': row[4], 'DIRECCION': row[5], 'REFERENCIA_DOMICILIO': row[6]} for row in cursor.fetchall()]
        cursor.close()
        connection.close()
        return jsonify(datos), 200
    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500
#########################################################################



#########################################################################
# # Obtención de datos, por usuario, por fecha actual
# @app.route('/datosDiarios/<int:IdRecolector>', methods=['GET'])
# def obtener_datos_diarios(IdRecolector):
#     try:
#         conn = get_db_connection()
#         cursor = conn.cursor()
#         cursor.execute('EXEC ObtenerDatosDiarios @IdRecolector = ?', (IdRecolector,))
#         datos = [{'ID_BITACORA': row[0], 'ID_DONANTE': row[1], 'IMPORTE': row[2], 'ID_DONATIVO': row[3], 'ESTATUS_PAGO': row[4], 'TEL_CASA': row[5], 'TEL_MOVIL': row[6], 'DIRECCION': row[7], 'REFERENCIA_DOMICILIO': row[8]} for row in cursor.fetchall()]
#         cursor.close()
#         conn.close()
#         return jsonify(datos), 200
#     except Exception as e:
#         return jsonify({'error': 'Error fetching data'}), 500
#########################################################################



#########################################################################
# Login bien hecho
# @app.route('/verificarCredenciales', methods=['POST'])
# def verify_credentials():
#     data = request.get_json()
#     username = data['USUARIO']
#     password = data['PASS']
#     try:
#         conn = get_db_connection()
#         cursor = conn.cursor()

#         cursor.execute("EXEC VerificarCredencialesRecolector @USUARIO = ?, @PASS = ?", (username, password))
#         result = cursor.fetchone()

#         if result is not None:
#             if result[0] == "Username doesnt exist":
#                 response = {'message': 'Username doesnt exist'}
#             elif result[0] == "Login successful":
#                 response = {'message': 'Login successful'}
#             elif result[0] == "Incorrect Password":
#                 response = {'message': 'Incorrect password'}
#             else:
#                 response = {'message': 'Query Result Not Expected'}
#         else:
#             response = {'message': 'Query Empty'}

#         cursor.close()
#         conn.close()
#         return jsonify(response), 200
#     except Exception as e:
#         return jsonify({'error': 'An error occurred while verifying credentials (Exception)'}), 500
#########################################################################

# Your other API endpoints
if __name__ == '__main__':
    app.run(debug=True, port=8082, host='0.0.0.0')
