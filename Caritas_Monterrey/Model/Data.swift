//
//  Data.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import Foundation

var listaCards = getCards()

func getCards() -> Array<Card> {
    var lista : Array<Card> = [
        Card(id: 1, importe: 500, direccion: "Hda. de Zotoluca #431, Col. Echegaray", referencia_domicilio: "Casa con reja roja", tel_casa: 154356346, tel_movil: 242534363, status_pago: 1),

        Card(id: 12, importe: 500, direccion: "Hda. de Zotoluca #431, Col. Echegaray", referencia_domicilio: "Casa con reja roja", tel_casa: 154356346, tel_movil: 242534363, status_pago: 1),

        Card(id: 123, importe: 500, direccion: "Hda. de Zotoluca #431, Col. Echegaray", referencia_domicilio: "Casa con reja roja", tel_casa: 154356346, tel_movil: 242534363, status_pago: 1),

        Card(id: 1234, importe: 500, direccion: "Hda. de Zotoluca #431, Col. Echegaray", referencia_domicilio: "Casa con reja roja", tel_casa: 154356346, tel_movil: 242534363, status_pago: 1),

        Card(id: 12345, importe: 500, direccion: "Hda. de Zotoluca #431, Col. Echegaray", referencia_domicilio: "Casa con reja roja", tel_casa: 154356346, tel_movil: 242534363, status_pago: 1),

    ]
    
    // Carga datos, ya sea de un API, de una BD, de un archivo, etc.
    
    return lista
}
