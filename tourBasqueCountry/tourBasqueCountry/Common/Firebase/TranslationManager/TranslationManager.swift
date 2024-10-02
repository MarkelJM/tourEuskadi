//
//  TranslationManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 2/10/24.
//

import Foundation
import FirebaseFirestore
import Combine

class TranslationDataManager {
    private let db = Firestore.firestore()

    // Obtener los idiomas disponibles (documentos en la colección 'translate')
    func fetchAvailableLanguages() -> AnyPublisher<[String], Error> {
        Future { promise in
            self.db.collection("translate").getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let documents = snapshot?.documents {
                    let languages = documents.map { $0.documentID }  // Extraer los IDs de los documentos
                    promise(.success(languages))
                } else {
                    promise(.failure(NSError(domain: "No languages found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Obtener la traducción para una actividad en base al idioma seleccionado
    func fetchTranslationForActivity(activityId: String, language: String) -> AnyPublisher<Translation, Error> {
        Future { promise in
            let docRef = self.db.collection("translate").document(language).collection("activities").document(activityId)
            
            docRef.getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = document?.data(), let translation = Translation(from: data) {
                    promise(.success(translation))
                } else {
                    promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
