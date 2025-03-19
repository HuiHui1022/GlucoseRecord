//
//  StatsView.swift
//  GlucoseRecord
//
//  Created by Hui Zeng on 9/24/23.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: RecordViewModel

    var body: some View {
        VStack(spacing: 16) {
            List {
                HStack {
                    Text("Date")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    
                    ForEach(["E", "B", "L", "D"], id: \.self) { mealType in
                        Text(mealType)
                            .bold()
                            .frame(maxWidth: 45)
                        Spacer()
                    }
                }
                
                ForEach(groupedRecords.keys.sorted().reversed(), id: \.self) { date in
                    HStack {
                        Text(date)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        
                        ForEach(["Empty", "Breakfast", "Lunch", "Dinner"], id: \.self) { mealType in
                            ZStack {
                                Rectangle()
                                    .opacity(0)
                                    .frame(maxWidth: 45)
                                
                                if let entry = groupedRecords[date]?.first(where: { $0.mealType == mealType }) {
                                    Text(entry.glucose)
                                        .foregroundColor(ColorUtils.getColorByRecordImpact(impact: entry.impact))
                                }
                            }
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    Text("Average")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(["Empty", "Breakfast", "Lunch", "Dinner"], id: \.self) { mealType in
                        ZStack {
                            Rectangle()
                                .opacity(0)
                                .frame(maxWidth: 45)
                            
                            Text("\(averageGlucose(for: mealType))")
                                .bold()
                                .foregroundColor(ColorUtils.getColorByRecordImpact(impact: ImpactUtils.getImpactByMealTypeAndGlucose(mealType: mealType, glucose: averageGlucose(for: mealType))))
                        }
                        Spacer()
                    }
                }
            }
            
            let aggregatedData = aggregateCounts()
            let overallRatio = aggregatedData.totalCount > 0 ? String(format: "%.1f%%", Double(aggregatedData.positiveImpactCount) / Double(aggregatedData.totalCount) * 100) : "N/A"
            HStack {
                VStack {
                    Text("Total Records: \(aggregatedData.totalCount)")
                        .padding(.bottom, 2)
                        .bold()
                    Text("Out of Range: \(aggregatedData.positiveImpactCount)")
                        .padding(.bottom, 2)
                        .bold()
                    Text("Ratio: \(overallRatio)")
                        .bold()
                }
            }
            .padding()
        }
        .navigationBarTitle("Daily Stats", displayMode: .inline)
        .background(Color(UIColor.systemGroupedBackground))
    }

    var groupedRecords: [String: [(mealType: String, glucose: String, impact: Int16)]] {
        var result: [String: [(mealType: String, glucose: String, impact: Int16)]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            
        for record in viewModel.records {
            let dateString = dateFormatter.string(from: record.timestamp ?? Date())
                
            if result[dateString] == nil {
                result[dateString] = []
            }

            result[dateString]?.append((mealType: record.mealType ?? "Empty", glucose: "\(record.glucoseLevel)", impact: record.impact))
        }

        return result.filter { $1.count >= 3 }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var qualifiedDates: [String] {
        dateFormatter.dateStyle = .medium
        
        // Group records by date
        let recordsByDate = Dictionary(grouping: viewModel.records) { (record) -> String in
            return dateFormatter.string(from: record.timestamp ?? Date())
        }
        
        // Filter out dates that have less than 3 records
        let qualifiedDates = recordsByDate.filter { $1.count >= 3 }.keys
        
        return Array(qualifiedDates)
    }
    
    func averageGlucose(for mealType: String) -> Int16 {
        let allGlucoseValues = viewModel.records
            .filter { record in
                let recordDate = dateFormatter.string(from: record.timestamp ?? Date())
                return record.mealType == mealType && qualifiedDates.contains(recordDate)
            }
            .map { $0.glucoseLevel }
                
        let sum = allGlucoseValues.reduce(0, +)
        let average = allGlucoseValues.count > 0 ? Int16(Double(sum) / Double(allGlucoseValues.count)) : 0
        
        return average
    }
    
    func aggregateCounts() -> (positiveImpactCount: Int, totalCount: Int) {
        let filteredRecords = viewModel.records.filter { record in
            let recordDate = dateFormatter.string(from: record.timestamp ?? Date())
            return qualifiedDates.contains(recordDate)
        }

        let positiveImpactCount = filteredRecords.filter { $0.impact < 0 }.count
        let totalCount = filteredRecords.count

        return (positiveImpactCount, totalCount)
    }
}
