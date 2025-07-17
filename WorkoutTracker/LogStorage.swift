//
//  LogStorage.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import Foundation

class LogStorage: ObservableObject {
    // published makes sure views watching this will update whenever it changes
    // private(set) makes it readable from the outside but only writeable from the insde
    // obviously creating a map of Date: DailyLog
    @Published private(set) var logs: [Date: DailyLog] = [:]
    
    private let fileName = "dailyLogs.json"
    
    // load logs every time class is loaded. if empty or corrupt will correctly do nothing
    init() {
        loadLogs()
    }
    
    // Apple's desired way/location of accessing/placing app files on user's device
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // add fileName to user file location path
        return paths[0].appendingPathComponent(fileName)
    }
    
    
    private func loadLogs() {
        // tries to read contents of log file
        let url = getFileURL()
        guard let data = try? Data(contentsOf: url) else { return }
        
        // attempts to "decode" it as an array of DailyLog objects. basically creating the map of Date: DailyLog from file
        if let decoded = try? JSONDecoder().decode([DailyLog].self, from: data) {
            logs = Dictionary(uniqueKeysWithValues: decoded.map { ($0.date.stripTime(), $0) })
        }
    }
    
    // gets path again, creates an array out of the current variable values, encodes the array to the JSON file
    func saveLogs() {
        let url = getFileURL()
        let arrayToSave = Array(logs.values)
        if let data = try? JSONEncoder().encode(arrayToSave) {
            try? data.write(to: url)
        }
    }
    
    // main save method to add, update or delete notes
    func updateLog(for date: Date, with note: String) {
        // strip time out of date so logs are only saved per date and not time
        let strippedDate = date.stripTime()
        
        // if note is empty/just whitespace, log is automatically deleted
        if note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            logs.removeValue(forKey: strippedDate)
        } else { // otherwise, add log
            let log = DailyLog(date: strippedDate, note: note)
            logs[strippedDate] = log
        }
        
        // save logs
        saveLogs()
    }
    
    // obvious getter, returns map with date as key, so returns individual log
    func getLog(for date: Date) -> DailyLog? {
        return logs[date.stripTime()]
    }
}

// strips time off dates. no need to save time since logs are saved per day, dont want several different logs a day
extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
}
