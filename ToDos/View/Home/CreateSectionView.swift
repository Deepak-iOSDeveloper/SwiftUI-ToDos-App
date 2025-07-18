//
//  CreateSectionView.swift
//  ToDos
//
//  Created by SwiftieDev on 03/02/2024.
//

import SwiftUI
import SwiftData

struct CreateSectionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var icon = ""
    @State private var startTime = Date.now
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        Form {
            // Section for List Name
            Section("List Name") {
                TextField("Enter list name", text: $name)
            }

            // Icon Picker
            Section("Choose Icon") {
                Picker("Icon", selection: $icon) {
                    Label("Home", systemImage: "house").tag("house")
                    Label("Health", systemImage: "heart").tag("heart")
                    Label("Calendar", systemImage: "calendar").tag("calendar")
                    Label("Priority", systemImage: "flag.fill").tag("flag.fill")
                    Label("Sun", systemImage: "sun.max.fill").tag("sun.max.fill")
                    Label("Education", systemImage: "graduationcap").tag("graduationcap")
                    Label("Alert", systemImage: "exclamationmark.3").tag("exclamationmark.3")
                }
                .pickerStyle(.segmented)
            }

            // Start Time
            Section("Start Time") {
                DatePicker("Choose when to start", selection: $startTime)
                    .datePickerStyle(.graphical)
            }

            // Save Button
            Section {
                Button("Save") {
                    saveReminderList()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Create New List")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    // Validation + Save
    private func saveReminderList() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        if trimmedName.isEmpty {
            alertTitle = "Missing Name"
            alertMessage = "Please enter a name for the list."
        } else if icon.isEmpty {
            alertTitle = "Missing Icon"
            alertMessage = "Please select an icon."
        } else {
            let newReminderList = ReminderList(name: trimmedName, iconName: icon, startTime: startTime)
            modelContext.insert(newReminderList)
            do {
                try modelContext.save()
                alertTitle = "Success"
                alertMessage = "Your new reminder list was saved."
                pushNotification(for: newReminderList)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    dismiss()
                }
            } catch {
                alertTitle = "Error"
                alertMessage = "Could not save the reminder list."
            }
        }
        showAlert = true
    }

    // Push Notification Setup
    private func pushNotification(for reminderList: ReminderList) {
        let content = UNMutableNotificationContent()
        content.title = reminderList.name
        content.subtitle = "Starts in 5 minutes"
        content.sound = .default

        // Calculate the trigger time: 5 minutes before the selected start time
        let fiveMinutesBefore = reminderList.startTime.addingTimeInterval(-5 * 60)
        let timeInterval = fiveMinutesBefore.timeIntervalSinceNow

        // Only schedule if the time is still in the future
        guard timeInterval > 0 else {
            print("Start time is less than 5 minutes from now — skipping notification.")
            return
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }

}

#Preview {
    CreateSectionView()
}
