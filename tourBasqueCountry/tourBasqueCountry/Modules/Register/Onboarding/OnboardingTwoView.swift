//
//  OnboardingTwoView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct OnboardingTwoView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Fondo de pantalla
            Fondo()

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Button(action: {
                                appState.currentView = .onboardingOne
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
                        
                        Text("Continuación de la historia")
                            .font(.title)
                            .foregroundColor(.mateGold) // Usamos mateGold
                            .padding(.top, 40)
                        
                        Text("""
                            Elige el reto y conquista uno por uno cada territorio. Tras finalizar cada reto conseguirás una recompensa.
                            Al finalizar todos los retos habrás conseguido conquistar a través de tu conocimiento CyL.
                            """)
                            .font(.body)
                            .foregroundColor(.mateWhite) // Usamos mateWhite
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    appState.currentView = .registerEmail
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
