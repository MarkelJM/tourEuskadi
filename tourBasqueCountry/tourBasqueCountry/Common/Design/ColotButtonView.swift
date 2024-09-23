//
//  ColotButtonView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

// Botón con color sólido personalizado (oro mate)
func goldButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.white)
            .padding()
            .background(
                Capsule()
                    .fill(Color(red: 212/255, green: 175/255, blue: 55/255)) // Oro mate
            )
            .overlay(
                Capsule()
                    .stroke(Color.white, lineWidth: 2) // Borde blanco
            )
    }
}

// Botón con color sólido (Pantone 279 C - Azul Claro)
func blueButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.white)
            .padding()
            .background(
                Capsule()
                    .fill(Color(red: 83/255, green: 143/255, blue: 213/255)) // Azul claro (Pantone 279 C)
            )
    }
}

// Botón con gradiente lineal (Pantone 279 C y 7687 C)
func gradientButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 83/255, green: 143/255, blue: 213/255), // Azul claro (Pantone 279 C)
                    Color(red: 0/255, green: 91/255, blue: 171/255)   // Azul medio (Pantone 7687 C)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(10)
    }
}

// Botón con borde y fondo blanco personalizado (Pantone 288 C)
func borderedButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(Color(red: 0/255, green: 46/255, blue: 93/255)) // Azul oscuro (Pantone 288 C)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0/255, green: 46/255, blue: 93/255), lineWidth: 2) // Borde azul oscuro
            )
    }
}

// Botón con fondo azul medio (Pantone 7687 C) y borde azul oscuro
func borderedBlueButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.white)
            .padding()
            .background(Color(red: 0/255, green: 91/255, blue: 171/255)) // Azul medio (Pantone 7687 C)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0/255, green: 46/255, blue: 93/255), lineWidth: 2) // Borde azul oscuro (Pantone 288 C)
            )
    }
}
