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
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        bindLocationUpdates()
    }

    func bindLocationUpdates() {
        // Escucha los cambios en la ubicación del usuario
        locationManager.$location
            .compactMap { $0 } // Nos aseguramos de no procesar valores nil
            .sink { [weak self] location in
                guard let self = self else { return }
                // Filtra los eventos por la ubicación actual del usuario y la fecha seleccionada
                self.filterEvents(for: Date(), userLocation: location)
            }
            .store(in: &cancellables)
    }

    func loadEvents(for date: Date, userLocation: CLLocation) {
        eventManager.$events
            .map { events in
                self.eventManager.filterEvents(by: date, userLocation: userLocation)
            }
            .sink { [weak self] events in
                self?.filteredEvents = events
            }
            .store(in: &cancellables)

        eventManager.loadEvents()
    }

    func filterEvents(for date: Date, userLocation: CLLocation) {
        filteredEvents = eventManager.filterEvents(by: date, userLocation: userLocation)
    }
}
