//
//  EventDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import Combine
import CoreLocation

class EventDataManager: ObservableObject {
    private var firestoreManager = EventFirestoreManager()
    @Published var events = [EventModel]() // Mantener los eventos en memoria
    private var cancellables = Set<AnyCancellable>()
    
    func loadEvents() -> AnyPublisher<[EventModel], Error> {
        // Obtenemos los eventos de Firestore
        return firestoreManager.fetchEvents()
            .handleEvents(receiveOutput: { [weak self] events in
                self?.events = events // Guardar los eventos obtenidos
            })
            .eraseToAnyPublisher()
    }
    
    func filterEvents(by date: Date, distance: Double, userLocation: CLLocation) -> [EventModel] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        // Filtrar por fecha
        let filteredByDate = events.filter { event in
            guard let startDate = formatter.date(from: event.eventStartDate) else { return false }
            return startDate >= date
        }

        // Filtrar por distancia
        return filteredByDate.filter { event in
            let eventLocation = CLLocation(latitude: event.latwgs84, longitude: event.lonwgs84)
            return userLocation.distance(from: eventLocation) / 1000 <= distance // Convertir a km
        }
    }
}

/*
 import Combine
 import CoreLocation
 
 class EventDataManager: ObservableObject {
 private var firestoreManager = EventFirestoreManager()
 @Published var events = [EventModel]()
 private var cancellables = Set<AnyCancellable>()
 
 func loadEvents() {
 firestoreManager.fetchEvents()
 .sink(receiveCompletion: { completion in
 switch completion {
 case .failure(let error):
 print("Error fetching events: \(error)")
 case .finished:
 break
 }
 }, receiveValue: { [weak self] events in
 self?.events = events
 })
 .store(in: &cancellables)
 }
 
 func filterEvents(by date: Date, distance: Double, userLocation: CLLocation) -> [EventModel] {
 let formatter = DateFormatter()
 formatter.dateFormat = "dd/MM/yyyy"
 
 let filteredByDate = events.filter { event in
 guard let startDate = formatter.date(from: event.eventStartDate) else { return false }
 return startDate >= date
 }
 
 // Filtrar por distancia
 return filteredByDate.filter { event in
 let eventLocation = CLLocation(latitude: event.latwgs84, longitude: event.lonwgs84)
 return userLocation.distance(from: eventLocation) / 1000 <= distance // Convertir a km
 }
 }
 }
 */
