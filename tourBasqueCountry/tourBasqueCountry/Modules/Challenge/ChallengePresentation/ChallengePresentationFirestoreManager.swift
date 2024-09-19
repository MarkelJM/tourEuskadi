//
//  ChallengePresentationFirestoreManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Combine
import FirebaseFirestore

class ChallengePresentationFirestoreManager {
    private let db = Firestore.firestore()

    func updateChallengeStatus(challengeID: String, isBegan: Bool) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.db.collection("challenges").document(challengeID).updateData(["isBegan": isBegan]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchChallengeByName(_ name: String) -> AnyPublisher<Challenge, Error> {
        Future { promise in
            self.db.collection("challenges")
                .whereField("challengeName", isEqualTo: name)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let document = snapshot?.documents.first {
                        let data = document.data()
                        if let challenge = Challenge(from: data) {
                            promise(.success(challenge))
                        } else {
                            promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode challenge"])))
                        }
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Challenge not found"])))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
