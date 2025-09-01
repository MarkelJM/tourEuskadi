//
//  ForgotPasswordDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import SwiftUI
import Combine

class ForgotPasswordDataManager {
    private let firestoreManager = FirestoreManager()
    
    func resetPassword(_ email: String) -> AnyPublisher<Void, Error> {
        return firestoreManager.resetPassword(email: email)
    }
}
