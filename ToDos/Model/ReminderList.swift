//
//  ReminderList.swift
//  ToDos
//
//  Created by SwiftieDev on 03/02/2024.
//

import Foundation
import SwiftData

@Model
class ReminderList {
    var name: String
    var iconName: String
    var startTime: Date
    @Relationship(deleteRule: .cascade)
    var reminder: [Reminder]

    init(
        name: String = "",
        iconName: String = "list.bullet",
        reminder: [Reminder] = [],
        startTime: Date
    ) {
        self.name = name
        self.iconName = iconName
        self.reminder = reminder
        self.startTime = startTime
    }
}
