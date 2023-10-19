//
//  emptyDashView.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI

struct emptyDashView: View {
    @State private var selectedFilter = 0
    @State private var isFilterExpanded = false
    
    var body: some View {
        VStack{
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 435, height: 191)
                  .background(
                    Image("back")
                        .resizable(resizingMode: .stretch)
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 435, height: 191)
                      .clipped()
                  )
                
                VStack {
                    HStack {
                        Text("Bienvenido de Vuelta")
                            .font(.title
                        )
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing, 65)
                        .padding(.top, 30)
                    }
                    
                    Text("Estas son tus recolecciones de hoy")
                        .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.trailing, 18)
                    .padding(.bottom, -10)
                    
                    Picker(selection: $selectedFilter, label: Text("Ordenar por")) {
                        Text("No cobrados").tag(0)
                        Text("Cobrados").tag(1)
                    }
                    .padding(.trailing, 215)

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
        emptyDashView()
    }
}
