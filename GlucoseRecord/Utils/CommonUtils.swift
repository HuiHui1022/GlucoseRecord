//
//  CommonUtils.swift
//  GlucoseRecord
//
//  Created by Hui Zeng on 7/30/23.
//

import Foundation

class CommonUtils {
    static func splitFoodString(foodString: String) -> [String] {
        let noSpaceString = foodString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9\u{4e00}-\u{9fff}]+", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSRange(noSpaceString.startIndex..., in: noSpaceString)
        let components = regex.stringByReplacingMatches(in: noSpaceString, options: [], range: range, withTemplate: "\u{241F}")
                            .components(separatedBy: "\u{241F}")

        let trimmedComponents = components.map { $0.trimmingCharacters(in: .whitespaces) }
        return trimmedComponents
    }
}
