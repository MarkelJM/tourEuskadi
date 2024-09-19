//
//  User.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation

enum Avatar: String, Codable, CaseIterable, Identifiable {
    case boy = "chico"
    case girl = "chica"

    var id: String { self.rawValue }
}

enum Province: String, Codable, CaseIterable, Identifiable {
    case avila = "Ávila"
    case burgos = "Burgos"
    case leon = "León"
    case palencia = "Palencia"
    case salamanca = "Salamanca"
    case segovia = "Segovia"
    case soria = "Soria"
    case valladolid = "Valladolid"
    case zamora = "Zamora"
    case other = "Other"
    
    var id: String { self.rawValue }
}

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var birthDate: Date
    var postalCode: String
    var city: String
    var province: Province
    var avatar: Avatar
    var spotIDs: [String]
    var specialRewards: [String: String]
    var challenges: [String: [String]]
}


