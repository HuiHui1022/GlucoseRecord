//
//  MealType.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/27/23.
//

import Foundation

enum MealType: String, CaseIterable {
    case empty = "Empty"
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    static func type(from string: String) -> MealType {
        return MealType(rawValue: string) ?? .empty
    }
}
