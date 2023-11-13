import requests

BASE_URL = "http://10.14.255.85:8085"

GREEN = '\033[32m'
RED = '\033[91m'
RESET = '\033[0m'

def print_success(message):
    print(f"{message} {GREEN}(CORRECT){RESET}")

def print_failure(message):
    print(f"{message} {RED}(FAILED){RESET}")

def test_recibos_manager():
    try:
        response = requests.get(f"{BASE_URL}/recibosManager")
        assert response.status_code == 200

        returned_json = response.json()
        assert len(returned_json) == 14

        expected_keys = [
            "COMENTARIOS", "DIRECCION", "ESTATUS_PAGO", "FECHA_COBRO", "FECHA_PAGO",
            "ID_DONANTE", "ID_RECIBO", "ID_RECOLECTOR", "IMPORTE", "NOMBRE_DONANTE",
            "REFERENCIA_DOMICILIO", "TEL_CASA", "TEL_MOVIL", "USUARIO_RECOLECTOR", "id"
        ]
        for instance in returned_json:
            assert all(key in instance for key in expected_keys)

        print_success("GET /recibosManager Test Passed")

    except AssertionError as e:
        print_failure(f"GET /recibosManager Test Failed: {e}")

def test_recibos_recolector():
    try:
        payload = {"IdRecolector": 1}
        response = requests.post(f"{BASE_URL}/recibosRecolector", json=payload)
        assert response.status_code == 200

        returned_json = response.json()
        assert len(returned_json) == 4

        expected_keys = [
            "DIRECCION", "ESTATUS_PAGO", "FECHA_PAGO", "ID_DONANTE", "ID_RECIBO", "IMPORTE",
            "NOMBRE_DONANTE", "REFERENCIA_DOMICILIO", "TEL_CASA", "TEL_MOVIL", "id"
        ]

        for instance in returned_json:
            assert all(key in instance for key in expected_keys)

        print_success("POST /recibosRecolector Test Passed")

    except AssertionError as e:
        print_failure(f"POST /recibosRecolector Test Failed: {e}")

def test_actualizar_recibo():
    try:
        response_get_before_update = requests.get(f"{BASE_URL}/recibosManager")
        assert response_get_before_update.status_code == 200
        current_id_bitacora = response_get_before_update.json()[0]["id"]

        payload_update = {"ID_BITACORA": current_id_bitacora, "ESTATUS_PAGO": 3, "COMENTARIOS": "ACTUALIZADO"}
        response_update = requests.put(f"{BASE_URL}/actualizarRecibo", json=payload_update)
        assert response_update.status_code == 200

        print_success("PUT /actualizarRecibo Test Passed for Successful PUT request")

        response_get_after_update = requests.get(f"{BASE_URL}/recibosManager")
        assert response_get_after_update.status_code == 200

        first_instance_after_update = response_get_after_update.json()[0]
        assert "COMENTARIOS" in first_instance_after_update
        assert first_instance_after_update["COMENTARIOS"] == "ACTUALIZADO"
        assert "ESTATUS_PAGO" in first_instance_after_update
        assert first_instance_after_update["ESTATUS_PAGO"] == 3

        print_success("PUT /actualizarRecibo Test Passed for Successful Database Update")

        payload_revert_update = {"ID_BITACORA": current_id_bitacora, "ESTATUS_PAGO": 0, "COMENTARIOS": ""}
        response_revert_update = requests.put(f"{BASE_URL}/actualizarRecibo", json=payload_revert_update)
        assert response_revert_update.status_code == 200

        print_success("PUT /actualizarRecibo Test Passed for Revert Update")

    except AssertionError as e:
        print_failure(f"Test Failed: {e}")

def test_login_recolector():
    try:
        payload_correct = {"USUARIO": "claraRecolector", "PASS": "clara123"}
        response_correct = requests.post(f"{BASE_URL}/loginRecolector", json=payload_correct)
        assert response_correct.status_code == 200

        returned_json_correct = response_correct.json()
        assert "id" in returned_json_correct
        assert returned_json_correct["id"] != 0

        print_success("POST /loginRecolector Test Passed for Correct Credentials")

        payload_incorrect_password = {"USUARIO": "claraRecolector", "PASS": "INCORRECTPASSWORD"}
        response_incorrect_password = requests.post(f"{BASE_URL}/loginRecolector", json=payload_incorrect_password)
        assert response_incorrect_password.status_code == 200

        returned_json_incorrect_password = response_incorrect_password.json()
        assert "id" in returned_json_incorrect_password
        assert returned_json_incorrect_password["id"] == 0

        print_success("POST /loginRecolector Test Passed for Incorrect Password")

    except AssertionError as e:
        print_failure(f"POST /loginRecolector Test Failed: {e}")

def test_login_manager():
    try:
        payload_correct = {"USUARIO": "Gustavoadmin", "PASS": "12345"}
        response_correct = requests.post(f"{BASE_URL}/loginManager", json=payload_correct)
        assert response_correct.status_code == 200

        returned_json_correct = response_correct.json()
        assert "message" in returned_json_correct
        assert returned_json_correct["message"] == "Authentication successful"

        print_success("POST /loginManager Test Passed for Correct Credentials")

        payload_incorrect_password = {"USUARIO": "Gustavoadmin", "PASS": "INCORRECTPASSWORD"}
        response_incorrect_password = requests.post(f"{BASE_URL}/loginManager", json=payload_incorrect_password)
        assert response_incorrect_password.status_code == 200

        returned_json_incorrect_password = response_incorrect_password.json()
        assert "message" in returned_json_incorrect_password
        assert returned_json_incorrect_password["message"] == "Authentication failed"

        print_success("POST /loginManager Test Passed for Incorrect Password")

    except AssertionError as e:
        print_failure(f"POST /loginManager Test Failed: {e}")

if __name__ == "__main__":
    test_recibos_manager()
    test_recibos_recolector()
    test_actualizar_recibo()
    test_login_recolector()
    test_login_manager()
