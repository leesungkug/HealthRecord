//
//  HealthKitManager.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/12/24.
//

import HealthKit

class HealthKitManager {
    
    static let shared = HealthKitManager()
    private var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = healthStore else { return completion(false) }
        
        //        let allTypes: Set = [
        //            HKQuantityType.workoutType(),
        //            HKQuantityType(.activeEnergyBurned),
        //            HKQuantityType(.distanceCycling),
        //            HKQuantityType(.distanceWalkingRunning),
        //            HKQuantityType(.distanceWheelchair),
        //            HKQuantityType(.heartRate)
        //        ]
        
//        let typesToShare: Set = [HKObjectType.workoutType()]
        let typesToRead: Set = [HKObjectType.workoutType()]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            completion(success)
        }
    }
    
    func fetchTotalWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        
        guard let healthStore = healthStore else {
            completion([])
            return
        }
        let workoutType = HKObjectType.workoutType()
        let query = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            DispatchQueue.main.async {
                completion(samples as? [HKWorkout] ?? [])
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayWorkouts(for date: Date, completion: @escaping ([HKWorkout]?) -> Void) {
        
        guard let healthStore = healthStore else {
            completion([])
            return
        }
        let workoutType = HKObjectType.workoutType()
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching workouts: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(workouts)
        }
        
        healthStore.execute(query)
    }
    
    func fetchWeekWorkouts(from startDate: Date, to endDate: Date, completion: @escaping ([HKWorkout]?) -> Void) {
        
        guard let healthStore = healthStore else {
            completion([])
            return
        }
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching workouts: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(workouts)
        }
        
        healthStore.execute(query)
    }
    
    func fetchWorkoutsForMonth(month: Int, year: Int, completion: @escaping ([HKWorkout]) -> Void) {
        
        guard let healthStore = healthStore else {
            completion([])
            return
        }
        let workoutType = HKObjectType.workoutType()
        let dateComponents = DateComponents(year: year, month: month)
        guard let startDate = Calendar.current.date(from: dateComponents),
              let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) else {
            completion([])
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            DispatchQueue.main.async {
                completion(samples as? [HKWorkout] ?? [])
            }
        }
        healthStore.execute(query)
    }
}

extension HKWorkoutActivityType {
        var name: String {
        switch self {
            case .running: return "Running"
            case .cycling: return "사이클링"
            case .walking: return "실내 걷기"
            case .gymnastics: return "gymnastics"
            case .swimming: return "수영"
            case .coreTraining: return "운동"
            case .traditionalStrengthTraining: return "근력 강화 운동"
            default: return "Other"
        }
    }
}

