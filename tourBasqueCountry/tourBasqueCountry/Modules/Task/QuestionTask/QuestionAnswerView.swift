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
    
    var body: some View {
        ZStack {
            Fondo() // Fondo común

            VStack {
                // Menú desplegable de idiomas
                HStack {
                    Text("Seleccionar idioma:")
                        .foregroundColor(.mateGold)
                    
                    Menu {
                        ForEach(viewModel.availableLanguages, id: \.self) { language in
                            Button(action: {
                                viewModel.changeLanguage(to: language, for: viewModel.activityId) // Corregimos esta línea
                            }) {
                                Text(language)
                            }
                        }
                    } label: {
                        Label("Idioma", systemImage: "globe")
                    }
                    .padding(.trailing, 20)
                }
                .padding()

                // Mostrar la traducción si existe
                if let translation = viewModel.translation {
                    Text(translation.text)
                        .font(.title)
                        .foregroundColor(.mateGold)
                        .padding()

                    if let url = translation.url, let urlLink = URL(string: url) {
                        Link("Más información", destination: urlLink)
                            .foregroundColor(.blue)
                            .padding()
                    }
                } else {
                    Text(viewModel.alertMessage)
                        .font(.title)
                        .foregroundColor(.mateGold)
                        .padding()
                }

                Button(action: {
                    viewModel.showResultModal = false
                    appState.currentView = .mapContainer
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateBlueMedium) // Usamos mateBlueMedium en lugar de mateRed
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            soundManager.playWinnerSound()
            viewModel.fetchAvailableLanguages() // Obtener los idiomas disponibles al aparecer la vista
            viewModel.fetchTranslationForActivity(activityId: viewModel.activityId, language: viewModel.selectedLanguage)
        }
    }
}

#Preview {
    QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: "mockId", appState: AppState()))
        .environmentObject(AppState())
}

