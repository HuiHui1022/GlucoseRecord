//
//  FoodImpactView.swift
//  GlucoseRecord
//
//  Created by Hui Zeng on 7/30/23.
//

import SwiftUI

struct FoodImpactView: View {
    @ObservedObject var viewModel: RecordViewModel
    @State private var isSortedDescending = true
    
    var sortedFoodImpacts: [FoodImpact] {
        if isSortedDescending {
            return viewModel.foodImpacts.sorted(by: { $0.impact > $1.impact })
        } else {
            return viewModel.foodImpacts.sorted(by: { $0.impact < $1.impact })
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(sortedFoodImpacts) { foodImpact in
                    HStack {
                        Text(foodImpact.food!)
                        Spacer()
                        Text("\(foodImpact.impact)")
                            .fontWeight(.bold)
                            .foregroundColor(ColorUtils.getColorByFoodImpact(impact: foodImpact.impact))
                    }
                }
            }
            Button(action: {
                isSortedDescending.toggle()
            }) {
                Image(systemName: isSortedDescending ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.blue))
                    .font(.system(size: 24))
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
