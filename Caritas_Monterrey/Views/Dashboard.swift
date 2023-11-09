//
//  Dashboard.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI

struct Dashboard: View {
    @State var listaPrueba :Array<Card> = []
    @State private var selectedFilter = 0
    @State private var filtro = "Todos"
    let filtros = ["No cobrados", "Cobrados", "Todos"]
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 435, height: 191)
                      .background(
                        Image("top")
                            .resizable(resizingMode: .stretch)
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 435, height: 191)
                          .clipped()
                      )
                    
                    VStack(alignment: .leading) {
                        Text("Bienvenido de Vuelta")
                            .font(.system(size: 30).bold())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 60)
                            .padding(.top, 30)
                        
                        Text("Estas son tus recolecciones de hoy")
                             .font(.system(size: 20))
                             .fontWeight(.semibold)
                             .foregroundColor(.white)
                             .padding(.trailing, 30)
                        
                       
                        Menu {
                            ForEach(filtros, id: \.self) { option in
                                Button(action: {
                                    filtro = option
                                }) {
                                    HStack {
                                        Text(option)
                                        if option == filtro {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.system(size: 20))
                                Text("Filtrar")
                                    .font(.system(size: 16).bold())
                                    .foregroundColor(.white)
                                    
                                
                            }
                            
                        }.padding(.top, -5)
                        
                    }
                    
                    
                }
                VStack {
                    List(listaPrueba) { cardItem in
                        if cardItem.ESTATUS_PAGO != 1 {
                            NavigationLink {
                                DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                            } label: {
                                Cards(card: cardItem)
                            }
                        } else {
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
