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
    var IMPORTE: Float
    var REFERENCIA_DOMICILIO: String
    var TEL_CASA: String
    var TEL_MOVIL: String
    var id: Int
    
}

struct Recolector {
    let id: Int
}

func loginRecolector(username: String, password: String, completion: @escaping (Int) -> Void) {
    
    let apiUrl = URL(string: "http://10.14.255.85:8085/loginRecolector")!
    
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
                completion(0)
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("API RESPONSE: \(json)")

                        let userId = (json["id"] as? Int) ?? 0
                        print(userId)
                        completion(userId)
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

func callApi() -> Array<Card>{
    var cards: Array<Card> = []
    
    print("Entrando a API")
    
    guard let url = URL(string: "http://10.14.255.85:8082/datosDiarios") else {
        return cards
    }
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: url){ data, response, error in
        let jsonDecoder = JSONDecoder()
        if (data != nil) {
            do {
                let cardList = try jsonDecoder.decode([Card].self, from: data!)
                
                print("Lista \(cardList) ")
                
                for cardItem in cardList {
                    print("Id: \(cardItem.id) - Direccion \(cardItem.DIRECCION)")
                }
                cards = cardList
            } catch {
                print(error)
            }
            if let datosAPI = String(data: data!, encoding: .utf8) {
                print(datosAPI)
            }
        }else{
            
            print("No data")
        }
        group.leave()
    }
    task.resume()
    group.wait()
    
    print("******************************************")
    print("Lista2: \(cards) ")
    
    return cards
}

var listaCards = callApi()
