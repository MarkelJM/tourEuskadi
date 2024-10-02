//
//  PuzzleView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct PuzzleView: View {
    @StateObject var viewModel: PuzzleViewModel
    @EnvironmentObject var appState: AppState
    @State private var showInstructionsAlert = true
    
    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común

            ScrollView {
                VStack {
                    if viewModel.isLoading {
                        Text("Cargando puzzles...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let puzzle = viewModel.puzzles.first {
                        VStack(alignment: .leading) {
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
                                    viewModel.checkPuzzle()
                                }) {
                                    Text("Comprobar Puzzle")
                                        .padding()
                                        .background(Color.mateBlueMedium) // Usamos mateBlueMedium
                                        .foregroundColor(.mateWhite)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 50)

                            // Texto de la pregunta
                            Text(puzzle.question)
                                .font(.subheadline)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                                .padding(.top, 30)
                            
                            GeometryReader { geometry in
                                ZStack {
                                    // Main Puzzle Image
                                    AsyncImage(url: URL(string: puzzle.questionImage)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                    }
                                    .padding()

                                    // Dropped Pieces
                                    ForEach(viewModel.droppedPieces.keys.sorted(), id: \.self) { key in
                                        if let imageUrl = puzzle.images[key], let position = viewModel.droppedPieces[key] {
                                            AsyncImage(url: URL(string: imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .position(x: position.x, y: position.y)
                                                    .gesture(
                                                        DragGesture()
                                                            .onChanged { value in
                                                                viewModel.updateDraggedPiecePosition(to: value.location, key: key)
                                                            }
                                                            .onEnded { _ in
                                                                viewModel.dropPiece()
                                                            }
                                                    )
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 50, height: 50)
                                                    .position(x: position.x, y: position.y)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 500)
                            .padding()

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(puzzle.images.keys.sorted(), id: \.self) { key in
                                        if let imageUrl = puzzle.images[key] {
                                            AsyncImage(url: URL(string: imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .padding()
                                                    .onTapGesture {
                                                        viewModel.selectPiece(key: key)
                                                    }
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 100, height: 100)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                            }
                            .frame(height: 150)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5)) // Fondo con opacidad para el VStack
                        .cornerRadius(20)
                        .sheet(isPresented: $viewModel.showSheet) {
                            ResulPuzzleSheetView(viewModel: viewModel)
                        }
                        .alert(isPresented: $showInstructionsAlert) {
                            Alert(
                                title: Text("Instrucciones"),
                                message: Text("Primero debe seleccionar la imagen en la parte inferior y una vez que se muestre en el puzzle situarlo en su lugar."),
                                dismissButton: .default(Text("Entendido"))
                            )
                        }
                    } else {
                        Text("No hay puzzles disponibles")
                            .foregroundColor(.mateWhite)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPuzzle()
        }
    }
}


struct ResulPuzzleSheetView: View {
    @ObservedObject var viewModel: PuzzleViewModel
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
                    viewModel.showSheet = false
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
