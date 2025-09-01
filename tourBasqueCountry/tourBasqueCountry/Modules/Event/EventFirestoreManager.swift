//
//  EventFirestoreManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import FirebaseFirestore
import Combine

class EventFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchEvents() -> AnyPublisher<[EventModel], Error> {
        Future { promise in
            self.db.collection("agenda").getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let documents = snapshot?.documents {
                    let events = documents.compactMap { doc -> EventModel? in
                        let data = doc.data()
                        let documentID = doc.documentID
                        return EventModel(from: data, documentID: documentID)
                    }
                    promise(.success(events))
                }
            }
        }.eraseToAnyPublisher()
    }
}

/*
import FirebaseFirestore
import Combine

class EventFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchEvents() -> AnyPublisher<[EventModel], Error> {
        Future { promise in
            self.db.collection("agenda").getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let documents = snapshot?.documents {
                    let events = documents.compactMap { doc -> EventModel? in
                        let data = doc.data()
                        let documentID = doc.documentID
                        return EventModel(from: data, documentID: documentID)
                    }
                    promise(.success(events))
                }
            }
        }.eraseToAnyPublisher()
    }
}
*/
