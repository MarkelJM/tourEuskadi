//
//  RegisterdataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import Combine

class RegisterDataManager {
    private let firestoreManager = FirestoreManager()
    
    func registerUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        firestoreManager.registerUser(email: email, password: password)
    }
    
    func sendEmailVerification() -> AnyPublisher<Void, Error> {
        firestoreManager.sendEmailVerification()
    }
    
    func checkEmailVerification() -> AnyPublisher<Bool, Error> {
        firestoreManager.checkEmailVerification()
    }
}
