//
//  tourBasqueCountryApp.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 11/9/24.
//

import SwiftUI

import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


import SwiftUI

@main
struct tourBasqueCountryApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject  var appState = AppState()

    var body: some Scene {
        WindowGroup {
            NavigationState()
                        .environmentObject(appState)
            //ContentView()
              //  .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
