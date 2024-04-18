//
//  WorkoutListView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/15/24.
//

import SwiftUI
import HealthKit

struct WorkoutListView: View {
    @ObservedObject var viewModel: HealthViewModel
    var workout: HKWorkout
    var isDetailView: Bool = false
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(workout.workoutActivityType.name)
                    .font(.system(size: isDetailView ? 20 : 15, weight: .bold))
                    .foregroundStyle(isDetailView ? .white :Color("Workout"))
                Text("\(getDateKoTime(nowDate: workout.startDate)) ~ \(getDateKoTime(nowDate: workout.endDate))")
                    .font(.system(size: isDetailView ? 16 : 12, weight: .bold))
                    .foregroundStyle(.gray)
            }
            .padding(.leading)

//            Text(String(workout.workoutActivityType.rawValue))
//                .font(.system(size:15, weight: .bold))
//                .foregroundStyle(Color("Workout"))
            Spacer()
            VStack(alignment: .trailing){
                if !isDetailView && workout.workoutActivityType.name == "근력 강화 운동" && viewModel.customWorkouts[workout.uuid] != nil{
                    if viewModel.customWorkouts[workout.uuid]!.parts.isEmpty{
                        Text("부위 설정 X")
                            .padding(.trailing)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.gray)
                    }
                    else{
                        Text("부위 설정 O")
                            .padding(.trailing)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.gray)
                    }
                    //code optimization!!
                }
                Text("\(Int(workout.duration / 60))M")
                    .padding(.trailing)
                    .font(.system(size: isDetailView ? 36 : 15, weight: .bold))
                    .foregroundStyle(isDetailView ? .red :Color("Workout"))
            }
        }
    }
    
    func getDateKoTime(nowDate: Date) -> String{
            
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "ahh:mm" //
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        let convertNowStr = myDateFormatter.string(from: nowDate)
        return convertNowStr
    }
    
    
}

//#Preview {
//    WorkoutListView()
//}
