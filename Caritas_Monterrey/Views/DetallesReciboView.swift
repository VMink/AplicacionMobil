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
    @Binding var mensajeError: Bool
    @State private var regresar = false
    @Environment(\.dismiss) private var dismiss
    var card: Card
    var body: some View {
        NavigationView{
            VStack {
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 430, height: 110)
                        .background(Color(red: 0, green: 0.23, blue: 0.36))
                    VStack (alignment: .leading){
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left.circle.fill")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                    .padding(.leading, 30)
                                    .padding(.top, 45)
                            }
                            Spacer()
                        }
                    }
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
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Recibo")
                                    .font(
                                        Font.system(size: 22)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                                var idString = String(card.ID_RECIBO)
                                Text("\(idString)")
                                    .font(
                                        Font.system(size: 25)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Monto")
                                    .font(
                                        Font.system( size: 22)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                                    .bold()
                                Text("$\(card.IMPORTE, specifier: "%.2f")")
                                    .font(
                                        Font.system(size: 25)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            }
                        }
                        Text("Nombre")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            
                        
                        Text("\(card.NOMBRE_DONANTE)")
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
                            
                        
                        Text("\(card.DIRECCION)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .padding(.horizontal, 0.5)
                            
                        Text("Referencia de domicilio")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.5)
                        
                        Text("\(card.REFERENCIA_DOMICILIO)")
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
                            
                        
                        Link("\(card.TEL_CASA)", destination: URL(string: "tel://\(card.TEL_CASA)")!)
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
                            
                        Link("\(card.TEL_MOVIL)", destination: URL(string: "tel://\(card.TEL_MOVIL)")!)
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
                        
                        TextField("Comentario", text: $comentario)
                            .disableAutocorrection(true)
                            .frame(height: 48)
                            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: 1.0)
                            )
                        
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
                            .padding(.top, 0.7)                        
                        
                        Picker("Picker", selection: $pagado) {
                            Text("Pagado").tag(1)
                            Text("No Pagado").tag(0)
                        }
                        .padding(.horizontal, 40)
                        .frame(width: 250, height: 60)
                        .pickerStyle(SegmentedPickerStyle())
                        .scaledToFit()
                        .scaleEffect(CGSize(width: 1.5, height: 1.5))
                    }
                    .onAppear(){
                        pagado = card.ESTATUS_PAGO
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
                            
                            
                            
                        }.frame(maxWidth: .infinity,minHeight: 60)
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
                                        Text("Enviar"),
                                        action: {
                                            actualizarRecibo(id_bitacora: card.id, estatus_pago: pagado, comentario: comentario) {
                                                conectado in
                                                if (conectado == 0) {
                                                    mensajeError = true
                                                } else {
                                                    dismiss()
                                                }
                                            }
                                            dismiss()
                                        }
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
        
        .onTapGesture {
                    hideKeyboard()
            }
    }
}

func validateInput(_ input: String) -> Bool {
        return !input.isEmpty
    }

struct DetallesReciboView_Previews: PreviewProvider {
    static var previews: some View {
        let card1: Card = listaCards[0]
        @State var messageError = false
        DetallesReciboView(mensajeError: $messageError, card: card1)
    }
}
