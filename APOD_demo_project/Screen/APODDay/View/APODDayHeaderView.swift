//
//  APODDayHeaderView.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 30/04/2026.
//

import SwiftUI

extension APODDayView {
    
    struct APODDayHeaderView: View {
        
        @Binding var selectedDate: Date
        
        var canGoNextDate: Bool {
            if let date = selectedDate.addingDays(1) {
                return date <= Date()
            }
            return false
        }
        
        var body: some View {
            
            HStack {
                Button {
                    if let newDate = selectedDate.addingDays(-1) {
                        selectedDate = newDate
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.accent)
                        .bold()
                }
                
                DatePicker("Select Date",
                           selection: $selectedDate,
                           in: ...Date(),
                           displayedComponents: .date)
                .foregroundStyle(.accent)
                .font(.title)
                .bold()
                .datePickerStyle(.automatic)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button {
                    if let newDate = selectedDate.addingDays(1),
                       // prevent user to load future no exist APOD info
                       newDate <= Date() {
                        selectedDate = newDate
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.accent)
                        .bold()
                }
                .disabled(!canGoNextDate)
                .opacity(canGoNextDate ? 1 : 0.3)
            }
            .foregroundStyle(.secondary)
            .background(Color(.secondarySystemBackground))
        }
    }
}


