//
//  DailyLog.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import Foundation
import SwiftData

@Model
class DailyLog: Identifiable {
    var date: Date
    var note: String = ""
    
    init(date: Date) {
        self.date = date
    }
    
    func appendNote(newNote: String) {
        note += (note.isEmpty ? "" : "\n") + newNote
    }
    
    func appendChange(oldWeight: Double, newWeight: Double, oldReps: Int, newReps: Int) {
        var changes = [String]()
        
        if oldWeight != newWeight {
            let changeText = oldWeight < newWeight ? "Weight increased from \(oldWeight) to \(newWeight)." : "Weight decreased from \(oldWeight) to \(newWeight)."
            changes.append(changeText)
        }
        
        if oldReps != newReps {
            let changeText = oldReps < newReps ? "Reps increased from \(oldReps) to \(newReps)." : "Reps decreased from \(oldReps) to \(newReps)."
            changes.append(changeText)
        }
        
        note += (note.isEmpty ? "" : "\n") + changes.joined(separator: " ")
    }
    
    static func getOrCreateDailyLog(for date: Date, context: ModelContext, existingLogs: [DailyLog]) -> DailyLog {
        if let existing = existingLogs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            return existing
        } else {
            let newLog = DailyLog(date: date)
            context.insert(newLog)
            return newLog
        }
    }
}
