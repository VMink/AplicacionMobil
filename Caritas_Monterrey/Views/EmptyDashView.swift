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
    @Environment(\.dismiss) private var dismiss
    
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
                    HStack{
                        VStack{
                            Text("Bienvenido de Vuelta")
                                .font(.system(size: 29).bold())
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.trailing, 40)
                                .padding(.top, 30)
                            
                            Text("Estas son tus recolecciones de hoy")
                                .font(.system(size: 19))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.trailing, 10)
                        }
                        
                        
                        .padding(.trailing, 15)
                        Button {
                            dismiss()
                        } label: {
                            Image("door-exit")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .scaledToFit()
                                .colorInvert()
                                .padding(.top, 13)
                        }
                        
                    }
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
