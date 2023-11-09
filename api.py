import os
import pyodbc
from dotenv import load_dotenv
from flask import Flask, request, jsonify

load_dotenv('app.env')

conn_str = (
    f"DRIVER={os.environ.get('DRIVER')};"
    f"SERVER={os.environ.get('SERVER')};"
    f"DATABASE={os.environ.get('DATABASE')};"
    f"UID={os.environ.get('UID')};"
    f"PWD={os.environ.get('PASS')};"
    f"TrustServerCertificate={os.environ.get('TrustServerCertificate')}"
)

app = Flask(__name__)

def get_db_connection():
    """
    Method to create a connection with the database.

    Parameters:
    Null

    Returns:
    The connection to the database if successful, otherwise returns an empty value.
    """
    try:
        conn = pyodbc.connect(conn_str)
        return conn
    except Exception as e:
        return None
    
############### ROUTES ###################################

@app.route('/test', methods=['GET'])
def login():
    """
    Endpoint to test the operational status of the API

    Parameters:
    Null

    Returns:
    Message to indicate API is up and status 200 OK
    """
    if True:
        return jsonify({'message': 'Funciona'}), 200

@app.route('/recibosManager', methods=['GET'])
def obtener_datos_generales():
    """
    Endpoint to obtain all the data from the receipts of a particular day to be monitored by the manager.

    Parameters:
    Null

    Returns:
    The data from all receipts of a particular day, otherwise an error message.
    """
    try:
        connection = pyodbc.connect(conn_str)
        cursor = connection.cursor()
        cursor.execute("EXEC ObtenerDatosDiariosManager")
        data = [{'id': int(row[0]), 'ID_DONANTE': int(row[1]), 'ID_RECOLECTOR': int(row[2]), 'USUARIO_RECOLECTOR': row[3], 'ID_RECIBO': row[4], 'FECHA_COBRO': row[5], 'FECHA_PAGO': row[6], 'IMPORTE': row[7], 'ESTATUS_PAGO': row[8], 'COMENTARIOS': row[9], 'TEL_CASA': row[10], 'TEL_MOVIL': row[11], 'DIRECCION': row[12], 'REFERENCIA_DOMICILIO': row[13], 'NOMBRE_DONANTE': row[14]} for row in cursor.fetchall()]
        cursor.close()
        connection.close()
        return jsonify(data), 200
    
    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500

@app.route('/recibosRecolector', methods=['POST'])
def obtener_recibos_recolector():
    """
    Endpoint to obtain the data of all the receipts assigned to a particular delivery guy on a
    particular day.

    Parameters:
    IdRecolector: Id of the Delivery Guy from which to obtain the receipts.

    Returns:
    The data from all receipts of a particular delivery guy and a particular day, otherwise
    an error message.
    """
    data = request.get_json()
    IdRecolector = data['IdRecolector']
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('EXEC ObtenerDatosDiarios @IdRecolector = ?', (IdRecolector,))
        datos = [{'id': int(row[0]), 'ID_RECIBO': row[1], 'ID_DONANTE': int(row[2]), 'IMPORTE': row[3], 'ESTATUS_PAGO': row[4], 'TEL_CASA': row[5], 'TEL_MOVIL': row[6], 'DIRECCION': row[7], 'REFERENCIA_DOMICILIO': row[8], 'NOMBRE_DONANTE': row[9],} for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return jsonify(datos), 200
    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500

@app.route('/actualizarRecibo', methods=['PUT'])
def actualizar_recibo():
    """
    Endpoint to update a receipt.

    Parameters:
    Null

    Returns:
    A successful update message, otherwise an error message.
    """
    try:
        data = request.get_json()
        idBitacora = data['ID_BITACORA']
        estatusPago = data['ESTATUS_PAGO']
        comentarios = data['COMENTARIOS']

        connection = pyodbc.connect(conn_str)
        cursor = connection.cursor()
        cursor.execute("EXEC ActualizarBitacoraPagosDonativos @ID_BITACORA = ?, @ESTATUS_PAGO = ?, @COMENTARIOS = ?", idBitacora, estatusPago, comentarios)
        connection.commit()
        cursor.close()
        connection.close()

        return 'Recibo actualizado exitosamente', 200
    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500
    

@app.route('/loginRecolector', methods=['POST'])
def login_recolector():
    """
    Endpoint to validate the credentials of a delivery guy.

    Parameters:
    USUARIO: Username of the delivery guy.
    PASS: Password of the delivery guy.

    Returns:
    The authentication status, otherwise an error message.
    """
    data = request.get_json()
    username = data['USUARIO']
    password = data['PASS']
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("EXEC VerificarCredencialesRecolector @USUARIO = ?, @PASS = ?", (username, password))
        result = cursor.fetchone()

        if result is not None:
            response = {'id': int(result[0])}
        else:
            response = {'id': 0}

        cursor.close()
        conn.close()
        return jsonify(response), 200

    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500

@app.route('/loginManager', methods=['POST'])
def login_manager():
    """
    Endpoint to validate the credentials of a manager.

    Parameters:
    USUARIO: Username of the manager.
    PASS: Password of the manager.

    Returns:
    The authentication status, otherwise an error message.
    """
    data = request.get_json()
    username = data['USUARIO']
    password = data['PASS']
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("EXEC VerificarCredencialesManager @USUARIO = ?, @PASS = ?", (username, password))
        result = cursor.fetchone()

        if result is not None:
            if result[0] == "Authentication failed":
                response = {'message': 'Authentication failed'}
            elif result[0] == "Authentication successful":
                response = {'message': 'Authentication successful'}
            else:
                print(result[0])
                response = {'message': 'Query Result Not Expected'}
        else:
            response = {'message': 'Empty Query'}
        
        cursor.close()
        conn.close()
        return jsonify(response), 200

    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500


# Your other API endpoints
if __name__ == '__main__':
    app.run(debug=True, port=8082, host='0.0.0.0')