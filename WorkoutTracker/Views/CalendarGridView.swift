//
//  CalendarGridView.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import SwiftUI
import SwiftData

struct CalendarGridView: View {
    @Bindable var exercise: Exercise
    
    @State private var currentMonthOffset = 0
    @State private var selectedDate: Date? = nil
    @State private var highlightDates: Set<Date> = []
    
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
                let month = CalendarMonth(monthDate: targetDate, highlightDates: highlightDates)
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
                                DayCellView(day: day, isHighlighted: highlightDates.contains(Calendar.current.startOfDay(for: day.date)), selectedDate: $selectedDate)
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
                DayLogView(exercise: exercise, date: date) { didAddLog in
                    let day = Calendar.current.startOfDay(for: date)
                    if didAddLog {
                        highlightDates.insert(day)
                    } else {
                        highlightDates.remove(day)
                    }
                }
                .interactiveDismissDisabled(true)
            }
            .onAppear {
                highlightDates = Set(exercise.progressHistory.map { Calendar.current.startOfDay(for: $0.date)})
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
    let isHighlighted: Bool
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack {
            Text("\(day.date.dayNumber)")
                .font(.body)
                .foregroundColor(day.isInCurrentMonth ? .primary : .gray)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(day.hasLog == true ? Color.blue.opacity(0.4) : Color.clear)
                )
            }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 6)
            .fill(Color(.systemBackground))
        )
        .onTapGesture {
            selectedDate = day.date
        }
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
    CalendarGridView(exercise: Exercise(name: "", sets: 0, minReps: 0, maxReps: 0, warmupSets: 0, progressHistory: []))
        .padding()
}
