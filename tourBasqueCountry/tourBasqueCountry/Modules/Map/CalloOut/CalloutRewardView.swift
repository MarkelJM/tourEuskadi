//
//  CalloutRewardView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI

struct CalloutRewardView: View {
    var reward: ChallengeReward
    var challenge: String
    @ObservedObject var viewModel: MapViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared


    var body: some View {
        VStack(spacing: 20) {
            Text(reward.challengeTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.mateGold)
            
            Text(reward.abstract)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            /*
            AsyncImage(url: URL(string: reward.prizeImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
             */
            
            Spacer()
            Button(action: {
                appState.currentView = .challengeReward(challengeName: reward.challenge)
                soundManager.playButtonSound()
            }) {
                Text("Obtener Recompensa")
                    .font(.headline)
                    .foregroundColor(.mateWhite)
                    .padding()
                    .background(Color.mateGold)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            Spacer()
        }
        .padding()
        .background(Color.mateWhite.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
