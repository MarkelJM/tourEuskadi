//
//  ChallengeRewardDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Combine
import FirebaseFirestore

class ChallengeRewardDataManager {
    private let firestoreManager = ChallengeRewardFirestoreManager()
    
    func fetchChallengeRewardById(_ id: String) -> AnyPublisher<ChallengeReward, Error> {
        return firestoreManager.fetchChallengeRewardById(id)
    }
}
