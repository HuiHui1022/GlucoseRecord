//
//  AddEntryView.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/27/23.
//

import SwiftUI

struct AddRecordView: View {
    @ObservedObject var viewModel: RecordViewModel
    @Binding var isShowing: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var selectedMealType = MealType.empty
    @State private var enteredFood = ""
    @State private var enteredGlucoseLevel = ""

    var body: some View {
        Form {
            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
            DatePicker("Select time", selection: $selectedTime, displayedComponents: .hourAndMinute)
            Picker("Select meal type", selection: $selectedMealType) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    Text(mealType.rawValue).tag(mealType)
                }
            }
            TextField("Glucose", text: $enteredGlucoseLevel)
                .keyboardType(.numberPad)
            if selectedMealType != MealType.empty {
                TextField("Food", text: $enteredFood)
            }
            Button(action: {
                guard let glucoseLevel = Int16(self.enteredGlucoseLevel) else { return }
                
                // Merge the date and time components
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
                let timeComponents = calendar.dateComponents([.hour, .minute], from: self.selectedTime)
                let mergedComponents = DateComponents(calendar: calendar, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)
                guard let finalDate = mergedComponents.date else { return }
                
                self.viewModel.addRecord(date: finalDate, food: self.enteredFood, glucoseLevel: glucoseLevel, mealType: self.selectedMealType.rawValue)
                self.enteredFood = ""
                self.enteredGlucoseLevel = ""
                self.isShowing = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save record")
            }
        }
        .navigationBarTitle("Add record", displayMode: .inline)
        .onAppear() {
            self.selectedTime = Date()
        }
    }
}
