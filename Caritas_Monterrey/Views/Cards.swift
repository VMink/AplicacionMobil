//
//  Cards.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI

struct Cards: View {
    @State private var squareBg = Color(red: 0.9764705882352941, green: 0.7843137254901961, blue: 0.13725490196078433)
    var card: Card
    var body: some View {
        HStack{
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 19, height: 151)
            .background(squareBg)
            .onAppear(perform: {
                changeBg()
            })
            VStack(alignment: .leading) {
                Text("Nombre")
                    .font(.system(size:25).bold())
                Text("\(card.NOMBRE_DONANTE)")
                    .font(.system(size: 20).bold())
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                Text("Recibo: \(card.ID_RECIBO)")
                    .font(.system(size:20).bold())
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Domicilio")
                    .font(.system(size:25).bold())
                Text("\(card.DIRECCION)")
                    .font(.system(size: 20).bold())
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                    .multilineTextAlignment(.trailing)
            }
            .padding(.trailing, 10)
        }
        .frame(width: 357, height: 151)
        .background(Color.white.shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4))
        
    }
    
    private func changeBg() {
        if card.ESTATUS_PAGO == 1 {
            squareBg = Color(red: 0.38823529411764707, green: 0.8313725490196079, blue: 0.11764705882352941)
        }
        if card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0 {
            squareBg = Color(red: 1.0, green: 0.2, blue: 0.2)
        }
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        let card1: Card = listaCards[0]
        Cards(card: card1)
    }
}
