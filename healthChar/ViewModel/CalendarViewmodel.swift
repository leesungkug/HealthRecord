//
//  CalendarViewmodel.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/12/24.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var days: [DayInfo] = []
    @Published var blankDays: [String] = []
    @Published var currentMonth: Date

    init() {
        currentMonth = Date()
        updateMonthData(date: currentMonth)
    }
    
    private func generateDaysForMonth(date: Date) {
            guard let monthInterval = Calendar.current.dateInterval(of: .month, for: date) else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            
            let daysRange = Calendar.current.generateDates(
                inside: monthInterval,
                matching: DateComponents(hour: 0, minute: 0, second: 0)
            )
            
            let firstDayWeekday = Calendar.current.component(.weekday, from: monthInterval.start) - 1 // Adjust for 0 index
            blankDays = Array(repeating: "", count: firstDayWeekday)
            
            self.days = daysRange.map { date in
                DayInfo(date: date, hasWorkout: false)
            }
    }
    
    func updateMonthData(date: Date) {
        self.currentMonth = date
        generateDaysForMonth(date: date)
    }
    
    func moveToNextMonth(delta: Int) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: delta, to: currentMonth)!
        updateMonthData(date: nextMonth)
        let components = Calendar.current.dateComponents([.month, .year], from: nextMonth)
        if let month = components.month, let year = components.year {
            updateDaysWithWorkouts(month: month, year: year)
        }
    }
    
    func updateDaysWithWorkouts(month: Int, year: Int) {
        HealthKitManager.shared.fetchWorkoutsForMonth(month: month, year: year) { [weak self] workouts in
            guard let self = self else { return }
            
            let workoutDays = Set(workouts.map { Calendar.current.startOfDay(for: $0.startDate) })
            
            self.days = self.days.map { dayInfo in
                var updatedDayInfo = dayInfo
                updatedDayInfo.hasWorkout = workoutDays.contains(dayInfo.date)
                return updatedDayInfo
            }
        }
    }

}

extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else { return }
            
            if date < interval.end {
                dates.append(date)
            } else {
                stop = true
            }
        }
        return dates
    }
}

extension Calendar {
    func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
        return self.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}
