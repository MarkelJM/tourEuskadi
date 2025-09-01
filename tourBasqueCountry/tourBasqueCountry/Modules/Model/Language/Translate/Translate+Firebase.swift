//
//  Translate+Firebase.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 2/10/24.
//

import Foundation
import FirebaseFirestore

extension Translation {
    init?(from firestoreData: [String: Any]) {
        guard let text = firestoreData["text"] as? String else {
            return nil
        }
        self.text = text
        self.url = firestoreData["url"] as? String
    }
}
