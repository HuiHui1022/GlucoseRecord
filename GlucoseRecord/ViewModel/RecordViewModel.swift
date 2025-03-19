//
//  MealEntriesViewModel.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/26/23.
//

import Foundation
import CoreData
import SwiftUI

class RecordViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    @Published var records: [Record] = []
    @Published var foodImpacts: [FoodImpact] = []
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchData()
//        deleteAllData()
    }
    
    func fetchData() {
        fetchRecords()
        fetchFoodImpacts()
    }
    
    func fetchRecords() {
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Record.timestamp, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            records = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching records: \(error)")
        }
    }
    
    func fetchFoodImpacts() {
        let fetchRequest: NSFetchRequest<FoodImpact> = FoodImpact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \FoodImpact.impact, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            foodImpacts = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching records: \(error)")
        }
    }
    
    func deleteAllData() {
//        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Record")
//        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FoodImpact")
        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)

        do {
//            try viewContext.execute(deleteRequest1)
            try viewContext.execute(deleteRequest2)
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func addRecord(date: Date, food: String, glucoseLevel: Int16, mealType: String) {
        let newRecord = Record(context: viewContext)
        newRecord.timestamp = date
        newRecord.food = food
        newRecord.glucoseLevel = Int16(glucoseLevel)
        newRecord.mealType = mealType
        newRecord.impact = ImpactUtils.getImpactByMealTypeAndGlucose(mealType: mealType, glucose: glucoseLevel)
        
        TelegramUtils.sendRecord(record: newRecord)
        
        if mealType != "Empty" {
            for foodString in CommonUtils.splitFoodString(foodString: newRecord.food!) {
                if foodString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    continue
                }
                if let foundFood = foodImpacts.first(where: {$0.food == foodString}) {
                    let originalImpact = foundFood.impact
                    viewContext.delete(foundFood)
                    let newFoodImpact = FoodImpact(context: viewContext)
                    newFoodImpact.food = foodString
                    newFoodImpact.impact = originalImpact + newRecord.impact
                } else {
                    let newFoodImpact = FoodImpact(context: viewContext)
                    newFoodImpact.food = foodString
                    newFoodImpact.impact = newRecord.impact
                }
            }
        }
        
        do {
            try viewContext.save()
            fetchData()
        } catch {
            print("Error adding record: \(error)")
        }
    }
    
    func updateRecord(_ record: Record, date: Date, food: String, glucoseLevel: Int16, mealType: String) {
        self.deleteRecord(record)
        self.addRecord(date: date, food: food, glucoseLevel: glucoseLevel, mealType: mealType)
    }
    
    func deleteRecord(_ record: Record) {
        if record.mealType != "Empty" {
            print(record.food!)
            for foodString in CommonUtils.splitFoodString(foodString: record.food!) {
                print(foodString)
                if foodString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    continue
                }
                if let foundFood = foodImpacts.first(where: {$0.food == foodString}) {
                    let originalImpact = foundFood.impact
                    viewContext.delete(foundFood)
                    let newFoodImpact = FoodImpact(context: viewContext)
                    newFoodImpact.food = foodString
                    newFoodImpact.impact = originalImpact - record.impact
                    if (newFoodImpact.impact == 0) {
                        viewContext.delete(newFoodImpact)
                    }
                }
            }
        }
        viewContext.delete(record)
        
        do {
            try viewContext.save()
            fetchData()
        } catch {
            print("Error deleting record: \(error)")
        }
    }
}
