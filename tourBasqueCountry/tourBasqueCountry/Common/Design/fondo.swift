//
//  fondo.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import SwiftUI

struct Fondo: View {
    var body: some View {
        ZStack {
            // Fondo con gradiente suave (Pantone 279 C a Pantone 288 C)
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 83/255, green: 143/255, blue: 213/255), // Pantone 279 C (Azul claro)
                Color(red: 0/255, green: 91/255, blue: 171/255),  // Pantone 7687 C (Azul medio)
                Color(red: 0/255, green: 46/255, blue: 93/255)   // Pantone 288 C (Azul oscuro)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Botón con color sólido (Pantone 279 C - Azul Claro)
                Button(action: {
                    // Acción del botón
                }) {
                    Text("Botón Azul Claro")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 83/255, green: 143/255, blue: 213/255)) // Azul claro
                        .cornerRadius(10)
                }
                
                // Botón con gradiente lineal (Pantone 279 C y 7687 C)
                Button(action: {
                    // Acción del botón
                }) {
                    Text("Botón con Gradiente")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                Color(red: 83/255, green: 143/255, blue: 213/255), // Azul claro
                                Color(red: 0/255, green: 91/255, blue: 171/255)   // Azul medio
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(10)
                }
                
                // Botón con borde y relleno personalizado (Pantone 288 C)
                Button(action: {
                    // Acción del botón
                }) {
                    Text("Botón con Borde")
                        .font(.headline)
                        .foregroundColor(Color(red: 0/255, green: 46/255, blue: 93/255)) // Azul oscuro (Texto)
                        .padding()
                        .background(Color.white) // Fondo blanco
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0/255, green: 46/255, blue: 93/255), lineWidth: 2) // Borde azul oscuro
                        )
                }
            }
            .padding()
        }
    }
}

// Vista previa
#Preview {
    Fondo()
}
