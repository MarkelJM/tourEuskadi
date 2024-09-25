//
//  OnboardingOneView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct OnboardingOneView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Fondo con imagen
            Fondo()

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Button(action: {
                                appState.currentView = .login
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.mateGold) // Usamos mateGold
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(.top, 50)
                            }
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Bienvenido a nuestra historia")
                                .font(.title)
                                .foregroundColor(.mateGold) // Usamos mateGold
                                .padding(.top, 40)
                            
                            Text("""
                                Demuestra que no solo conoces los lugares más emblemáticos de Castilla y León sino que también su historia.
                                
                                ¡Vamos a la Conquista de CyL!
                                """)
                                .font(.body)
                                .foregroundColor(.mateWhite) // Usamos mateWhite
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                Button(action: {
                    appState.currentView = .onboardingTwo
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateBlueMedium) // Usamos mateBlueMedium en lugar de mateRed
                        .foregroundColor(.mateWhite) // Usamos mateWhite
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
                Spacer()
            }
            .padding()
            .background(Color.black.opacity(0.6)) // Fondo con opacidad
            .cornerRadius(20)
            .padding()
        }
    }
}
