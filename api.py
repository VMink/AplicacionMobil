from flask import Flask, request, jsonify
import mssql_functions as mssql

app = Flask(__name__)

############### ROUTES ###################################

@app.route('/recibosManager', methods=['GET'])
def obtener_datos_generales():
    """
    Endpoint to obtain all the data from the receipts of a particular day to be monitored by the manager.

    Parameters:
    Null

    Returns:
    The data from all receipts of a particular day, otherwise an error message.
    """
    return mssql.obtener_datos_generales()

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
    return mssql.obtener_recibos_recolector(IdRecolector)

@app.route('/actualizarRecibo', methods=['PUT'])
def actualizar_recibo():
    """
    Endpoint to update a receipt.

    Parameters:
    Null

    Returns:
    A successful update message, otherwise an error message.
    """
    data = request.get_json()
    idBitacora = data['ID_BITACORA']
    estatusPago = data['ESTATUS_PAGO']
    comentarios = data['COMENTARIOS']

    return mssql.actualizar_recibo(idBitacora, estatusPago, comentarios)


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

    return mssql.login_recolector(username, password)

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

    return mssql.login_manager(username, password)

# Your other API endpoints
if __name__ == '__main__':
    app.run(debug=True, port=8085, host='0.0.0.0')