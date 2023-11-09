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
