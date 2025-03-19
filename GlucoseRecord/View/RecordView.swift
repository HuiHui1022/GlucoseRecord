//
//  EntryRowView.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/27/23.
//

import SwiftUI

struct RecordView: View {
    var record: Record

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    HStack {
                        Text("\(record.timestamp ?? Date(), formatter: recordFormatter)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("Meal: \(record.mealType ?? "")")
                        Spacer()
                    }
                }
                Spacer()
                Text("\(record.glucoseLevel)")
                    .font(.system(size: 40))
                    .foregroundColor(ColorUtils.getColorByRecordImpact(impact: record.impact))
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            Spacer()
            Text("\(record.food ?? "")")
                .font(.body)
                .padding(.top, 5)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

private let recordFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
