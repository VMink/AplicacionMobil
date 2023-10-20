//
//  EmptyDashView.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 20/10/23.
//

import SwiftUI

struct EmptyDashView: View {
    @State private var selectedFilter = 0
    @State private var isFilterExpanded = false
    
    var body: some View {
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
            
            Spacer()
            
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 318, height: 158)
            .background(
                Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 318, height: 158)
                .clipped()
            )
            .padding(.bottom, 30)
            
            Text("No tienes colectas asignadas el día de hoy")
                .font(.title)
                .bold()
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
            .padding(.bottom, 240)
            .padding()
        }
        .ignoresSafeArea()
    }
}

struct emptyDashView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDashView()
    }
}
