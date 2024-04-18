//
//  AnaerobicView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/15/24.
//

import SwiftUI
import HealthKit

struct AnaerobicView: View {
    @ObservedObject var viewModel: HealthViewModel
    var workout: HKWorkout
    @State var memo: String = ""
    @State var isEditing = false
    @FocusState var inFocus: Int?

    var body: some View {
        ScrollViewReader { sp in
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    WorkoutListView(viewModel: viewModel, workout: workout, isDetailView: true)
                        .frame(height: 100)
                        .background(Color("ContentBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    Text("운동 부위")
                        .font(.system(size: 20))
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                    HStack(spacing: 50){
                        SelectImgView(viewModel: viewModel, workoutUUID: workout.uuid, partType: .arm)
                        SelectImgView(viewModel: viewModel, workoutUUID: workout.uuid,partType: .back)
                        SelectImgView(viewModel: viewModel, workoutUUID: workout.uuid,partType: .chest)
                    }
                    .padding(.top, 10)
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                    HStack(spacing: 50){
                        SelectImgView(viewModel: viewModel, workoutUUID: workout.uuid,partType: .abdomen)
                        SelectImgView(viewModel: viewModel, workoutUUID: workout.uuid,partType: .shoulder)
                        SelectImgView(viewModel: viewModel, workoutUUID: workout.uuid,partType: .leg)
                    }
                    .padding(.top, 10)
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                    
                    HStack(alignment: .center){
                        Text("운동 메모")
                            .font(.system(size: 20))
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                        Spacer()
                        
                        Button {
                            if isEditing {
                                viewModel.customWorkouts[workout.uuid]!.comment = memo
                                isEditing = false
                            } else {
                                isEditing = true
                            }
                        } label: {
                            Text(isEditing ? "저장" : "수정")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundStyle(Color("Workout"))
                        }
                    }
                    .padding(.top, 20)

                    TextEditor(text: $memo)
                        .id(1)
                        .frame(height: 200)
                        .disabled(!isEditing)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .background(Color("ContentBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .scrollDismissesKeyboard(.never)
            .onChange(of: inFocus) { old, new in
                withAnimation {
                    sp.scrollTo(new)
                }
            }
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView(backName: "뒤로가기"))
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            if let savedMemo = viewModel.customWorkouts[workout.uuid]?.comment{
                memo = savedMemo
            }
        }
    }
}

struct SelectImgView: View {
    @ObservedObject var viewModel: HealthViewModel
    var workoutUUID: UUID
    var partType: Part
    @State var isSelected: Bool = false
    
    var body: some View {
        VStack{
            Button(action: {
                isSelected = viewModel.setPart(uuid: workoutUUID, part: partType)
                
            }) {
                Image(getImgStr(type: partType))
                    .frame(width: 80, height: 80)
                    .background(isSelected ? Color("Workout") : Color("CharBack"))
                    .clipShape(Circle())
            }
            Text(partType.rawValue)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .onAppear{
            isSelected = viewModel.customWorkouts[workoutUUID]!.parts.contains(partType)
        }
    }
}

func getImgStr(type: Part) -> String{
    switch type{
    case .arm: return "arm"
    case .back: return "back"
    case .chest: return "chest"
    case .abdomen: return "abdomen"
    case .leg: return "leg"
    case .shoulder: return "shoulder"
    }
}
//#Preview {
//    @StateObject var viewModel = HealthViewModel()
//    
//    AnaerobicView(viewModel: viewModel, workout: HKSample as! HKWorkout)
//}
