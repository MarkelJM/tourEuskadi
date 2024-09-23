//
//  Map2DView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI
import MapKit

struct Map2DView: View {
    @StateObject private var viewModel = MapViewModel(appState: AppState())
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward?
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.authorizationStatus == .notDetermined {
                    Text("Requesting location permissions...")
                } else if viewModel.authorizationStatus == .denied {
                    Text("Location permissions denied.")
                        .foregroundColor(.red)
                } else {
                    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.mapAnnotations + [viewModel.userLocationAnnotation].compactMap { $0 }) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            // Lógica de anotación aquí
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
