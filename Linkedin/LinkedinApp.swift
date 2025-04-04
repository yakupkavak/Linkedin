//
//  LinkedinApp.swift
//  Linkedin
//
//  Created by Yakup Kavak on 4.04.2025.
//

import SwiftUI

@main
struct LinkedinApp: App {
    let persistenceController = PersistenceController.shared
    // Global ViewModel örneği: AuthViewModel
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authViewModel)
        }
    }
}
