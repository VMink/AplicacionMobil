import jwt
import os
import pyodbc
from datetime import datetime, timedelta
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

def generate_token(username):
    token = jwt.encode({'username': username, 'exp': datetime.utcnow() + timedelta(minutes=60)}, os.environ.get('SECRETKEY'), algorithm='HS256')
    return token

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

def obtener_datos_generales(token):
    """
    Endpoint to obtain all the data from the receipts of a particular day to be monitored by the manager.

    Parameters:
    JWT Token Authorization

    Returns:
    The data from all receipts of a particular day, otherwise an error message.
    """
    try:
        payload = jwt.decode(token, os.environ.get('SECRETKEY'), algorithms=['HS256'])
        connection = pyodbc.connect(conn_str)
        cursor = connection.cursor()
        cursor.execute("EXEC ObtenerDatosDiariosManager")
        data = [{'id': int(row[0]), 'ID_DONANTE': int(row[1]), 'ID_RECOLECTOR': int(row[2]), 'USUARIO_RECOLECTOR': row[3], 'ID_RECIBO': row[4], 'FECHA_COBRO': row[5],  'FECHA_PAGO': row[6] if row[6] is not None else '', 'IMPORTE': row[7], 'ESTATUS_PAGO': int(row[8]), 'COMENTARIOS': row[9], 'TEL_CASA': row[10], 'TEL_MOVIL': row[11], 'DIRECCION': row[12], 'REFERENCIA_DOMICILIO': row[13], 'NOMBRE_DONANTE': row[14]} for row in cursor.fetchall()]
        connection.close()
        return jsonify(data), 200

    except Exception as e:
        print(e)
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500

def obtener_recibos_recolector(IdRecolector, token):
    """
    Endpoint to obtain the data of all the receipts assigned to a particular delivery guy on a
    particular day.

    Parameters:
    IdRecolector: Id of the Delivery Man from which to obtain the receipts.
    token: JWT Token Authorization

    Returns:
    The data from all receipts of a particular delivery man and a particular day, otherwise
    an error message.
    """
    try:
        payload = jwt.decode(token, os.environ.get('SECRETKEY'), algorithms=['HS256'])
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('EXEC ObtenerDatosDiarios @IdRecolector = ?', (IdRecolector,))
        datos = [{'id': int(row[0]), 'ID_RECIBO': row[1], 'ID_DONANTE': int(row[2]), 'IMPORTE': row[3], 'ESTATUS_PAGO': int(row[4]), 'TEL_CASA': row[5], 'TEL_MOVIL': row[6], 'DIRECCION': row[7],  'REFERENCIA_DOMICILIO': row[8], 'NOMBRE_DONANTE': row[9], 'FECHA_PAGO': row[10] if row[10] is not None else ''} for row in cursor.fetchall()]
        conn.close()
        return jsonify(datos), 200
    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500

def actualizar_recibo(ID_BITACORA, ESTATUS_PAGO, COMENTARIOS, TOKEN):
    """
    Endpoint to update a receipt.

    Parameters:
    ID_BITACORA: The ID of the receipt you want to update
    ESTATUS_PAGO: The new status of the receipt (int)
    COMENTARIOS: A comment to add to the receipt
    TOKEN: JWT Token Authorization.

    Returns:
    A successful update message, otherwise an error message.
    """
    try:
        payload = jwt.decode(TOKEN, os.environ.get('SECRETKEY'), algorithms=['HS256'])
        connection = pyodbc.connect(conn_str)
        cursor = connection.cursor()
        cursor.execute("EXEC ActualizarBitacoraPagosDonativos @ID_BITACORA = ?, @ESTATUS_PAGO = ?, @COMENTARIOS = ?", ID_BITACORA, ESTATUS_PAGO, COMENTARIOS)
        connection.commit()
        cursor.close()
        connection.close()

        return 'Recibo actualizado exitosamente', 200
    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500

def login_recolector(USUARIO, PASS):
    """
    Endpoint to validate the credentials of a delivery man.

    Parameters:
    USUARIO: Username of the delivery man.
    PASS: Password of the delivery man.

    Returns:
    The user's id and token, otherwise an error message.
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("EXEC VerificarCredencialesRecolector @USUARIO = ?, @PASS = ?", (USUARIO, PASS))
        result = cursor.fetchone()

        if result is not None and int(result[0]) != 0:
            token = generate_token(USUARIO)
            response = {'id': int(result[0]), 'token': token}
        else:
            response = {'id': 0}

        cursor.close()
        conn.close()
        return jsonify(response), 200

    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500

def login_manager(USUARIO, PASS):
    """
    Endpoint to validate the credentials of a manager.

    Parameters:
    USUARIO: Username of the manager.
    PASS: Password of the manager.

    Returns:
    The authentication status and token, otherwise an error message.
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("EXEC VerificarCredencialesManager @USUARIO = ?, @PASS = ?", (USUARIO, PASS))
        result = cursor.fetchone()

        if result is not None:
            if result[0] == "Authentication failed":
                response = {'message': 'Authentication failed'}
            elif result[0] == "Authentication successful":
                token = generate_token(USUARIO)
                response = {'message': 'Authentication successful', 'token': token}
            else:
                print(result[0])
                response = {'message': 'Query Result Not Expected'}
        else:
            print("ohno4")
            response = {'message': 'Empty Query'}

        cursor.close()
        return jsonify(response), 200

    except Exception as e:
        error_message = "An error occurred while processing the request: " + str(e)
        return jsonify({'error': error_message}), 500
