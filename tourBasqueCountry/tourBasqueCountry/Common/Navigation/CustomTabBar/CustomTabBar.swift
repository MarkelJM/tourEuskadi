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
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        //.frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottom) // Asegura que esté en la parte inferior

        .padding(.top, 150)
    }
}
