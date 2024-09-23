//
//  EventViewModel.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import Combine
import CoreLocation

class EventViewModel: ObservableObject {
    @Published var filteredEvents = [EventModel]()
    private var eventManager = EventDataManager()
    private var cancellables = Set<AnyCancellable>()

    init(locationManager: LocationManager) {
        bindLocationUpdates(locationManager: locationManager)
    }

    func bindLocationUpdates(locationManager: LocationManager) {
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self else { return }
                self.filterEvents(for: Date(), distance: 50, userLocation: location) // Cargar eventos con valores por defecto
            }
            .store(in: &cancellables)
    }

    func loadEvents(for date: Date, distance: Double, userLocation: CLLocation) {
        eventManager.$events
            .map { events in
                self.eventManager.filterEvents(by: date, distance: distance, userLocation: userLocation)
            }
            .sink { [weak self] events in
                self?.filteredEvents = events
            }
            .store(in: &cancellables)

        eventManager.loadEvents()
    }

    func filterEvents(for date: Date, distance: Double, userLocation: CLLocation) {
        filteredEvents = eventManager.filterEvents(by: date, distance: distance, userLocation: userLocation)
    }
}
