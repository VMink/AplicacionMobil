//
//  ContentView.swift
//  Caritas_Monterrey
//
//  Created by Equipo 2 on 17/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var mensajeError: String = ""
    @State private var isNavigating = false
    @State private var navigateNoOrders = false
    @State var Funciona3 = [Card]()
    var body: some View {
        NavigationStack() {
            VStack {
                HStack{Spacer()}
                
                Image("caritas")
                    .resizable()
                    .frame(width: 311, height: 153)
                
                Text("Control de Donaciones")
                    .font(.system(size: 27).bold())
                    .foregroundColor(.white)
                    .padding([.top, .bottom], 21)
                
                VStack{
                    Text("Inicia sesión para\ncontinuar")
                        .foregroundColor(Color(red: 45/255, green: 45/255, blue: 45/255))
                        .font(.system(size: 24).bold())
                        .multilineTextAlignment(.center)
                        .padding(.top, 34)
                    
                    TextField("", text: $username, prompt: Text("Usuario").foregroundColor(Color(red: 0, green: 59/255, blue: 92/255)))
                        .padding([.leading, .trailing], 42)
                        .padding(.top, 40)
                        .foregroundColor(Color(red: 0, green: 59/255, blue: 92/255))
                        .font(.system(size: 20).bold())
                        .accentColor(Color(red: 0, green: 59/255, blue: 92/255))
                    
                    Rectangle()
                        .fill(Color(red: 0, green: 59/255, blue: 92/255))
                        .frame(height: 2)
                        .padding(.horizontal, 28)
                    
                    SecureField("", text: $password, prompt: Text("Contraseña").foregroundColor(Color(red: 0, green: 59/255, blue: 92/255)))
                        .padding([.leading, .trailing], 42)
                        .padding(.top, 40)
                        .foregroundColor(Color(red: 0, green: 59/255, blue: 92/255))
                        .font(.system(size: 20).bold())
                    
                    Rectangle()
                        .fill(Color(red: 0, green: 59/255, blue: 92/255))
                        .frame(height: 2)
                        .padding(.horizontal, 28)
                    
                    Text(mensajeError)
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                    
                    Button("Iniciar Sesión", action: {
                        if validate() {
                            isNavigating = true
                        }
                        else if sinRecibos() {
                            navigateNoOrders = true
                        }
                        else {
                            mensajeError = "Credenciales Incorrectas"
                        }
                    })
                        .frame(width: 308, height: 54)
                        .background(Color(red: 0, green: 59/255, blue: 92/255))
                        .cornerRadius(50)
                        .font(.system(size: 24).bold())
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .navigationDestination(isPresented: $isNavigating) {
                            Dashboard().navigationBarBackButtonHidden()
                        }
                        .navigationDestination(isPresented: $navigateNoOrders) {
                            EmptyDashView().navigationBarBackButtonHidden()
                        }
                    
                    Spacer()
                }
                .frame(width: 348, height: 413)
                .background()
                .background(Color.black
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 1, y: 1))
                .cornerRadius(5)
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                stops: [
                Gradient.Stop(color: Color(red: 0, green: 0.61, blue: 0.65), location: 0.00),
                Gradient.Stop(color: Color(red: 0.74, green: 0.98, blue: 1), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0.3),
                endPoint: UnitPoint(x: 0.99, y: 1)
                )
                )}
    }
    
    private func validate() -> Bool {
        if (username == "Gustavo" && password == "12345"){
           return true
        }else{
            return false
        }
    }
    
    private func sinRecibos() -> Bool {
        if (username == "Abee" && password == "12345") {
            return true
        } else {
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
