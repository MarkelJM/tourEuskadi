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

import SwiftUI

struct ResultDatesOrderView: View {
    @ObservedObject var viewModel: DatesOrderViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared

    @State private var showTranslationSheet = false

    var body: some View {
        ZStack {
            Fondo() // Fondo común

            VStack {
                // Mostrar el mensaje de alerta
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()
                
                // ScrollView para mostrar el contenido original (description)
                ScrollView {
                    if let dateEvent = viewModel.dateEvent {
                        Text(dateEvent.informationDetail)
                            .font(.title)
                            .padding()
                            .foregroundColor(.mateGold)
                    }
                }

                // Botón para mostrar la traducción en Euskera
                Button(action: {
                    viewModel.fetchTranslationForActivity(activityId: viewModel.activityId)  // Cargar la traducción directamente en Euskera
                    showTranslationSheet = true  // Mostrar el sheet de traducción
                }) {
                    Label("Mostrar traducción en Euskera", systemImage: "globe")
                        .padding()
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }

                // Botón para continuar
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
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .sheet(isPresented: $showTranslationSheet) {
            TranslationSheetDatesView(viewModel: viewModel) // Sheet personalizado para mostrar traducción
        }
        .onAppear {
            soundManager.playWinnerSound()
            viewModel.fetchAvailableLanguages() // Obtener los idiomas disponibles al aparecer la vista
        }
    }
}


struct TranslationSheetDatesView: View {
    @ObservedObject var viewModel: DatesOrderViewModel

    var body: some View {
        VStack {
            // Contenido dentro de un ScrollView para manejar traducciones largas
            ScrollView {
                VStack(alignment: .leading) {
                    // Mostrar la traducción si existe
                    if let translation = viewModel.translation {
                        Text(translation.text)
                            .font(.title)
                            .padding()
                            .foregroundColor(.mateGold)

                        if let url = translation.url, let urlLink = URL(string: url) {
                            Link("Más información", destination: urlLink)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    } else {
                        Text("No hay traducción disponible")
                            .font(.title)
                            .padding()
                            .foregroundColor(.mateGold)
                    }
                }
            }
            .padding()

            // Botón para cerrar el sheet
            Button(action: {
                viewModel.showResultAlert = false  // Cerrar el sheet
            }) {
                Text("Cerrar")
                    .padding()
                    .background(Color.mateBlueMedium)
                    .foregroundColor(.mateWhite)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
