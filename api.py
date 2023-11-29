from flask import Flask, request
from flasgger import Swagger
import functions
import os

app = Flask(__name__)
swagger = Swagger(app, template={
    "swagger": "2.0",
    "info": {
        "title": "API Caritas MTY",
        "description": "API for Caritas MTY mobile app",
        "version": "3.3.1",
    },
    "host": "https://10.14.255.85:8085",
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
    parameters:
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
    responses:
      200:
        description: It returns the data of all receipts of a particular day.
      500:
        description: Internal Server Error
        content:
          application/json:
            example:
              {
                "error": "An error occurred while processing the request: <error_message>"
              }
    """
    token = request.headers.get('Authorization')
    return functions.obtener_datos_generales(token)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
    token = request.headers.get('Authorization')
    data = request.get_json()
    IdRecolector = data['IdRecolector']
    return functions.obtener_recibos_recolector(IdRecolector, token)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
    token = request.headers.get('Authorization')
    data = request.get_json()
    idBitacora = data['ID_BITACORA']
    estatusPago = data['ESTATUS_PAGO']
    comentarios = data['COMENTARIOS']
    return functions.actualizar_recibo(idBitacora, estatusPago, comentarios, token)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
                    "id": 3, "token": "123"
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
    return functions.login_recolector(username, password)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
                    "message": "Authentication Successful", "token": "123"
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
    return functions.login_manager(username, password)

API_CERT = os.environ.get('APICERT')
API_KEY = os.environ.get('APIKEY')

if __name__ == '__main__':
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain(API_CERT, API_KEY)
    app.run(host='0.0.0.0', port=8085, ssl_context=context, debug=True)


from flask import Flask, request
from flasgger import Swagger
import functions

app = Flask(__name__)
swagger = Swagger(app, template={
    "swagger": "2.0",
    "info": {
        "title": "API Caritas MTY",
        "description": "API for Caritas MTY mobile app",
        "version": "3.3.1",
    },
    "host": "https://equip17.tc2007b.tec.mx:8443",
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
    parameters:
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
    responses:
      200:
        description: It returns the data of all receipts of a particular day.
      500:
        description: Internal Server Error
        content:
          application/json:
            example:
              {
                "error": "An error occurred while processing the request: <error_message>"
              }
    """
    token = request.headers.get('Authorization')
    return functions.obtener_datos_generales(token)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
    token = request.headers.get('Authorization')
    data = request.get_json()
    IdRecolector = data['IdRecolector']
    return functions.obtener_recibos_recolector(IdRecolector, token)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
    token = request.headers.get('Authorization')
    data = request.get_json()
    idBitacora = data['ID_BITACORA']
    estatusPago = data['ESTATUS_PAGO']
    comentarios = data['COMENTARIOS']
    return functions.actualizar_recibo(idBitacora, estatusPago, comentarios, token)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
                    "id": 3, "token": "123"
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
    return functions.login_recolector(username, password)

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
      - name: Authorization
        in: header
        type: string
        required: true
        description: JWT Authorization token to validate the request
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
                    "message": "Authentication Successful", "token": "123"
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
    return functions.login_manager(username, password)

API_CERT = os.environ.get('APICERT')
API_KEY = os.environ.get('APIKEY')

if __name__ == '__main__':
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain(API_CERT, API_KEY)
    app.run(host='0.0.0.0', port=8085, ssl_context=context, debug=True)
