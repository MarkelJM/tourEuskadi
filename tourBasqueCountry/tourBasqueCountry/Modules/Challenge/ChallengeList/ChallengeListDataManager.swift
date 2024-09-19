//
//  ChallengeListDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Combine

class ChallengeListDataManager {
    private let firestoreManager = ChallengeListFirestoreManager()

    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        return firestoreManager.fetchChallenges()
    }
}
