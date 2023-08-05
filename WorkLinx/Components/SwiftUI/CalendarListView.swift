//
//  CalendarListView.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-04.
//

import SwiftUI

struct CalendarListView: View {
    @ObservedObject var selectedDateManager: SelectedDateManager
    @ObservedObject var shiftsListManger: ShiftsListManager
    
    var body: some View {
        VStack {
            VStack{
                DatePicker("Select a date", selection: $selectedDateManager.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal, 25)
            }
            
            
            ScrollViewReader { scrollView in
                List {
                    ForEach(Array(currentWeekDates(for: selectedDateManager.selectedDate).enumerated()), id: \.element) { index, date in
                        VStack {
                            VStack {
                                Text(formattedDate(date))
                                    .foregroundColor(.primary)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .frame(alignment: .leading)
                                
                                Spacer()
                                
                                let calendar = Calendar.current
                                let shiftsForDate = shiftsListManger.shifts.filter { calendar.isDate($0.date, inSameDayAs: date) }
                                
                                if !shiftsForDate.isEmpty {
                                    ForEach(shiftsForDate, id: \.self) { shift in
                                        if Utils.isAdmin {
                                            ForEach(Utils.workSpaceUsers.filter { shift.employeeIds.contains($0.id) }, id: \.self) { user in
                                                ShiftDetailView(shift: shift, user: user, isOpenShift: false)
                                                    .onTapGesture(perform: {
                                                        print(date)
                                                        print(shift)
                                                        print(user.firstName)
                                                    })
                                            }
                                        } else if shift.employeeIds.count != 0{
                                            ShiftDetailView(shift: shift, user: Utils.user, isOpenShift: false)
                                                .onTapGesture(perform: {
                                                    print(date)
                                                    print(shift)
                                                    print(Utils.user.firstName)
                                                })
                                        }
                                        
                                        if shift.employeeIds.count == 0 {
                                            ShiftDetailView(shift: shift, user: nil, isOpenShift: true)
                                                .onTapGesture(perform: {
                                                    print(date)
                                                    print(shift)
                                                })
                                        }
                                        
                                    }
                                } else {
                                    Text("No shifts for this date")
                                        .foregroundColor(.gray)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Spacer()
                            }
                        }
                        .id(formattedDate(date))
                        
                    }
                    .onChange(of: selectedDateManager.selectedDate) { _ in
                        withAnimation {
                            scrollView.scrollTo(formattedDate(selectedDateManager.selectedDate), anchor: .top)
                        }
                    }
                }
            }.listStyle(PlainListStyle())
        }
        
    }
    
    private func formattedDuration(_ startTime: Date, _ endTime: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startTime, to: endTime)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return "\(hours)h \(minutes)m"
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

struct ShiftDetailView: View {
    let shift: Shift
    let user: User?
    let isOpenShift: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(isOpenShift ? "Open Shift" : (user!.firstName + " " + user!.lastName))
                    .font(.subheadline)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isOpenShift ? Color.red : Color.blue)
                            .opacity(0.2)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(shift.endTime.hoursAndMinutesSince(shift.startTime))
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.mint)
                            .opacity(0.2)
                    )
            }
            
            Text("\(formattedTime(shift.startTime)) - \(formattedTime(shift.endTime))")
                .foregroundColor(.blue)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(white: 0.95)))
    }
    
    private func formattedTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}

class SelectedDateManager: ObservableObject {
    @Published var selectedDate = Date()
}

class ShiftsListManager: ObservableObject {
    @Published var shifts: [Shift] = []
}


extension Date {
    func hoursAndMinutesSince(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date, to: self)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let totalHours = Double(hours) + Double(minutes) / 60.0
        return String(format: "%.1f hrs", totalHours)
    }
}

