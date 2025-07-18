//
//  ContentView.swift
//  ToDos
//
//  Created by SwiftieDev on 03/02/2024.
//

import SwiftUI
import SwiftData
import UserNotifications

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var reminderList: [ReminderList]
    @State private var path = [ReminderList]()
    @State private var wantToCreate = false

    let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
                    // Grid Section (Top Cards)
                    Section {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(reminderList.prefix(4)) { reminders in
                                Button {
                                    path.append(reminders)
                                } label: {
                                    ListCardView(reminderList: reminders)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())

                    // Full List Section
                    Section {
                        ForEach(reminderList) { reminders in
                            NavigationLink {
                                ReminderListView(reminderList: reminders)
                            } label: {
                                ReminderListRowView(reminderList: reminders)
                            }
                            .listRowInsets(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 15))
                        }
                        .onDelete(perform: delete)
                    } header: {
                        Text("My Lists")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                            .padding(.top, 10)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .background(.background)
            .onAppear(perform: requestNotification)
            .navigationTitle("Reminders")
            .toolbar {
                // Add Section Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        wantToCreate = true
                    } label: {
                        Label("Add Section", systemImage: "plus")
                    }
                }

                // Settings Button
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .sheet(isPresented: $wantToCreate) {
                CreateSectionView()
            }
            .overlay {
                if reminderList.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("No Reminders", systemImage: "list.bullet.rectangle.portrait")
                        },
                        description: {
                            Text("Start adding reminders to see your list.")
                        },
                        actions: {
                            Button {
                                wantToCreate = true
                            } label: {
                                Label("Add New", systemImage: "plus")
                            }
                        }
                    )
                    .offset(y: -60)
                }
            }
            .navigationDestination(for: ReminderList.self) { list in
                EditSectionView(reminderList: list)
            }
        }
    }

    // Notification Permission
    func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }

    // Delete ReminderList
    func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            let item = reminderList[index]
            modelContext.delete(item)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: ReminderList.self, inMemory: true)
}
