//
//  ListCardView.swift
//  ToDos
//
//  Created by SwiftieDev on 03/02/2024.
//

import SwiftUI
import SwiftData

struct ListCardView: View {
    @Bindable var reminderList: ReminderList

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                listIcon
                Spacer()
                Text("\(reminderList.reminder.count)")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .padding(.trailing)
            }
            Text(reminderList.name)
                .font(.system(.body, design: .rounded, weight: .bold))
                .foregroundColor(.secondary)
        }
        .padding(5)
        .padding(.horizontal, 5)
        .background(Color(UIColor.tertiarySystemFill))
        .cornerRadius(10)
    }

    var listIcon: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor) 
                .frame(width: 27)

            Image(systemName: reminderList.iconName)
                .font(.footnote)
                .foregroundStyle(.white)
                .bold()
        }
    }

}
