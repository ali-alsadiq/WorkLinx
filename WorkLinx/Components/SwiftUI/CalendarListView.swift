//
//  CalendarListView.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-04.
//

import SwiftUI

struct CalendarListView: View {
    @ObservedObject var selectedDateManager: SelectedDateManager
    @State private var notes: [Date: String] = [:]
    
    
    var events: [Event]
    
    var body: some View {
        VStack{
            
            DatePicker("Select a date", selection: $selectedDateManager.selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding(.horizontal, 20)
            
            List {
                ForEach(currentWeekDates(for: selectedDateManager.selectedDate), id: \.self) { date in
                    VStack {
                        HStack {
                            Text(formattedDate(date))
                                .foregroundColor(.primary)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            if notes[date] != nil {
                                Text("•")
                                    .foregroundColor(.blue)
                                    .padding(.leading, 4)
                            }
                        }
                        if let note = notes[date] {
                            Text(note)
                        } else {
                            Text("No notes")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    private func currentWeekDates(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToSubtract = (calendar.firstWeekday - weekday - 7) % 7
        
        guard let startOfWeek = calendar.date(byAdding: .day, value: daysToSubtract, to: date) else {
            return []
        }
        
        var weekDates: [Date] = []
        var currentDate = startOfWeek
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let baseDateMonth = formatter.string(from: date)
        
        for _ in 0..<7 {
            let currentDateMonth = formatter.string(from: currentDate)
            
            if currentDateMonth == baseDateMonth {
                weekDates.append(currentDate)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return weekDates
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

struct Event {
    let date: Date
    let notes: String
}

class SelectedDateManager: ObservableObject {
    @Published var selectedDate = Date()
}
