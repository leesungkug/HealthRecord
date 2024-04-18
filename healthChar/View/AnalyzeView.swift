//
//  AnalyzeView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/16/24.
//

import SwiftUI

struct AnalyzeView: View {
    @ObservedObject var viewModel: HealthViewModel
    var day: DayInfo
    let calendar = Calendar.current
    @State var selectedDay: Date?
    
    var body: some View {
        VStack {
            HStack {
                ForEach(daysInWeek(day.date), id: \.self) { date in
                    Button(action: {
                        selectedDay = date
                        viewModel.fetchDayWorkoutData(date: date) {
//                            viewModel.fetchPartWorkout()
                        }
                    }) {
                        Text("\(date, formatter: dateFormatter)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .padding(8)
                            .background(calendar.isDate(date, inSameDayAs: selectedDay ?? Date()) ? Color.blue : Color.clear)
                            .cornerRadius(24)
                    }
                }
            }
            .padding(5)
            ZStack{
                HeathCharacterView(viewModel: viewModel, isAnalyze: true)
                VStack{
                    HStack{
                        AnalyzeImgView(viewModel: viewModel, partType: .arm, date: $selectedDay)
                            .padding(.leading, 55)
                        Spacer()
                        AnalyzeImgView(viewModel: viewModel, partType: .shoulder, date: $selectedDay)
                            .padding(.trailing, 55)
                    }
                    HStack{
                        AnalyzeImgView(viewModel: viewModel, partType: .back, date: $selectedDay)
                            .padding(.leading, 5)
                        Spacer()
                        AnalyzeImgView(viewModel: viewModel, partType: .chest, date: $selectedDay)
                            .padding(.trailing, 5)
                    }
                    .padding(.top, 10)
                    HStack{
                        AnalyzeImgView(viewModel: viewModel, partType: .abdomen, date: $selectedDay)
                            .padding(.leading, 55)
                        Spacer()
                        AnalyzeImgView(viewModel: viewModel, partType: .leg, date: $selectedDay)
                            .padding(.trailing, 55)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .background(Color("CharBack"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            HStack{
                Text("활동 기록")
                    .font(.system(size: 20))
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                Spacer()
//                Button {
//                } label: {
//                    Text("+ 기록추가")
//                        .font(.system(size: 15))
//                        .fontWeight(.black)
//                        .foregroundStyle(.white)
//                }
            }
            .padding(.top, 20)
            
            ScrollView (showsIndicators: false){
                VStack(spacing: 10) {
                    ForEach(viewModel.workouts, id: \.uuid) { workout in
                        if workout.workoutActivityType.name == "근력 강화 운동"{
                            NavigationLink {
                                AnaerobicView(viewModel: viewModel, workout: workout)
                                    .background(Color("Background"))
                                    .navigationTitle(viewModel.get_today_str(date: day.date))

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
                }
            }
            .frame(height: 250)
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView(backName: "뒤로가기"))
        .navigationTitle("\(titleForWeekContaining(date: day.date))")
        .onAppear {
            if selectedDay == nil{
                selectedDay = day.date
            }
            viewModel.fetchDayWorkoutData(date: selectedDay!) {
            }
        }
    }
    
    func titleForWeekContaining(date: Date) -> String {
        let weekDates = daysInWeek(date)
        if let firstDate = weekDates.first, let lastDate = weekDates.last {
            let firstDateString = titleDateFormatter.string(from: firstDate)
            let lastDateString = titleDateFormatter.string(from: lastDate)
            return "\(firstDateString) ~ \(lastDateString)"
        } else {
            return "Invalid date range"
        }
    }

    func daysInWeek(_ date: Date) -> [Date] {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
                return []
            }
            var dates: [Date] = []
            var currentDate = weekInterval.start
            
            while currentDate < weekInterval.end {
                dates.append(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            return dates
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    var titleDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

struct AnalyzeImgView: View {
    @ObservedObject var viewModel: HealthViewModel
    var partType: Part
    @State var isSelected: Bool = false
    @Binding var date: Date?
    
    var body: some View {
        VStack{
            VStack{
                VStack{
                    Image(getImgStr(type: partType))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                }
                .frame(width: 60, height: 60)
                .background(isSelected ? Color("Workout") : Color("AnalyzeBackground"))
                .clipShape(Circle())
                Text("\(viewModel.totalDurationForPart[partType, default: 0])M")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundStyle(isSelected ? Color("Workout") : .white)
                Text("\(viewModel.weekDurationForPart[partType, default: 0])M / Week")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .onAppear{
                isSelected = viewModel.checkWorkoutPart(part: partType)
                viewModel.fetchWorkoutDuration(for: partType, on: date ?? Date())
                viewModel.fetchWorkoutDataForWeek(containing: date ?? Date())
            }
            .onChange(of: viewModel.workouts) { oldValue, newValue in
                isSelected = viewModel.checkWorkoutPart(part: partType)
                viewModel.fetchWorkoutDuration(for: partType, on: date ?? Date())
                viewModel.fetchWorkoutDataForWeek(containing: date ?? Date())
            }
        }
    }
}
