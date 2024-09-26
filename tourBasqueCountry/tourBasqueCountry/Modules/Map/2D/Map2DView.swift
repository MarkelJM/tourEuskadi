//
//  Map2DView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI
import MapKit

struct Map2DView: View {
    @StateObject private var viewModel = Map2DViewModel(appState: AppState())
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward?
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Fondo() // Fondo de la vista

            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.authorizationStatus == .notDetermined {
                    Text("Solicitando permisos de ubicación...")
                } else if viewModel.authorizationStatus == .denied {
                    Text("Permisos de ubicación denegados.")
                        .foregroundColor(.red)
                } else {
                    Map(coordinateRegion: $viewModel.region2D, annotationItems: viewModel.mapAnnotations + [viewModel.userLocationAnnotation].compactMap { $0 }) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            // Aquí manejas la visualización de las anotaciones
                        }
                    }
                    .onAppear {
                        viewModel.checkChallengeStatus()
                        if viewModel.isChallengeBegan {
                            viewModel.fetchSpots()
                        }
                    }
                    .sheet(item: $selectedSpot) { spot in
                        MapCallOutView(spot: spot, viewModel: viewModel)
                            .environmentObject(appState)
                    }
                    .sheet(item: $selectedReward) { reward in
                        CalloutRewardView(reward: reward, challenge: reward.challenge, viewModel: viewModel)
                            .environmentObject(appState)
                    }
                    Spacer()
                }
            }
        }
    }
}
