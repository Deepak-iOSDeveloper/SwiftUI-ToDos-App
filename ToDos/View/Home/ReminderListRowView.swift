//
//  ReminderListRowView.swift
//  ToDos
//
//  Created by SwiftieDev on 03/02/2024.
//

import SwiftUI
import SwiftData

struct ReminderListRowView: View {
    @Bindable var reminderList: ReminderList
    
    var body: some View {
        HStack {
            listIcon
            Text(reminderList.name)
            Spacer()
            Text("\(reminderList.reminder.count)")
        }
    }
    
    var listIcon: some View {
        ZStack {
            Circle()
                .fill(Color(uiColor: .tertiarySystemFill))
                .frame(width: 27)
            
            Image(systemName: reminderList.iconName)
                .font(.footnote)
                .foregroundStyle(.primary)
                .bold()
        }
    }
    
    
}
