//
//  CustomTabBar.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppState.AppView

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    selectedTab = .challengeList
                }) {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Desafíos")
                    }
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = .mapContainer
                }) {
                    VStack {
                        Image(systemName: "map")
                        Text("Mapa")
                    }
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = .settings
                }) {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Ajustes")
                    }
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = .eventView
                }) {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Eventos")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 80)  // Altura fija para el TabBar
            .padding(.horizontal, 16)  // Un padding horizontal más ligero
            .background(Color.mateGold.opacity(0.8))  // Ajuste de la opacidad para una mejor visualización
            //.cornerRadius(15)  // Bordes redondeados más pronunciados
            .shadow(radius: 5)  // Añadir una ligera sombra para hacerla más visible
        }
        //.padding(.top, 10)  // Un pequeño padding desde la parte superior
    }
}
