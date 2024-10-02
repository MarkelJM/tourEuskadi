//
//  QuestionAnswerView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct QuestionAnswerView: View {
    @StateObject var viewModel: QuestionAnswerViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            ZStack {
                Fondo() // Fondo común
                
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
                                .background(Color.mateBlueMedium)
                                .foregroundColor(.mateWhite)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando pregunta...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let questionAnswer = viewModel.questionAnswer {
                        VStack(spacing: 20) {
                            Text(questionAnswer.question)
                                .font(.title2)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            ForEach(questionAnswer.options, id: \.self) { option in
                                Button(action: {
                                    viewModel.selectedOption = option
                                }) {
                                    Text(option)
                                        .font(.headline)
                                        .foregroundColor(.mateWhite)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(viewModel.selectedOption == option ? Color.mateGold : Color.mateBlueMedium)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultModal) {
                    ResultQuestionView(viewModel: viewModel)
                        .environmentObject(appState)
                }
            }
            .onAppear {
                viewModel.fetchQuestionAnswer()
            }
        }
    }
}

struct ResultQuestionView: View {
    @ObservedObject var viewModel: QuestionAnswerViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared
    
    @State private var showTranslationSheet = false

    var body: some View {
        ZStack {
            Fondo() // Fondo común

            VStack {
                ScrollView {
                    // Mostrar el contenido original en español (informationDetail)
                    if let questionAnswer = viewModel.questionAnswer {
                        Text(questionAnswer.informationDetail)  // Mostrar la información predeterminada
                            .font(.title)
                            .foregroundColor(.mateGold)
                            .padding()
                    }
                }
                
                // Botón para mostrar la traducción en Euskera
                Button(action: {
                    viewModel.fetchTranslationForActivity(activityId: viewModel.activityId)  // Cargar la traducción en Euskera
                    showTranslationSheet = true  // Mostrar el sheet para la traducción
                }) {
                    Label("Mostrar traducción en Euskera", systemImage: "globe")
                        .padding()
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
                
                // Botón para continuar
                Button(action: {
                    viewModel.showResultModal = false
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
            TranslationSheetQuestionView(viewModel: viewModel)  // Sheet personalizado para mostrar la traducción
        }
        .onAppear {
            soundManager.playWinnerSound()
        }
    }
}



struct TranslationSheetQuestionView: View {
    @ObservedObject var viewModel: QuestionAnswerViewModel

    var body: some View {
        VStack {
            // Contenido dentro de un ScrollView para manejar traducciones largas
            ScrollView {
                VStack(alignment: .leading) {
                    // Mostrar traducción si existe
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
                viewModel.showResultModal = false // Cerrar el sheet
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
