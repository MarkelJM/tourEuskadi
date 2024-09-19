//
//  FillGap+Extension.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import FirebaseFirestore

extension FillGap {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let question = firestoreData["question"] as? String,
              let images = firestoreData["images"] as? String,
              let correctPositions = firestoreData["correct_positions"] as? [String],
              let customMessage = firestoreData["custom_message"] as? String,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let incorrectAnswerMessage = firestoreData["incorrect_answer_message"] as? String,
              let isCapital = firestoreData["isCapital"] as? Bool,
              let challenge = firestoreData["challenge"] as? String else {
            return nil
        }

        self.id = id
        self.province = province
        self.question = question
        self.images = images
        self.correctPositions = correctPositions
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
        self.isCapital = isCapital
        self.challenge = challenge
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "question": question,
            "images": images,
            "correct_positions": correctPositions,
            "custom_message": customMessage,
            "correct_answer_message": correctAnswerMessage,
            "incorrect_answer_message": incorrectAnswerMessage,
            "isCapital": isCapital,
            "challenge": challenge
        ]
    }
}
