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

    func filterEvents(by date: Date, userLocation: CLLocation) -> [EventModel] {
        let filteredByDate = events.filter { event in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            guard let startDate = formatter.date(from: event.eventStartDate) else { return false }
            return startDate >= date
        }

        return filteredByDate.sorted { event1, event2 in
            let location1 = CLLocation(latitude: event1.latwgs84, longitude: event1.lonwgs84)
            let location2 = CLLocation(latitude: event2.latwgs84, longitude: event2.lonwgs84)
            return userLocation.distance(from: location1) < userLocation.distance(from: location2)
        }
    }
}
