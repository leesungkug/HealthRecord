//
//  ContentView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/5/24.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @ObservedObject var viewModel: HealthViewModel
    @State var anaerobicTime: Int = 0
    @State var cardioTime: Int = 0

     var body: some View {
         NavigationStack{
             ZStack{
                 VStack(alignment: .leading){
                     HStack{
                         Text("\(viewModel.get_today_str(date: Date()))")
                             .font(.system(size: 24))
                             .fontWeight(.black)
                             .foregroundStyle(.white)
                         Spacer()
                         
                         NavigationLink(destination: CalendarView(healthViewModel: viewModel, viewModel: viewModel.calendarViewModel)
                                .background(Color("Background"))
                         ) {
                             Image("calendar_icon")
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 20, height: 20)
                         }.padding(.trailing, 5)
                         NavigationLink(destination: SetGoalView(viewModel: viewModel)
                         ) {
                             Text("목표 설정")
                                 .font(.system(size: 15))
                                 .fontWeight(.black)
                                 .foregroundStyle(Color("Workout"))
                         }
                     }
                     
                     Text("오늘 기록")
                         .padding(.top, 20)
                         .font(.system(size: 20))
                         .fontWeight(.black)
                         .foregroundStyle(.white)
                     ZStack{
                         HStack(alignment: .top){
                             VStack(alignment: .leading){
                                 Text("웨이트 운동")
                                     .font(.system(size: 15))
                                     .fontWeight(.black)
                                 Text("\(anaerobicTime) / \(viewModel.goalAnaerobic) 분")
                                     .font(.system(size: 20))
                                     .fontWeight(.black)
                                     .foregroundStyle(.red)
                                 
                                 Text("유산소 운동")
                                     .padding(.top, 10)
                                     .font(.system(size: 15))
                                     .fontWeight(.black)
                                 Text("\(cardioTime) / \(viewModel.goalCardio) 분")
                                     .font(.system(size: 20))
                                     .fontWeight(.black)
                                     .foregroundStyle(.mint)
                                 Spacer()
                             }
                             .padding()
                             Spacer()
                             NavigationLink {
                                 AnalyzeView(viewModel: viewModel, day: DayInfo(date: Date(), hasWorkout: true))
                                     .background(Color("Background"))
                             } label: {
                                 HeathCharacterView(viewModel: viewModel)
                                     .padding()
                             }
                         }
                     }
                     .padding(.top, 10)
                     .frame(height: 200)
                     .foregroundStyle(.white)
                     .background(Color("ContentBackground"))
                     .cornerRadius(15)
                     HStack{
                         Text("활동 기록")
                             .font(.system(size: 20))
                             .fontWeight(.black)
                             .foregroundStyle(.white)
                         Spacer()
//                         Button {
//                         } label: {
//                             Text("+ 기록추가")
//                                 .font(.system(size: 15))
//                                 .fontWeight(.black)
//                                 .foregroundStyle(.white)
//                         }
                     }
                     .padding(.top, 20)

                     ScrollView {
                         VStack(spacing: 10) {
                             ForEach(viewModel.workouts, id: \.uuid) { workout in
                                 if workout.workoutActivityType.name == "근력 강화 운동"{
                                     NavigationLink {
                                         AnaerobicView(viewModel: viewModel, workout: workout)
                                             .background(Color("Background"))
                                             .navigationTitle(viewModel.get_today_str(date: Date()))

                                     } label: {
                                         WorkoutListView(viewModel: viewModel, workout: workout)
                                             .frame(height: 65)
                                             .background(Color("ContentBackground"))
                                             .cornerRadius(15)
                                     }
                                 }
                                 else{
                                     WorkoutListView(viewModel: viewModel,workout: workout)
                                         .frame(height: 65)
                                         .background(Color("ContentBackground"))
                                         .cornerRadius(15)
                                 }
                             }
                             if viewModel.workouts.isEmpty{
                                 HStack{
                                     Spacer()
                                     Text("오늘 하루도 열심히 운동해봐요")
                                         .font(.system(size: 20, weight: .bold))
                                         .foregroundStyle(.gray)
                                     Spacer()

                                 }
                                 .padding()
                                 .frame(height: 65)
                                 .background(Color("ContentBackground"))
                                 .cornerRadius(15)
                             }
                         }
                     }
                     Spacer()
                 }
                 .padding()
             }
             .background(Color("Background"))
         }
         .onAppear{
             viewModel.fetchDayWorkoutData(date: Date()){
                 (anaerobicTime, cardioTime) = viewModel.getWorkoutTime(date: Date())
             }
         }
         .onChange(of: viewModel.currentDay) { oldValue, newValue in
             viewModel.fetchDayWorkoutData(date: Date()){
                 (anaerobicTime, cardioTime) = viewModel.getWorkoutTime(date: Date())
             }
         }
     }
    
}

//#Preview {
//    HomeView()
//}
