//
//  Dashboard.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI

struct Dashboard: View {
    @State var listaPrueba :Array<Card> = []
    @State private var isEmpty: Bool = false
    @State private var selectedFilter = 0
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    Image("top")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 435, height: 191)
                    .clipped()
                        
                    VStack(alignment: .leading) {
                        Text("Bienvenido de Vuelta")
                            .font(.system(size: 26).bold())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 60)
                        Text("Estas son tus recolecciones de hoy")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.trailing, 30)
                        Picker(selection: $selectedFilter, label: Text("Ordenar por").font(.title)) {
                                                Text("No cobrados").tag(0)
                                                Text("Cobrados").tag(1)
                        }.colorMultiply(.black).colorInvert()
                            .padding(.top, -19)
                            .padding(.leading, -11)
                    }
                }
                VStack {
                    List(listaPrueba) { cardItem in
                        NavigationLink {
                            DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                        }
                    label: {
                        Cards(card: cardItem)
                    }
                    }
                    .listStyle(.plain)
                    .padding(.top, 20)
                }
                .padding(.top, -50)
                .onAppear(){
                    dashboardRecolector { cards in
                            if cards.isEmpty {
                                print("No cards received")
                                isEmpty = true
                            } else {
                                listaPrueba = cards
                            }
                        }
                    print("Dashboard")
                    print(listaPrueba)
                }
                
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
