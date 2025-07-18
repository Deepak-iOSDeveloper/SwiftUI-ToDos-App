//
//  ReminderListView.swift
//  ToDos
//
//  Created by SwiftieDev on 03/02/2024.
//

import SwiftUI
import SwiftData

struct ReminderListView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var reminderList: ReminderList
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            headerView
            
            List {
                Section("Reminders") {
                    ForEach(reminderList.reminder) { reminder in
                        ReminderRowView(reminder: reminder)
                    }
                    .onDelete(perform: delete)
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle(reminderList.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    reminderList.reminder.append(Reminder(name: ""))
                } label: {
                    Label("New Reminder", systemImage: "plus.circle.fill")
                        .font(.system(.body, design: .rounded).bold())
                        .foregroundColor(.primary)
                }

                Spacer()

                Button {
                    saveEachReminder()
                } label: {
                    Label("Save", systemImage: "tray.and.arrow.down.fill")
                        .font(.system(.body, design: .rounded).bold())
                        .foregroundColor(.blue)
                }
            }
        }
    }

    var headerView: some View {
        HStack {
            Text(reminderList.name)
                .font(.system(.largeTitle, design: .rounded).bold())
            Spacer()
            Text("\(reminderList.reminder.count)")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    func saveEachReminder() {
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save reminders: \(error.localizedDescription)")
        }
    }

    func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            reminderList.reminder.remove(at: index)
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete reminder: \(error.localizedDescription)")
        }
    }
}
