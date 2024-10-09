//
//  Puzzle.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation

struct Puzzle: Identifiable {
    var id: String
    var province: String
    var question: String
    var questionImage: String
    var images: [String: String]
    var correctPositions: [String: PuzzleCoordinate]
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var isCapital: Bool
    var challenge: String
    var informationDetail: String
}
