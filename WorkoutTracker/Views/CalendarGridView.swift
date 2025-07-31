//
//  CalendarGridView.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import SwiftUI

struct CalendarGridView: View {
    @State private var currentMonthOffset = 0
    @State private var selectedDate: Date? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: { currentMonthOffset -= 1 }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    
                    Text(formattedMonthTitle(currentMonthOffset: currentMonthOffset))
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: { currentMonthOffset += 1 }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
                let targetDate = Calendar.current.date(byAdding: .month, value: currentMonthOffset, to: Date())!
                let month = CalendarMonth(monthDate: targetDate)
                let weeks = month.generateWeeks()
                
                VStack(spacing: 4) {
                    // weekday headers
                    HStack {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // calendar grid
                    ForEach(weeks.indices, id: \.self) { weekIndex in
                        HStack(spacing: 4) {
                            ForEach(weeks[weekIndex]) { day in
                                DayCellView(day: day, selectedDate: $selectedDate)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedDate) { date in
                DayLogView(date: date)
            }
        }
    }
}

func formattedMonthTitle(currentMonthOffset: Int) -> String {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .month, value: currentMonthOffset, to: Date())
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter.string(from: date!)
}

struct DayCellView: View {
    let day: CalendarDay
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack {
            Text("\(day.date.dayNumber)")
                .font(.body)
                .foregroundColor(day.isInCurrentMonth ? .primary : .gray)
            
            if day.hasLog ?? false {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 6)
            .fill(Color(.systemBackground))
            .onTapGesture {
                selectedDate = day.date
            }
        )
    }
}

extension Date: @retroactive Identifiable {
    public var id: Date { self }
    
    var dayNumber: String {
        let day = Calendar.current.component(.day, from: self)
        return "\(day)"
    }
}

#Preview {
    let today = Date()
    
    CalendarGridView()
        .padding()
}
