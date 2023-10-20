//
//  Dashboard.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    Image("top")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 435, height: 191)
                    .clipped()
                        
                    VStack {
                        HStack {
                            Text("Bienvenido de Vuelta")
                                .font(.system(size: 26).bold())
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.trailing, 60)
                            
                            Image("filter")
                                .frame(width: 30, height: 18.75)
                        }
                        Text("Estas son tus recolecciones de hoy")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.trailing, 30)
                    }
                }
                VStack {
                    List(listaCards) { cardItem in
                        NavigationLink {
                            DetallesReciboView(card: cardItem)
                        }
                    label: {
                        Cards(card: cardItem)
                    }
                    }
                    .listStyle(.plain)
                    .padding(.top, 20)
                }
                .padding(.top, -50)
                Spacer()
                    
            }
            .ignoresSafeArea()
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
