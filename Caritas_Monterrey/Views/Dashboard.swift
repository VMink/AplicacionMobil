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
    @State private var mensajeError = false
    
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
                        HStack{
                            VStack{
                                Text("Bienvenido de Vuelta")
                                    .font(.system(size: 29).bold())
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 60)
                                    .padding(.top, 30)
                                
                                Text("Estas son tus recolecciones de hoy")
                                    .font(.system(size: 19))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .padding(.trailing, 30)
                            }
                            
                            
                            NavigationLink(destination: ContentView()) {
                                
                                            Image("door-exit")
                                                .resizable(resizingMode: .stretch)
                                                .frame(width: 30, height: 30)
                                                .colorInvert()
                                                .padding(.top, 15)
                                                .padding(.leading, -28)
                                        }
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                        .navigationBarHidden(true)
                            
                        }
                        
                        ZStack{
                                                Rectangle()
                                                    .foregroundColor(Color.white.opacity(0.5))
                                                    .frame(width: 173, height: 40)
                                                    .cornerRadius(10)
                                                HStack{
                                                   
                                                    Picker(selection: $selectedFilter, label: Text("Ordenar por").font(.title).bold()){
                                                                            Text("No Pagados").tag(2).font(.system(size: 12))
                                                                            Text("Pagados").tag(1).font(.system(size: 12))
                                                                            Text(" Pendientes").tag(3).font(.system(size: 12))
                                                                            Text("Todos").tag(0).font(.system(size: 12))
                                                }.colorMultiply(.black).colorInvert()
                                                       
                                                        
                                                    //.colorMultiply(.black)
                                            }
                                            }.scaleEffect(0.8)
                                                .offset(x: -75, y: -5)
                                                //.padding(.top, -19)
                                                .padding(.leading, -11)
                                                //.pickerStyle(.segmented)
                                                .frame(width: 300)
                    }
                }
                VStack {
                    List(listaPrueba) { cardItem in
                        if (cardItem.FECHA_PAGO == "" && cardItem.ESTATUS_PAGO != 1) {
                            //morado, pendientes
                            if(selectedFilter == 0 || selectedFilter == 3){
                                NavigationLink {
                                    DetallesReciboView(mensajeError: $mensajeError, card: cardItem).navigationBarBackButtonHidden()
                                } label: {
                                    Cards(card: cardItem)
                                }
                            }
                            
                            
                        } else if (cardItem.ESTATUS_PAGO == 1) {
                            //verde, pagados
                            if(selectedFilter == 0 || selectedFilter == 1){
                                Cards(card: cardItem)
                            }
                            
                        } else {
                            if(selectedFilter == 0 || selectedFilter == 2){
                                Cards(card: cardItem)
                            }
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
            .alert(isPresented: $mensajeError) {
                Alert(title: Text("Ha ocurrido un error"), message: Text("Revisa tu conexión a internet"), dismissButton: .default(Text("Aceptar")))
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
