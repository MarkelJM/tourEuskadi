//
//  CoinView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI
import ARKit
import RealityKit

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común
            
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    Text("Cargando datos...")
                        .font(.title2)
                        .foregroundColor(.mateWhite) // Color mateWhite
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if let coin = viewModel.coins.first {
                    ARViewContainer(prizeImageName: coin.prize, viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No hay datos disponibles")
                        .foregroundColor(.mateWhite) // Color mateWhite
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .mapContainer
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .padding()
                            .background(Color.mateGold) // Usamos mateGold
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.top, 100)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showResultModal) {
            ResultCoinView(viewModel: viewModel)
                .environmentObject(appState)
        }
    }
}

struct ResultCoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común
            
            VStack {
                Text(viewModel.resultMessage)
                    .font(.title)
                    .foregroundColor(.mateGold) // Usamos mateGold
                    .padding()

                Button("Continuar") {
                    // Navegar de vuelta al container
                    viewModel.showResultModal = false
                    appState.currentView = .mapContainer
                }
                .padding()
                .background(Color.mateBlueMedium) // Usamos mateBlueMedium
                .foregroundColor(.mateWhite) // Usamos mateWhite
                .cornerRadius(10)
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            soundManager.playWinnerSound() // Reproducir sonido cuando aparezca el resultado
        }
    }
}
