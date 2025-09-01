//
//  TakePhoto.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation

struct TakePhoto: Identifiable {
    var id: String
    var province: String
    var question: String
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var isCapital: Bool
    var challenge: String
    var informationDetail: String
}
