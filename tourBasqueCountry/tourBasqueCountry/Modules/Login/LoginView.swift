//
//  LoginView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Iniciar Sesión")
                    .font(.largeTitle)
                    .foregroundColor(.mateGold)
                    .padding(.top, 40)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)

                SecureField("Contraseña", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                
                Button(action: {
                    appState.currentView = .forgotPassword
                }) {
                    Text("¿Olvidaste la contraseña?")
                        .foregroundColor(.blue)
                }

                Button(action: {
                    viewModel.login()
                }) {
                    Text("Iniciar Sesión")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateRed)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    appState.currentView = .onboardingOne
                }) {
                    Text("Crear Cuenta")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateBlue)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(20)
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(viewModel.loginSuccess) { _ in
            appState.currentView = .challengeList
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
        .environmentObject(AppState())
}

