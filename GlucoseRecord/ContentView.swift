//
//  ContentView.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: RecordViewModel
    @State var isShowingAddEntryView = false
    
    init(viewModel: RecordViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        LazyVStack {
                            NavigationLink(destination: AddRecordView(viewModel: viewModel, isShowing: $isShowingAddEntryView)) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                            
                            ForEach(viewModel.records) { record in
                                NavigationLink(destination: EditRecordView(viewModel: viewModel, record: record)) {
                                    RecordView(record: record)
                                }
                                .buttonStyle(PlainButtonStyle())
                                Spacer().frame(height: 15)
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
                .padding(0)
                .navigationBarTitle("Hui's Glucose Tracker")
                
                HStack {
                    NavigationLink(destination: FoodImpactView(viewModel: viewModel)) {
                        Text("Food")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    NavigationLink(destination: StatsView(viewModel: viewModel)) {
                        Text("Stats")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .buttonStyle(PlainButtonStyle())

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: RecordViewModel(context: PersistenceController.preview.container.viewContext))
    }
}
