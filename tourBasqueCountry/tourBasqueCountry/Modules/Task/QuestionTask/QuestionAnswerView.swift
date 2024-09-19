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
                Image("fondoSolar")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
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
                                    .background(Color.mateRed)
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
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(viewModel.selectedOption == option ? Color.mateGreen : Color.mateBlue)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
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

#Preview {
    QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: "mockId", appState: AppState()))
        .environmentObject(AppState())
}


struct ResultQuestionView: View {
    @ObservedObject var viewModel: QuestionAnswerViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                // ScrollView para manejar textos largos en informationDetail
                ScrollView {
                    VStack {
                        if let informationDetail = viewModel.questionAnswer?.informationDetail {
                            Text(informationDetail)
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                }
                .frame(maxHeight: 200)

                Button(action: {
                    viewModel.showResultModal = false
                    appState.currentView = .mapContainer

                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateRed)
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


