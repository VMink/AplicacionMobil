//
//  API.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import Foundation

struct Card: Codable, Identifiable {
    var DIRECCION: String
    var ESTATUS_PAGO: Int
    var FECHA_PAGO: String
    var ID_DONANTE: Int
    var ID_RECIBO: String
    var IMPORTE: Float
    var NOMBRE_DONANTE: String
    var REFERENCIA_DOMICILIO: String
    var TEL_CASA: String
    var TEL_MOVIL: String
    var id: Int
   
}

struct Recolector {
    let id: Int
}

func loginRecolector(username: String, password: String, completion: @escaping (Int) -> Void) {
    
    let apiUrl = URL(string: "https://equipo17.tc2007b.tec.mx:8443/loginRecolector")!
    
    let parameters: [String: Any] = [
        "USUARIO": username,
        "PASS": password
    ]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                let userId = -1
                completion(-1)
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = (json["message"] as? String) ?? ""
                        if (message == "Authentication successful") {
                            if let token = json["token"] as? String {
                                UserDefaults.standard.setValue(token, forKey: "token")
                            }
                            completion(1)
                        } else if(message == "An invalid response was received from the upstream server"){
                            print(message)
                            completion(2)
                        }else{
                            completion(0)
                        }
                    } else {
                        print("Error: Unable to parse API response as JSON.")
                        completion(0) // or handle the error in a way that makes sense for your application
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(0)
                }
            }
        }
        task.resume()
    } catch {
        print("Error encoding JSON: \(error)")
        completion(0)
    }
}

func dashboardRecolector(completion: @escaping ([Card]) -> Void) {
    var cards: [Card] = []

    let apiUrl = URL(string: "https://equipo17.tc2007b.tec.mx:8443/recibosRecolector")!

    if let idRecolector = UserDefaults.standard.string(forKey: "userId") {
        let parameters: [String: Any] = [
            "IdRecolector": idRecolector
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)

            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"
            
            let token = UserDefaults.standard.string(forKey: "token")
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(cards)
                    return
                }

                let jsonDecoder = JSONDecoder()

                if let data = data {
                    do {
                        let cardList = try jsonDecoder.decode([Card].self, from: data)

                        print("Lista \(cardList) ")

                        for cardItem in cardList {
                            print("Id: \(cardItem.id) - Dirección \(cardItem.DIRECCION)")
                        }
                        cards = cardList
                        completion(cards)
                    } catch {
                        print("Error parsing JSON: \(error)")
                        completion(cards)
                    }
                }
            }
            task.resume()
        } catch {
            print("Error encoding JSON: \(error)")
            completion(cards)
        }
    }
}

func callApi() -> [Card] {
    var cards: [Card] = []
    
    print("Entering API")
    
    guard let url = URL(string: "https://equipo17.tc2007b.tec.mx:8443/recibosManager") else {
        return cards
    }
    
    let group = DispatchGroup()
    group.enter()
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let token = UserDefaults.standard.string(forKey: "token")
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        let jsonDecoder = JSONDecoder()
        if let data = data {
            do {
                let cardList = try jsonDecoder.decode([Card].self, from: data)
                
                print("List: \(cardList)")
                
                for cardItem in cardList {
                    print("Id: \(cardItem.id) - Address: \(cardItem.DIRECCION)")
                }
                cards = cardList
            } catch {
                print(error)
            }
            
            if let datosAPI = String(data: data, encoding: .utf8) {
                print(datosAPI)
            }
        } else {
            print("No data")
        }
        group.leave()
    }
    
    task.resume()
    group.wait()
    
    print("******************************************")
    print("List2: \(cards)")
    
    return cards
}

func actualizarRecibo(id_bitacora: Int, estatus_pago: Int, comentario: String, completion: @escaping (Int) -> Void) {
    guard let url = URL(string: "https://equipo17.tc2007b.tec.mx:8443/actualizarRecibo") else {
        print("Murió en la URL")
        return
    }
    
    struct UploadData: Codable {
        let ID_BITACORA: Int
        let ESTATUS_PAGO: Int
        let COMENTARIOS: String
    }
    
    let uploadDataModel = UploadData(ID_BITACORA: id_bitacora, ESTATUS_PAGO: estatus_pago, COMENTARIOS: comentario)
    
    guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
        print("Murió en el JSONData")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    let token = UserDefaults.standard.string(forKey: "token")
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling PUT")
            print(error!)
            let conectado = 0
            completion(0)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                return
            }
            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                print("Error: Cannot convert JSON object to Pretty JSON data")
                return
            }
            guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                print("Error: Could print JSON in String")
                return
            }
            
            print(prettyPrintedJson)
        } catch {
            print("Error: Trying to convert JSON data to string")
            return
        }
    }.resume()
}

var listaCards = callApi()
