//
//  TakePhotoView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI
import AVFoundation

struct TakePhotoView: View {
    @StateObject var viewModel: TakePhotoViewModel
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
                                .background(Color.mateGold) // Usamos mateGold
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando tarea de foto...")
                            .font(.title2)
                            .foregroundColor(.mateWhite) // Usamos mateWhite
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let takePhoto = viewModel.takePhoto {
                        VStack(spacing: 20) {
                            Text(takePhoto.question)
                                .font(.title2)
                                .foregroundColor(.mateGold) // Usamos mateGold
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Button(action: {
                                checkCameraPermission()
                            }) {
                                Text("Tomar Foto")
                                    .padding()
                                    .background(Color.mateBlueMedium) // Usamos mateBlueMedium
                                    .foregroundColor(.mateWhite)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultModal) {
                    ResultTakePhotoView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.fetchTakePhoto()
            }
        }
    }

    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                openCamera()
            } else {
                print("Permiso denegado para usar la cámara")
            }
        }
    }

    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraView = CameraView(viewModel: viewModel)
                let controller = UIApplication.shared.windows.first?.rootViewController
                controller?.present(UIHostingController(rootView: cameraView), animated: true, completion: nil)
            } else {
                print("La cámara no está disponible en este dispositivo")
            }
        }
    }
}





struct ResultTakePhotoView: View {
    @ObservedObject var viewModel: TakePhotoViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común

            VStack {
                // Menú desplegable de idiomas
                HStack {
                    Text("Seleccionar idioma:")
                        .foregroundColor(.mateGold)

                    Menu {
                        ForEach(viewModel.availableLanguages, id: \.self) { language in
                            Button(action: { viewModel.changeLanguage(to: language, for: viewModel.activityId) }) {
                                Text(language.capitalized)  // Mostramos el nombre del idioma
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
        .onAppear {
            soundManager.playWinnerSound() // Reproducir sonido cuando aparezca el resultado
            viewModel.fetchAvailableLanguages() // Cargar los idiomas disponibles
            viewModel.fetchTranslationForActivity(activityId: viewModel.activityId, language: viewModel.selectedLanguage)
        }
    }
}
