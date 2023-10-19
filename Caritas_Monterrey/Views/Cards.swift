//
//  Cards.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI

struct Cards: View {
    var card: Card
    var body: some View {
        HStack{
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 19, height: 151)
            .background(Color(red: 1, green: 0.5, blue: 0.2))
            VStack(alignment: .leading) {
                Text("Recibo")
                    .font(.system(size:25).bold())
                Text("\(card.id)")
                    .font(.system(size: 25).bold())
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Direccion")
                    .font(.system(size:25).bold())
                Text("\(card.direccion)")
                    .font(.system(size: 20).bold())
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                    .multilineTextAlignment(.trailing)
            }
            .padding(.trailing, 10)
        }
        .frame(width: 357, height: 151)
        .background(Color.white.shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4))
        
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        let card1: Card = listaCards[0]
        Cards(card: card1)
    }
}
