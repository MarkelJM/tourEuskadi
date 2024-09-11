//
//  tourBasqueCountryApp.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 11/9/24.
//

import SwiftUI

@main
struct tourBasqueCountryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
