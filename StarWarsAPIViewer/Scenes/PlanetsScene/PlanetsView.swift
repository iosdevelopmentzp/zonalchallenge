//
//  PlanetsView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI
import UIKit

struct PlanetsView<ViewModel: PlanetsViewModelProtocol>: View {
    // MARK: - Properties
    
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()
            
            switch viewModel.state {
            case .idle, .loaded:
                EmptyView()
                
            case .emptyList:
                Text("There are no planets to display")
                    .padding()
                
            case .failedLoading(let errorMessage, let planets):
                if (planets ?? []).isEmpty {
                    VStack(alignment: .center, spacing: 24) {
                        Text("Error: \(errorMessage)")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: {
                            viewModel.handle(.didTapTryAgain)
                        }) {
                            Text("Try again")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                
            case .loading(let planets):
                if (planets ?? []).isEmpty {
                    ProgressView()
                }
            }
            
            renderPlanetsListIfNeeded()
        }
        .navigationTitle("Planets")
        .onAppear {
            viewModel.handle(.viewDidLoad)
        }
    }
    
    @ViewBuilder
    private func renderPlanetsListIfNeeded() -> some View {
        ScrollView {
            if let planetItems = viewModel.state.planets, !planetItems.isEmpty {
                LazyVGrid(
                    columns: [.init(.flexible(), spacing: 0, alignment: .top)],
                    spacing: 0,
                    content: {
                        ForEach(planetItems.indices, id: \.self) { index in
                            let item = planetItems[index]
                            makeCell(item: item, divider: item != planetItems.last)
                                .onTapGesture {
                                    viewModel.handle(.didTapItem(item))
                                }
                        }
                        
                        Color.clear.frame(height: 0)
                            .onAppear {
                                viewModel.handle(.didReachBottom)
                            }
                        
                        if viewModel.state.isLoading {
                            ProgressView()
                                .frame(minHeight: 50)
                        }
                    }
                )
                .padding([.horizontal])
                .background(
                    Color.white
                        .cornerRadius(8)
                        .padding([.horizontal])
                )
            }
        }
        .clipped()
    }
    
    @ViewBuilder
    private func makeCell(item: PlanetsViewState.PlanetItem, divider: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.name)
                .padding([.horizontal])
                .padding([.top], 8)
                .font(.system(size: 20))
            
            Text(item.population)
                .padding([.bottom], 8)
                .padding([.horizontal])
                .font(.system(size: 12))
            
            if divider {
                Rectangle()
                    .foregroundColor(Color(UIColor.systemGray6))
                    .frame(height: 1)
                    .padding([.leading])
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Constructor
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

struct PlanetsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlanetsView(
                viewModel: PlanetsViewModel(
                    useCase: StarWarsUseCaseProtocolPreviewMock(),
                    sceneDelegate: nil
                )
            )
        }
        .navigationViewStyle(.stack)
    }
}
