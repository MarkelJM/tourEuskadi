//
//  DatesOrderView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct DatesOrderView: View {
    @StateObject var viewModel: DatesOrderViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            ZStack {
                Fondo() // Usamos el fondo común
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Button(action: {
                            appState.currentView = .mapContainer
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .padding()
                                .background(Color.mateGold)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.checkAnswer()
                        }) {
                            Text("Comprobar")
                                .padding()
                                .background(Color.mateBlueMedium) // Usamos mateBlueMedium en lugar de mateRed
                                .foregroundColor(.mateWhite)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando eventos...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let dateEvent = viewModel.dateEvent {
                        VStack(spacing: 20) {
                            Text(dateEvent.question)
                                .font(.title2)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            ForEach(viewModel.shuffledOptions, id: \.self) { option in
                                Button(action: {
                                    viewModel.selectEvent(option)
                                }) {
                                    HStack {
                                        Text(option)
                                            .font(.headline)
                                            .foregroundColor(.mateWhite)
                                            .padding()

                                        // Mostrar el número de orden junto a las opciones seleccionadas
                                        if let index = viewModel.selectedEvents.firstIndex(of: option) {
                                            Text("\(index + 1)")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(8)
                                                .background(Color.mateGold)
                                                .clipShape(Circle())
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedEvents.contains(option) ? Color.mateGold : Color.mateBlueMedium)
                                    .cornerRadius(10)
                                }
                            }

                            HStack {
                                Button(action: {
                                    viewModel.checkAnswer()
                                }) {
                                    Text("Comprobar")
                                        .padding()
                                        .background(Color.mateBlueMedium)
                                        .foregroundColor(.mateWhite)
                                        .cornerRadius(10)
                                }

                                Button(action: {
                                    viewModel.undoSelection()
                                }) {
                                    Text("Deshacer")
                                        .padding()
                                        .background(Color.mateBlueMedium)
                                        .foregroundColor(.mateWhite)
                                        .cornerRadius(10)
                                        .opacity(0.5)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultAlert) {
                    ResultDatesOrderView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.fetchDateEvent()
            }
        }
    }
}

struct ResultDatesOrderView: View {
    @ObservedObject var viewModel: DatesOrderViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Fondo() // Fondo común

            VStack {
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                ScrollView {
                    VStack {
                        if let informationDetail = viewModel.dateEvent?.informationDetail {
                            Text(informationDetail)
                                .font(.body)
                                .foregroundColor(.mateWhite)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                }
                .frame(maxHeight: 200)

                Button(action: {
                    viewModel.showResultAlert = false
                    appState.currentView = .mapContainer
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            soundManager.playWinnerSound()
        }
    }
}

#Preview {
    DatesOrderView(viewModel: DatesOrderViewModel(activityId: "mockId", appState: AppState()))
        .environmentObject(AppState())
}

