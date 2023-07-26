import SwiftUI

struct ContentView: View {
    
    @State private var availableDate = Date()
    @State private var startTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @State private var endTime = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
    @State private var isTimePickerShown = false
    @State private var errorMessage: String? = nil
    @State private var isFormSubmitted = false
    
    // Store the selected date and time values separately
    @State private var selectedDate: Date?
    @State private var selectedStartTime: Date?
    @State private var selectedEndTime: Date?

    // Calculate the range from the current date to the last day of the next month
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDate = Date()
        let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        let endOfNextMonth = calendar.date(byAdding: .day, value: -1, to: nextMonthStart)!
        return currentDate...endOfNextMonth
    }
    
    // Custom binding for endTime with validation
    var endTimeBinding: Binding<Date> {
        Binding<Date>(
            get: { endTime },
            set: { newEndTime in
                // Ensure the selected end time is at least 4 hours after the start time
                let minEndTime = Calendar.current.date(byAdding: .hour, value: 4, to: startTime)!
                if newEndTime >= minEndTime {
                    errorMessage = nil
                    endTime = newEndTime
                } else {
                    errorMessage = "End time should be at least 4 hours after start time."
                }
            }
        )
    }
    
    // Format the date and times
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: selectedDate ?? availableDate)
    }
    
    private var formattedStartTime: String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: selectedStartTime ?? startTime)
    }
    
    private var formattedEndTime: String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: selectedEndTime ?? endTime)
    }

    var body: some View {
        VStack {
            Text("Availability")
                .font(.title)
                .padding(.top, 16)
            
            Form {
                LazyVStack {
                    DatePicker("Available Date", selection: $availableDate, in: dateRange, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: availableDate) { _ in
                            isTimePickerShown = true
                        }
                    
                    if isTimePickerShown {
                        DatePicker("From", selection: $startTime, displayedComponents: .hourAndMinute)
                        
                        DatePicker("To", selection: endTimeBinding, displayedComponents: .hourAndMinute)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                        
                        Button("Submit") {
                            // Handle the submission of data here
                            print("Availability submitted.")
                            isFormSubmitted = true
                            
                            // Store the selected date and time values separately
                            selectedDate = availableDate
                            selectedStartTime = startTime
                            selectedEndTime = endTime
                        }
                    }
                }
            }
            
            // Display the user's input after submitting the form
            if isFormSubmitted {
                Form {
                    Section(header: Text("Selected Availability")) {
                        Text("\(formattedDate) from \(formattedStartTime) To \(formattedEndTime)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        ContentView()
    }
}
