//
//  ErrorHandlingSampleApp.swift
//  ErrorHandlingSample
//
//  Created by Hiroaki-Hirabayashi on 2022/05/12.
//

import SwiftUI

@main
struct ErrorHandlingSampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
