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
    @State private var selectedEvent: EventModel?

    // Estados para los filtros
    @State private var selectedDate = Date()
    @State private var selectedDistance: Double = 50 // Filtro de distancia en kilómetros
    let distanceOptions: [Double] = [10, 20, 50, 100, 200] // Opciones de distancia en km como Double
    
    @State private var showingDistanceFilter = false // Mostrar filtro de distancia
    @State private var showingDateFilter = false // Mostrar filtro de fecha

    var body: some View {
        VStack {
            // Filtro de distancia y fecha en una fila horizontal
            HStack {
                Button(action: {
                    showingDistanceFilter.toggle() // Desplegar el filtro de distancia
                }) {
                    HStack {
                        Image(systemName: "location.circle")
                        Text("Distancia: \(Int(selectedDistance)) km")
                    }
                }
                .sheet(isPresented: $showingDistanceFilter) {
                    DistanceFilterView(selectedDistance: $selectedDistance, options: distanceOptions) {
                        viewModel.loadEvents(for: selectedDate, distance: selectedDistance, userLocation: locationManager.location ?? CLLocation(latitude: 43.3167, longitude: -1.9836))
                    }
                }

                Button(action: {
                    showingDateFilter.toggle() // Desplegar el filtro de fecha
                }) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Fecha: \(formattedDate(selectedDate))")
                    }
                }
                .sheet(isPresented: $showingDateFilter) {
                    DatePicker("Selecciona una fecha", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: selectedDate) { _ in
                            viewModel.loadEvents(for: selectedDate, distance: selectedDistance, userLocation: locationManager.location ?? CLLocation(latitude: 43.3167, longitude: -1.9836))
                        }
                        .padding()
                }
            }
            .padding()

            // Lista de eventos filtrados
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
                    viewModel.loadEvents(for: selectedDate, distance: selectedDistance, userLocation: location)
                }
            } else {
                Text("Esperando ubicación...")
                    .onAppear {
                        viewModel.loadEvents(for: selectedDate, distance: selectedDistance, userLocation: CLLocation(latitude: 43.3167, longitude: -1.9836)) // Ubicación predeterminada
                    }
            }
        }
        .navigationTitle("Eventos")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Formatear la fecha para mostrarla
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DistanceFilterView: View {
    @Binding var selectedDistance: Double
    let options: [Double]
    var applyFilter: () -> Void

    var body: some View {
        VStack {
            Text("Selecciona la distancia")
                .font(.headline)
                .padding()

            Picker("Distancia", selection: $selectedDistance) {
                ForEach(options, id: \.self) { distance in
                    Text("\(Int(distance)) km").tag(distance)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Button(action: {
                applyFilter() // Aplica el filtro
            }) {
                Text("Aplicar filtro")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}
