//
//  EventView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import SwiftUI
import CoreLocation

struct EventView: View {
    @StateObject private var viewModel = EventViewModel(locationManager: LocationManager())
    @ObservedObject var locationManager = LocationManager()
    @State private var selectedDate = Date()
    @State private var selectedEvent: EventModel?

    var body: some View {
        VStack {
            DatePicker("Selecciona una fecha", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            if let location = locationManager.location {
                List(viewModel.filteredEvents) { event in
                    EventRow(event: event)
                        .onTapGesture {
                            selectedEvent = event
                        }
                }
                .sheet(item: $selectedEvent) { event in
                    if let url = URL(string: event.physicalUrl) {
                        EventWebView(url: url)
                    } else {
                        Text("No se puede cargar la página web")
                    }
                }
                .onAppear {
                    viewModel.loadEvents(for: selectedDate, userLocation: location)
                }
            } else {
                Text("Esperando ubicación...")
                    .onAppear {
                        viewModel.loadEvents(for: selectedDate, userLocation: CLLocation(latitude: 43.3167, longitude: -1.9836)) // Ubicación predeterminada
                    }
            }
        }
    }
}
