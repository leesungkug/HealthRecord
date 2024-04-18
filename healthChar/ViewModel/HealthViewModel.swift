//
//  HealthModel.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/8/24.
//

import SwiftUI
import HealthKit
import CoreData

enum Part: String, CaseIterable{
    case arm = "팔"
    case back = "등"
    case chest = "가슴"
    case abdomen = "복부"
    case shoulder = "어깨"
    case leg = "하체"
}

enum Workout: String, CaseIterable{
    case Cardio  = "유산소"
    case Anaerobic = "무산소"
}

struct CustomWorkout {
    var parts: [Part]
    var comment: String
}

class HealthViewModel: ObservableObject{
    
    @Published var workouts: [HKWorkout] = []
    @Published var currentDay: Date = Date()
    @Published var goalCardio: Int = 30
    @Published var goalAnaerobic: Int = 30
    @Published var anaerobicTime: Int = 0
    @Published var cardioTime: Int = 0
    @Published var customWorkouts: [UUID: CustomWorkout] = [:]
    @Published var calendarViewModel = CalendarViewModel()
    @Published var totalDurationForPart: [Part: Int] = [:]
    @Published var weekDurationForPart: [Part: Int] = [:]
    
    let healthKitManager = HealthKitManager()
    
    init() {
        let now = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        loadCustomWorkouts()
        calendarViewModel.updateDaysWithWorkouts(month: month, year: year)
    }
    
    func storeWorkoutData(){
        for workout in workouts{
            if customWorkouts[workout.uuid] == nil && workout.workoutActivityType.name == "근력 강화 운동" {
                customWorkouts[workout.uuid] = CustomWorkout(parts: [], comment: "")
            }
        }
    }
    
    func fetchTotalWorkoutData() {
        HealthKitManager.shared.fetchTotalWorkouts { [weak self] workouts in
            self?.workouts = workouts
            self?.storeWorkoutData()
        }
    }
    
    func fetchDayWorkoutData(date: Date, completion: @escaping () -> Void) {
        HealthKitManager.shared.fetchTodayWorkouts(for: date) { [weak self] workouts in
            DispatchQueue.main.async {
                guard let workouts = workouts else {
                    self?.workouts = []
                    return
                }
                
                self?.workouts = workouts
                self?.storeWorkoutData()
                completion()
            }
        }
    }
    
    
    
    func setGoal(Anaerobic:Int, Cardio: Int){
        self.goalAnaerobic = Anaerobic
        self.goalCardio = Cardio
    }
    
    func setPart(uuid: UUID, part: Part) -> Bool{
        if var workout = customWorkouts[uuid] {
            if !workout.parts.contains(part) {
                workout.parts.append(part)
                customWorkouts[uuid] = workout
                return true
            } else {
                workout.parts = workout.parts.filter(){$0 != part}
                customWorkouts[uuid] = workout
                return false
            }
        }
        return false
    }
    
    func getWorkoutTime(date: Date) -> (anaerobicTime: Int, cardioTime: Int) {

        anaerobicTime = 0
        cardioTime = 0
        
        for workout in workouts {
            if Calendar.current.isDate(workout.startDate, inSameDayAs: date) {
                if workout.workoutActivityType.name == "근력 강화 운동" {
                    anaerobicTime += Int(workout.duration / 60)
                } else {
                    cardioTime += Int(workout.duration / 60)
                }
            }
        }
        return (anaerobicTime, cardioTime)
    }
    
    func fetchPartWorkout() -> [Part] {
        var partWorkout: [Part] = []
        for workout in workouts {
            if workout.workoutActivityType.name == "근력 강화 운동" {
                guard let customWorkout = customWorkouts[workout.uuid] else{
                    return []
                }
                for part in customWorkout.parts{
                    if !partWorkout.contains(part){
                        partWorkout.append(part)
                    }
                }
            }
        }
        return partWorkout
    }
    
    func get_today_str(date: Date) -> String{
        let calendar = Calendar.current
        var str = ""
        str += String(calendar.component(.month, from: date))
        str += "월 "
        str += String(calendar.component(.day, from: date))
        str += "일 "
        str += get_weekday(weekday: calendar.component(.weekday, from: date))
//        str += String(calendar.component(.weekOfYear, from: now))
//        str += "주)"
        return str
    }
    
    func get_weekday(weekday: Int) -> String {
        switch weekday
        {
            case 1: return "일요일"
            case 2: return "월요일"
            case 3: return "화요일"
            case 4: return "수요일"
            case 5: return "목요일"
            case 6: return "금요일"
            case 7: return "토요일"
            default: return "오류"
        }
    }
    
    func checkWorkoutPart(part: Part) -> Bool{
        var isSelection: Bool = false
        
        for workout in workouts {
            if workout.workoutActivityType.name == "근력 강화 운동"{
                guard let customWorkout = customWorkouts[workout.uuid]else
                { 
                    print("error")
                    continue
                }
                if customWorkout.parts.contains(part){
                    isSelection = true
                }
            }
        }
        return isSelection
    }
    
    func fetchWorkoutDuration(for part: Part, on date: Date) {
        var totalMinDuration: Int = 0
        HealthKitManager.shared.fetchTodayWorkouts(for: date) { [weak self] workouts in
            DispatchQueue.main.async {
                guard let workouts = workouts, !workouts.isEmpty else {
                    self?.totalDurationForPart[part] = totalMinDuration
                    return
                }

                for workout in workouts {
                    if workout.workoutActivityType.name == "근력 강화 운동" {
                        guard let customWorkout = self?.customWorkouts[workout.uuid] else {
                            return
                        }
                        if customWorkout.parts.contains(part) {
                            totalMinDuration += Int(workout.duration / 60) / customWorkout.parts.count
                        }
                    }
                }
                self?.totalDurationForPart[part] = totalMinDuration
            }
        }
    }
    func startAndEndOfWeek(for date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date)!
        return (start: weekInterval.start, end: weekInterval.end)
    }
    
    func fetchWorkoutDataForWeek(containing date: Date) {
        let (start, end) = startAndEndOfWeek(for: date)
        
        for part in Part.allCases {
            totalDurationForPart[part] = 0
        }
        
        fetchWeekWorkoutPart(from: start, to: end)
    }
    
    func fetchWeekWorkoutPart(from startDate: Date, to endDate: Date) {

        HealthKitManager.shared.fetchWeekWorkouts(from: startDate, to: endDate) { [weak self] workouts in
            DispatchQueue.main.async {
                guard let self = self, let workouts = workouts else { return }
                
                var partDurations = [Part: Int]()
                
                for workout in workouts {
                    guard workout.workoutActivityType.name == "근력 강화 운동",
                          let customWorkout = self.customWorkouts[workout.uuid] else {
                        continue
                    }
                    
                    for part in customWorkout.parts {
                        let duration = Int(workout.duration / 60) / customWorkout.parts.count
                        partDurations[part, default: 0] += duration
                    }
                }
                
                for (part, duration) in partDurations {
                    self.weekDurationForPart[part, default: 0] = duration
                }
            }
        }
    }
}

extension HealthViewModel {
    func saveCustomWorkouts() {
        let context = persistentContainer.viewContext
        for (uuid, customWorkout) in customWorkouts {
            let request: NSFetchRequest<CustomWorkoutEntity> = CustomWorkoutEntity.fetchRequest()
            request.predicate = NSPredicate(format: "uuid == %@", uuid.uuidString)
            
            let results = try? context.fetch(request)
            let entity = results?.first ?? CustomWorkoutEntity(context: context)
            entity.uuid = uuid.uuidString
            entity.parts = customWorkout.parts.map { $0.rawValue }.joined(separator: ",")
            entity.comment = customWorkout.comment
        }
        do {
            try context.save()
        } catch {
            print("Failed to save custom workouts: \(error)")
        }
    }
    
    func loadCustomWorkouts() {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<CustomWorkoutEntity> = CustomWorkoutEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            customWorkouts = Dictionary(uniqueKeysWithValues: results.compactMap { result -> (UUID, CustomWorkout)? in
                guard let uuid = UUID(uuidString: result.uuid ?? "") else {
                    return nil
                }
                let parts = result.parts?.split(separator: ",").compactMap { Part(rawValue: String($0)) } ?? []
                return (uuid, CustomWorkout(parts: parts, comment: result.comment ?? ""))
            })
        } catch {
            print("Failed to fetch custom workouts: \(error)")
        }
    }
}

