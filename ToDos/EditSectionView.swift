//
//  EditSectionView.swift
//  ToDos
//
//  Created by DEEPAK BEHERA on 18/07/25.
//

import SwiftUI
import SwiftData

struct EditSectionView: View {
    @Bindable var reminderList: ReminderList
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var originalName: String
    @State private var originalIcon: String

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showExitConfirm = false

    init(reminderList: ReminderList) {
        self._reminderList = Bindable(reminderList)
        _originalName = State(initialValue: reminderList.name)
        _originalIcon = State(initialValue: reminderList.iconName)
    }

    var body: some View {
        Form {
            // Section Name Input
            Section("List Name") {
                TextField("Enter list name", text: $reminderList.name)
            }

            // Icon Picker Section
            Section("Select Icon") {
                Picker("Icon", selection: $reminderList.iconName) {
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

            // Save Button Section
            Section {
                Button("Save") {
                    validateAndSave()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Edit Section")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled(hasUnsavedChanges)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    if hasUnsavedChanges {
                        showExitConfirm = true
                    } else {
                        dismiss()
                    }
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .confirmationDialog(
            "You have unsaved changes. Are you sure you want to go back?",
            isPresented: $showExitConfirm,
            titleVisibility: .visible
        ) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    var hasUnsavedChanges: Bool {
        reminderList.name != originalName || reminderList.iconName != originalIcon
    }

    private func validateAndSave() {
        let trimmedName = reminderList.name.trimmingCharacters(in: .whitespaces)
        let icon = reminderList.iconName

        if trimmedName.isEmpty {
            alertTitle = "Missing Name"
            alertMessage = "Please enter a name for the list."
        } else if icon.isEmpty {
            alertTitle = "No Icon"
            alertMessage = "Please select an icon."
        } else {
            do {
                try modelContext.save()
                originalName = reminderList.name
                originalIcon = reminderList.iconName
                alertTitle = "Saved!"
                alertMessage = "Your reminder list has been updated."
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    dismiss()
                }
            } catch {
                alertTitle = "Error"
                alertMessage = "Something went wrong while saving."
            }
        }

        showAlert = true
    }
}
