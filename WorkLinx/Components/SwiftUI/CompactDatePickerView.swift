//
//  CompactDatePickerView.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-05.
//

import SwiftUI


struct CompactDatePickerView: View {
    @Binding var selectedDate: Date
    var label: String
    
    var body: some View {
        DatePicker(
            label,
            selection: $selectedDate,
            displayedComponents: [.date]
        )
        .datePickerStyle(.compact)
        .padding(.horizontal, 25)
        .environment(\.locale, Locale(identifier: "en_CA"))
    }
}
