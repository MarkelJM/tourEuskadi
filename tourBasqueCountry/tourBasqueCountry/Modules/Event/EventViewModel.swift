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
    private var allEvents = [EventModel]() // Mantener todos los eventos en memoria

    init() {
        // Cargar todos los eventos al inicializar
        loadAllEvents()
    }

    // Cargar todos los eventos sin aplicar filtros
    func loadAllEvents() {
        eventManager.loadEvents() // Ahora devuelve un Publisher
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error al cargar eventos: \(error)")
                }
            }, receiveValue: { [weak self] events in
                self?.allEvents = events
                self?.filteredEvents = events.sorted(by: { $0.eventStartDate < $1.eventStartDate }) // Ordenar por fecha
            })
            .store(in: &cancellables)
    }

    // Aplicar filtros y ordenar eventos
    func applyFilters(date: Date?, distance: Double?, userLocation: CLLocation) {
        var filtered = allEvents

        // Filtrar por fecha si hay una seleccionada
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            filtered = filtered.filter { event in
                guard let eventDate = formatter.date(from: event.eventStartDate) else { return false }
                return eventDate >= date
            }
        }

        // Filtrar por distancia si hay una seleccionada
        if let distance = distance {
            filtered = filtered.filter { event in
                let eventLocation = CLLocation(latitude: event.latwgs84, longitude: event.lonwgs84)
                return userLocation.distance(from: eventLocation) / 1000 <= distance
            }
        }

        // Ordenar los eventos por fecha (más antiguo a más actual)
        filtered = filtered.sorted(by: { $0.eventStartDate < $1.eventStartDate })

        // Actualizar la lista de eventos filtrados
        self.filteredEvents = filtered
    }
}

/*
import Combine
import CoreLocation

class EventViewModel: ObservableObject {
    @Published var filteredEvents = [EventModel]()
    private var eventManager = EventDataManager()
    private var cancellables = Set<AnyCancellable>()
    private var allEvents = [EventModel]() // Mantener todos los eventos en memoria

    init() {
        // Cargar todos los eventos al inicializar
        loadAllEvents()
    }

    // Cargar todos los eventos sin aplicar filtros
    func loadAllEvents() {
        eventManager.loadEvents() // Debe devolver un Publisher
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error al cargar eventos: \(error)")
                }
            }, receiveValue: { [weak self] events in
                self?.allEvents = events
                self?.filteredEvents = events.sorted(by: { $0.eventStartDate < $1.eventStartDate }) // Ordenar por fecha
            })
            .store(in: &cancellables)
    }

    // Aplicar filtros y ordenar eventos
    func applyFilters(date: Date?, distance: Double?, userLocation: CLLocation) {
        var filtered = allEvents

        // Filtrar por fecha si hay una seleccionada
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            filtered = filtered.filter { event in
                guard let eventDate = formatter.date(from: event.eventStartDate) else { return false }
                return eventDate >= date
            }
        }

        // Filtrar por distancia si hay una seleccionada
        if let distance = distance {
            filtered = filtered.filter { event in
                let eventLocation = CLLocation(latitude: event.latwgs84, longitude: event.lonwgs84)
                return userLocation.distance(from: eventLocation) / 1000 <= distance
            }
        }

        // Ordenar los eventos por fecha (más antiguo a más actual)
        filtered = filtered.sorted(by: { $0.eventStartDate < $1.eventStartDate })

        // Actualizar la lista de eventos filtrados
        self.filteredEvents = filtered
    }
}
*/



/*
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
*/
