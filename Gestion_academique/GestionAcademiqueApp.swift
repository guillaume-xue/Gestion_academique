//
//  listApp.swift
//  list
//
//  Created by Guillaume on 18/02/2026.
//

import SwiftUI
import SwiftData

@main
struct listApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: [CoursEntity.self, EtudiantEntity.self, EnseignantEntity.self])
    }
}

