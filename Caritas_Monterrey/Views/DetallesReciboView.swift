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
                    }
                    
                    
                }
                VStack{
                    VStack{
                        Text("Recibo")
                            .font(
                                Font.system(size: 22)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 297, height: 28, alignment: .topLeading)
                        
                        Text("436510")
                            .font(
                                Font.system(size: 25)
                                    .weight(.bold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .frame(width: 297, height: 28, alignment: .topLeading)
                        
                        Text("Referencia de domicilio")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 297,  alignment: .topLeading)
                        
                        Text("No")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .frame(width: 297, height: 32, alignment: .topLeading)
                        
                        Text("Comentario de Recibo")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 297, height: 32, alignment: .topLeading)
                        
                        Text("P. 4 DE SEPTIEMBRE DE 10 A 1 P.M. CONFIRMO SRA. ROSALINDA.")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .frame(width: 297,alignment: .topLeading)
                    }
                    
                    VStack{
                        Text("Monto")
                            .font(
                                Font.system( size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 297,height: 32,alignment: .topLeading)
                        
                        Text("$1,000.00")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .frame(width: 297,height: 32,alignment: .topLeading)
                        
                        Text("Teléfono casa")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 297,alignment: .topLeading)
                        
                        Text("8183393191")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .frame(width: 297,height: 32,alignment: .topLeading)
                        
                        
                    }
                    VStack{
                        Text("Teléfono celular")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 297,alignment: .topLeading)
                        Text("8183393191")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .frame(width: 297,height: 32,alignment: .topLeading)
                        
                    }
                    
                    VStack{
                        Text("Comentario Adicional")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 297,alignment: .topLeading)
                        
                        TextField("Comentatio", text: $comentario)
                            .disableAutocorrection(true)
                            .frame(width: 297,height: 40,alignment: .topLeading)
                            .textFieldStyle(.roundedBorder)
                        
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
                            .frame(width: 297,alignment: .topLeading)
                        
                        Picker("Picker", selection: $pagado) {
                                    Text("Pagado").tag(1)
                                    Text("No Pagado").tag(0)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 297, alignment: .topLeading)
                      
                    }
                    Text(" ")
                        .font(
                            Font.system(size: 5)
                                .weight(.bold)
                        )
                        .foregroundColor(.black)
                        .frame(width: 297,alignment: .topLeading)
                    
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
                        
                        
                        
                    }.buttonStyle(.borderedProminent)
                        .tint(Color(red: 0, green: 0.23, blue: 0.36))
                        .controlSize(.regular)
                        .frame(maxWidth: .infinity)
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
                Spacer()
            }
            
            .frame(width: 430, height: 932)
            .background(.white)
            
        }
        
    }
}

func validateInput(_ input: String) -> Bool {
        return !input.isEmpty
    }

struct DetallesReciboView_Previews: PreviewProvider {
    static var previews: some View {
        DetallesReciboView()
    }
}
