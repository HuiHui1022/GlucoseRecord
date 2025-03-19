//
//  MealRecordApp.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/26/23.
//

import SwiftUI

@main
struct GlucoseRecordApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var viewModel: RecordViewModel
    
    init() {
        let context = persistenceController.container.viewContext
        _viewModel = StateObject(wrappedValue: RecordViewModel(context: context))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
