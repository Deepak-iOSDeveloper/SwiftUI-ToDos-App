//
//  ToDosApp.swift
//  ToDos
//
//  Created by SwiftieDev on 03/02/2024.
//

import SwiftUI
import SwiftData

@main
struct ToDosApp: App {
    @AppStorage("theme") private var isDark = true
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(isDark ? .dark : .light)
        }
        .modelContainer(for: ReminderList.self)
    }
}
