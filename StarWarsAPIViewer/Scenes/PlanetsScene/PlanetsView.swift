//
//  PlanetsView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

struct PlanetsView<ViewModel: PlanetsViewModelProtocol>: View {
    // MARK: - Properties
    
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                if let planetItems = viewModel.state.planets, !planetItems.isEmpty {
                    LazyVGrid(
                        columns: [.init(.flexible(), alignment: .top)],
                        spacing: 0,
                        content: {
                            ForEach(planetItems.indices, id: \.self) { index in
                                let item = planetItems[index]
                                Text(item.name)
                                    .frame(maxWidth: .infinity, minHeight: 70, alignment: .leading)
                            }
                            
                            Color.clear.frame(height: 0)
                                .onAppear {
                                    debugPrint("Did reach bottom")
                                    viewModel.handle(.didReachBottom)
                                }
                        }
                    )
                }
            }
        }
        .navigationTitle("Planets")
        .onAppear {
            viewModel.handle(.viewDidLoad)
        }
    }
    
    // MARK: - Constructor
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
