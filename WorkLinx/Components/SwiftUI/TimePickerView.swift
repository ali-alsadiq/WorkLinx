//
//  TimePickerView.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-05.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: Date
    var time: String
    
    var body: some View {
        DatePicker(
            time,
            selection: $selectedTime,
            displayedComponents: [.hourAndMinute]
        )
        .datePickerStyle(.graphical)
        .padding(.horizontal, 25)
    }
}
