//
//  LoginDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import Combine

class LoginDataManager {
    private let firestoreManager = FirestoreManager()
    
    func loginUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        firestoreManager.loginUser(email: email, password: password)
    }
}
