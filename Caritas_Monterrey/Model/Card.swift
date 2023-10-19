//
//  Card.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import Foundation

struct Card: Identifiable {
    var id: Int
    var importe: Int
    var direccion: String
    var referencia_domicilio: String
    var tel_casa: Int
    var tel_movil: Int
    var status_pago: Int
}
