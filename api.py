from flask import Flask, request, jsonify
from flasgger import Swagger
import mssql_functions as mssql

app = Flask(__name__)
swagger = Swagger(app, template={
    "swagger": "2.0",
    "info": {
        "title": "API Caritas MTY",
        "description": "API para Aplicación Móvil Caritas MTY",
        "version": "3.2.1",
    },
    "host": "http://10.14.255.85:8085",
    "tags": [
        {"name": "Manager", "description": "Endpoints para Manager"},
        {"name": "Recolector", "description": "Endpoints para Recolector"},
    ],
})

@app.route('/health', methods=['GET'])
def health_check():
    """
    Endpoint for health check of the API.
    
    ---
    tags:
      - Manager
    responses:
      200:
        description: API is healthy and running
    """
    return 'API is healthy and running', 200

@app.route('/recibosManager', methods=['GET'])
def obtener_datos_generales():
    """
    Endpoint to obtain all the data from the receipts of a particular day to be monitored by the manager.
    ---
    tags:
      - Manager
    responses:
      200:
        description: The data from all receipts of a particular day
      500:
        description: Internal Server Error
        content:
          application/json:
            example:
              {
                "error": "An error occurred while processing the request: <error_message>"
              }
    """
    return mssql.obtener_datos_generales()

@app.route('/recibosRecolector', methods=['POST'])
def obtener_recibos_recolector():
    """
    Endpoint to obtain the data of all the receipts assigned to a particular delivery guy from the day called.
    ---
    tags:
      - Recolector
    parameters:
      - name: IdRecolector
        in: formData
        type: integer
        required: true
        description: ID of the Delivery Guy
    responses:
      200:
        description: The data from all receipts of a particular delivery man and a particular day.
      500:
        description: Internal Server Error
        content:
          application/json:
            example:
              {
                "error": "An error occurred while processing the request: <error_message>"
              }
    """
    data = request.get_json()
    IdRecolector = data['IdRecolector']
    return mssql.obtener_recibos_recolector(IdRecolector)

@app.route('/actualizarRecibo', methods=['PUT'])
def actualizar_recibo():
    """
    Endpoint to update a receipt.
    ---
    tags:
      - Recolector
    parameters:
      - name: ID_BITACORA
        in: formData
        type: integer
        required: true
        description: ID of the receipt
      - name: ESTATUS_PAGO
        in: formData
        type: integer
        required: true
        description: New status of the payment
      - name: COMENTARIOS
        in: formData
        type: string
        required: true
        description: Comments for the receipt
    responses:
      200:
        description: Succesful update message
        content: Recibo actualizado exitosamente
      500:
        description: Internal Server Error
        content:
          application/json:
            example:
              {
                "error": "An error occurred while processing the request: <error_message>"
              }
    """
    data = request.get_json()
    idBitacora = data['ID_BITACORA']
    estatusPago = data['ESTATUS_PAGO']
    comentarios = data['COMENTARIOS']
    return mssql.actualizar_recibo(idBitacora, estatusPago, comentarios)

@app.route('/loginRecolector', methods=['POST'])
def login_recolector():
    """
    Endpoint to validate the credentials of a delivery man.
    ---
    tags:
      - Recolector
    parameters:
      - name: USUARIO
        in: formData
        type: string
        required: true
        description: Username of the delivery man
      - name: PASS
        in: formData
        type: string
        required: true
        description: Password of the delivery man
    responses:
      200:
        description: Returns id of the delivery man if the authentication is correct, 0 if it's not.
        content:
          application/json:
            examples:
              authentication_success:
                summary: Authentication Sucessful
                value:
                  {
                    "id": 3
                  }
              authentication_fail:
                summary: Authentication Sucessful
                value:
                  {
                    "id": 0
                  }
      500:
        description: Internal Server Error
        content:
          application/json:
            example:
              {
                "error": "An error occurred while processing the request: <error_message>"
              }
    """
    data = request.get_json()
    username = data['USUARIO']
    password = data['PASS']
    return mssql.login_recolector(username, password)

@app.route('/loginManager', methods=['POST'])
def login_manager():
    """
    Endpoint to validate the credentials of a manager.
    ---
    tags:
      - Manager
    parameters:
      - name: USUARIO
        in: formData
        type: string
        required: true
        description: Username of the manager
      - name: PASS
        in: formData
        type: string
        required: true
        description: Password of the manager
    responses:
      200:
        description: Returns id of the delivery man if the authentication is correct, returns 0 otherwise.
        content:
          application/json:
            examples:
              authentication_success:
                summary: Authentication Successful
                value: 
                  {
                    "message": "Authentication Successful"
                  }
              authentication_fail:
                summary: Authentication Failed
                value: 
                  {
                    "message": "Authentication failed"
                  }
      500:
        description: Internal Server Error
        content:
          application/json:
            example:
              {
                "error": "An error occurred while processing the request: <error_message>"
              }
    """
    data = request.get_json()
    username = data['USUARIO']
    password = data['PASS']
    return mssql.login_manager(username, password)

if __name__ == '__main__':
    app.run(debug=True, port=8085, host='0.0.0.0')
