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
    @ObservedObject var viewModel: BaseMapViewModel // Cambio aquí
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
