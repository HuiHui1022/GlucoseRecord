//
//  ImpactUtils.swift
//  GlucoseRecord
//
//  Created by Hui Zeng on 7/30/23.
//

import Foundation

class ImpactUtils {
    static func getImpactByMealTypeAndGlucose(mealType: String, glucose: Int16) -> Int16 {
        if (mealType == "Empty") {
            if (glucose <= 90) {
                return 2
            } else if (glucose <= 110) {
                return -1
            } else {
                return -2
            }
        } else {
            if (glucose <= 130) {
                return 2
            } else if (glucose <= 160) {
                return -1
            } else {
                return -2
            }
        }
    }
}
