//
//  CalendarGridView.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import SwiftUI

struct CalendarGridView: View {
    let weeks: [[CalendarDay]]
    
    var body: some View {
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
                        DayCellView(day: day)
                    }
                }
            }
        }
    }
}

struct DayCellView: View {
    let day: CalendarDay
    
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
        )
    }
}

private extension Date {
    var dayNumber: String {
        let day = Calendar.current.component(.day, from: self)
        return "\(day)"
    }
}

#Preview {
    let today = Date()
    let testMonth = CalendarMonth(monthDate: today)
    let weeks = testMonth.generateWeeks()
    
    CalendarGridView(weeks: weeks)
        .padding()
}
