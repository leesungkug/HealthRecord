//
//  CalendarView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/12/24.
//

import SwiftUI
import HealthKit

struct DayInfo {
    let date: Date
    var hasWorkout: Bool
}

struct CalendarView: View {
    @ObservedObject var healthViewModel: HealthViewModel
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack{
            HStack {
                CalendarControls(viewModel: viewModel, isNext: false)
                    .padding(.leading)
                Spacer()
                Text(monthString(from: viewModel.currentMonth))
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                CalendarControls(viewModel: viewModel, isNext: true)
                    .padding(.trailing)
            }
            .padding(.top)
            VStack{
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 20) {
                    ForEach(["Sun", "Mon", "Tue", "Wen", "Thu", "Fri", "Sat"], id: \.self) { weekday in
                        Text(weekday)
                            .font(.caption)
                    }
                    ForEach(viewModel.blankDays, id: \.self) { _ in
                        Text("")
                    }
                    ForEach(viewModel.days, id: \.date) { day in
                        NavigationLink(destination: AnalyzeView(viewModel: healthViewModel ,day: day)
                            .background(Color("Background"))) {
                                VStack {
                                    
                                    Image(day.hasWorkout ? "HasHealth" : "NoHealth")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text(dayOfMonth(for: day.date))
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                    }
                    Spacer()
                }
                .padding(10)
                .background(Color("ContentBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView(backName: "Home"))
        .padding()
            
    }

    private func dayOfMonth(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    private func monthString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}


struct CalendarControls: View {
    @ObservedObject var viewModel: CalendarViewModel
    var isNext: Bool
    var body: some View {
        Button(action: {
            viewModel.moveToNextMonth(delta: isNext ? 1 : -1)
        }, label: {
            Image(systemName:  isNext ? "chevron.right" : "chevron.left")
                .frame(width: 24, height: 24)
                .foregroundStyle(.white)
        })
    }
}

//#Preview {
//    CalendarView()
//}
