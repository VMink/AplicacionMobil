//
//  ContentView.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 17/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var Funciona: String = ""
    var body: some View {
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
                TextField("Usuario", text: $Funciona)
                Spacer()
            }
            .frame(width: 348, height: 413)
            .background()
            .background(Color.black
                .shadow(color: .black, radius: 3, x: 1, y: 1)
                .blur(radius: 9, opaque: false))
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0/255, green: 156/255, blue: 166/255), Color(red: 188/255, green: 251/255, blue: 255/255)]), startPoint: UnitPoint(x: 0.464, y: 0.5), endPoint: UnitPoint(x: 1, y: 1))
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
