//
//  PreviewUtils.swift
//  GlucoseRecord
//
//  Created by Hui Zeng on 7/30/23.
//

import Foundation
import CoreData

class PreviewUtils {
    static func addPreviewData(viewContext: NSManagedObjectContext) {
        let record1 = Record(context: viewContext)
        record1.timestamp = Date()
        record1.glucoseLevel = 90
        record1.food = "西红柿"
        record1.mealType = "Breakfast"
        record1.impact = 2
        
        let record2 = Record(context: viewContext)
        record2.timestamp = Date()
        record2.glucoseLevel = 150
        record2.food = "牛肉"
        record2.mealType = "Lunch"
        record2.impact = -1
        
        let record3 = Record(context: viewContext)
        record3.timestamp = Date()
        record3.glucoseLevel = 190
        record3.food = "粥"
        record3.mealType = "Dinner"
        record3.impact = -2
        
        let record4 = Record(context: viewContext)
        record4.timestamp = Date()
        record4.glucoseLevel = 84
        record4.mealType = "Empty"
        record4.impact = 2
        
        let foodImpact1 = FoodImpact(context: viewContext)
        foodImpact1.food = "西红柿"
        foodImpact1.impact = 2
        
        let foodImpact2 = FoodImpact(context: viewContext)
        foodImpact2.food = "牛肉"
        foodImpact2.impact = -1
        
        let foodImpact3 = FoodImpact(context: viewContext)
        foodImpact3.food = "粥"
        foodImpact3.impact = -2
    }
}
