//
//  ColorUtils.swift
//  GlucoseRecord
//
//  Created by Hui Zeng on 7/29/23.
//

import SwiftUI

class ColorUtils {
    static func getColorByRecordImpact(impact: Int16) -> Color {
        if (impact == -2) {
            return Color.red
        } else if (impact > 0) {
            return Color.green
        } else {
            return Color.orange
        }
    }
    
    static func getColorByFoodImpact(impact: Int16) -> Color {
        if (impact < 0) {
            return Color.red
        } else if (impact > 0) {
            return Color.green
        } else {
            return Color.orange
        }
    }
}
