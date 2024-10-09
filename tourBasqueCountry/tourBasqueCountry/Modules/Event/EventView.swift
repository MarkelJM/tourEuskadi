//
//  EventView.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//


import SwiftUI
import CoreLocation

struct EventView: View {
    @StateObject private var viewModel = EventViewModel()
    @ObservedObject var locationManager = LocationManager()
    @State private var selectedEvent: EventModel?

    // Estados para los filtros
    @State private var selectedDate: Date? = nil // Filtro de fecha (opcional)
    @State private var selectedDistance: Double? = nil // Filtro de distancia (opcional)
    let distanceOptions: [Double] = [10, 20, 50, 100, 200] // Opciones de distancia en km

    @State private var showingDistanceFilter = false // Mostrar filtro de distancia
    @State private var showingDateFilter = false // Mostrar filtro de fecha

    var body: some View {
        VStack {
            // Botón para cargar todos los eventos sin filtros
            Button(action: {
                viewModel.loadAllEvents() // Cargar todos los eventos
            }) {
                Text("Mostrar Todos los Eventos")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mateBlueMedium) // Usamos mateBlueMedium
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Botones de filtros de distancia y fecha
            HStack {
                // Filtro de distancia
                Button(action: {
                    showingDistanceFilter.toggle()
                }) {
                    HStack {
                        Image(systemName: "location.circle")
                        Text(selectedDistance == nil ? "Seleccionar Distancia" : "Distancia: \(Int(selectedDistance!)) km")
                    }
                }
                .sheet(isPresented: $showingDistanceFilter) {
                    DistanceFilterView(selectedDistance: Binding($selectedDistance, replacingNilWith: 50), options: distanceOptions) {
                        viewModel.applyFilters(date: selectedDate, distance: selectedDistance, userLocation: locationManager.location ?? CLLocation(latitude: 43.3167, longitude: -1.9836))
                    }
                }

                // Filtro de fecha
                Button(action: {
                    showingDateFilter.toggle()
                }) {
                    HStack {
                        Image(systemName: "calendar")
                        Text(selectedDate == nil ? "Seleccionar Fecha" : "Fecha: \(formattedDate(selectedDate!))")
                    }
                }
                .sheet(isPresented: $showingDateFilter) {
                    DatePicker("Selecciona una fecha", selection: Binding($selectedDate, replacingNilWith: Date()), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: selectedDate) { _ in
                            viewModel.applyFilters(date: selectedDate, distance: selectedDistance, userLocation: locationManager.location ?? CLLocation(latitude: 43.3167, longitude: -1.9836))
                        }
                        .padding()
                }
            }
            .padding()

            // Botón para quitar filtros
            HStack {
                Button(action: {
                    selectedDistance = nil
                    viewModel.applyFilters(date: selectedDate, distance: nil, userLocation: locationManager.location ?? CLLocation(latitude: 43.3167, longitude: -1.9836))
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill") // Símbolo de "quitar"
                            .foregroundColor(.red)
                        Text("Quitar Distancia")
                            .foregroundColor(.red) // Cambiar el color del texto a rojo
                    }
                }
                .padding()

                Button(action: {
                    selectedDate = nil
                    viewModel.applyFilters(date: nil, distance: selectedDistance, userLocation: locationManager.location ?? CLLocation(latitude: 43.3167, longitude: -1.9836))
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill") // Símbolo de "quitar"
                            .foregroundColor(.red)
                        Text("Quitar fecha")
                            .foregroundColor(.red) // Cambiar el color del texto a rojo
                    }
                }
                .padding()
            }

            // Lista de eventos filtrados o sin filtros
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
                    viewModel.loadAllEvents() // Mostrar todos los eventos cuando aparezca la vista
                }
            } else {
                Text("Esperando ubicación...")
                    .onAppear {
                        viewModel.loadAllEvents() // Cargar eventos predeterminados si no hay ubicación
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

extension Binding {
    /// Provides a default value for optional bindings.
    init(_ source: Binding<Value?>, replacingNilWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
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
                applyFilter() // Aplica el filtro de distancia
            }) {
                Text("Aplicar filtro")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mateGold) // Usamos mateGold para coherencia
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}

/*
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

*/
