//
//  SettingView.swift
//  ToDos
//
//  Created by DEEPAK BEHERA on 18/07/25.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    @AppStorage("theme") private var isDark = true
    @Query private var reminders: [Reminder]
    @Environment(\.modelContext) var modelContext
    @State private var wantToDelete = false
    @State private var succesfulDelete = false
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle(isOn: $isDark) {
                    Label(isDark ? "Dark Mode On" : "Dark Mode Off", systemImage: isDark ? "moon.fill" : "sun.max.fill")
                        .foregroundStyle(.primary)
                }
            }

            Section("Deletion") {
                Button(role: .destructive) {
                    wantToDelete = true
                } label: {
                    Label("Delete All Completed Tasks", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(isDark ? .dark : .light)
        .alert("Delete!", isPresented: $wantToDelete) {
            Button("Delete", systemImage: "trash") {
                deleteCompletedTasks()
            }
            Button("Cancel", role: .cancel) {}
        }message: {
            Text("Are you sure to delete all completed todos ?")
        }
        .alert("Deleted", isPresented: $succesfulDelete) {
            //
        }message: {
            Text("Delete successful!!")
        }
    }

    private func deleteCompletedTasks() {
        for item in reminders where item.isCompleted {
            modelContext.delete(item)
        }

        do {
            try modelContext.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                succesfulDelete = true
            }
        } catch {
            print("Failed to delete completed tasks: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    SettingView()
        .modelContainer(for: Reminder.self, inMemory: true)
}
