//
//  DetallesReciboView.swift
//  caritas
//
//  Created by Mafer Argueta on 18/10/23.
//

import SwiftUI

struct DetallesReciboView: View {
    @State var comentario: String = ""
    @State private var showAlert = false
    @State private var pagado = 0
    @State private var sinComentario = false
    var card: Card
    var body: some View {
        NavigationView{
            VStack {
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 430, height: 110)
                        .background(Color(red: 0, green: 0.23, blue: 0.36))
                    
                    VStack{
                        Text("Detalles del recibo")
                            .font(
                                Font.system(size: 24)
                                    .weight(.bold)
                                    .bold()
                                
                            )
                            .foregroundColor(.white)
                            .frame(alignment: .bottom)
                            .padding(.top, 40)
                    }
                    
                    
                }
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("Recibo")
                            .font(
                                Font.system(size: 22)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 2)
                            
                        
                        Text("\(card.id)")
                            .font(
                                Font.system(size: 25)
                                    .weight(.bold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            
                        Text("Monto")
                            .font(
                                Font.system( size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .bold()
                        
                            
                        
                        Text("\(card.importe)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                           
                        Text("Domicilio")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                            
                        
                        Text("\(card.direccion)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            
                        Text("Referencia de domicilio")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.5)
                        
                        Text("\(card.referencia_domicilio)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            
                        
                        
                    }
                    
                    VStack(alignment: .leading){
                         
                        
                        Text("Teléfono casa")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                            
                        
                        Text("\(card.tel_casa)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            
                        
                        
                    }
                    VStack(alignment: .leading){
                        Text("Teléfono celular")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                            
                        Text("\(card.tel_movil)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            
                        
                    }
                    
                    VStack(alignment: .leading){
                        Text("Comentario Adicional")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                        
                            
                        
                        TextField("Comentatio", text: $comentario)
                            .disableAutocorrection(true)
                            .frame(width: 297,height: 80,alignment: .topLeading)
                            .border(.black)
                        
                        if sinComentario && pagado == 0 {
                                        Text("Ingresa un comentario")
                                            .foregroundColor(.red)
                                    }
                        
                        Text("Estatus")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            
                        
                        Picker("Picker", selection: $pagado) {
                                    Text("Pagado").tag(1)
                                    Text("No Pagado").tag(0)
                                }
                                .pickerStyle(.segmented)
                                
                      
                    }
                    .onAppear(){
                        pagado = card.status_pago
                    }
                    
                    VStack(alignment: .center){
                        Button("ENVIAR") {
                            if pagado == 1 {
                                showAlert = true
                            }
                            if validateInput(comentario) && pagado == 0{
                                sinComentario = false
                                showAlert = true
                            }else{
                                sinComentario = true
                            }
                            
                            
                            
                        }.frame(width: 308, height: 54)
                            .background(Color(red: 0, green: 59/255, blue: 92/255))
                            .cornerRadius(50)
                            .font(.system(size: 24).bold())
                            .foregroundColor(.white)
                            .padding(.top, 30)
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Enviar recibo"),
                                    message: Text("¿Seguro que desea enviar el recibo?"),
                                    primaryButton: .default(
                                        Text("Enviar")
                                    ),
                                    secondaryButton: .destructive(
                                        Text("Cancelar")
                                    )
                                )
                            }
                        
                    }
                    
                }
                Spacer()
            }
            
            .ignoresSafeArea()
            .padding(.horizontal, 35)
            
        }
        
    }
}

func validateInput(_ input: String) -> Bool {
        return !input.isEmpty
    }

struct DetallesReciboView_Previews: PreviewProvider {
    static var previews: some View {
        let card1: Card = listaCards[0]
        DetallesReciboView(card: card1)
    }
}
