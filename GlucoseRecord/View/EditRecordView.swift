//
//  EditEntryView.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/27/23.
//

import SwiftUI

struct EditRecordView: View {
    @ObservedObject var viewModel: RecordViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var record: Record
    
    @State var date: Date
    @State var time: Date
    @State var mealType: MealType
    @State var food: String
    @State var glucoseLevel: String
    
    init(viewModel: RecordViewModel, record: Record) {
        self.viewModel = viewModel
        self.record = record
        _date = State(initialValue: record.timestamp ?? Date())
        _time = State(initialValue: record.timestamp ?? Date())
        _mealType = State(initialValue: MealType.type(from: record.mealType ?? "Empty"))
        _food = State(initialValue: record.food ?? "")
        _glucoseLevel = State(initialValue: String(record.glucoseLevel))
    }
    
    var body: some View {
        VStack{
            Form {
                DatePicker("Select date", selection: $date, displayedComponents: .date)
                DatePicker("Select time", selection: $time, displayedComponents: .hourAndMinute)
                Picker("Select meal type", selection: $mealType) {
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        Text(mealType.rawValue).tag(mealType)
                    }
                }
                TextField("Enter glucose", text: $glucoseLevel)
                    .keyboardType(.numberPad)
                if mealType != MealType.empty {
                    TextField("Food", text: $food)
                }
                Button(action: {
                    guard let glucoseLevel = Int16(self.glucoseLevel) else { return }
                    
                    // Merge the date and time components
                    let calendar = Calendar.current
                    let dateComponents = calendar.dateComponents([.year, .month, .day], from: self.date)
                    let timeComponents = calendar.dateComponents([.hour, .minute], from: self.time)
                    let mergedComponents = DateComponents(calendar: calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)
                    guard let finalDate = mergedComponents.date else { return }
                    
                    viewModel.updateRecord(record, date: finalDate, food: food, glucoseLevel: glucoseLevel, mealType: mealType.rawValue)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save record")
                }
            }
            .navigationBarTitle("Edit record", displayMode: .inline)
            
            Button(action: {
                viewModel.deleteRecord(record)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text("Delete record")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
