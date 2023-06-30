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
                
            case .loading(let planets), .refreshing(let planets):
                if (planets ?? []).isEmpty {
                    ProgressView()
                }
            }
            
            if !viewModel.state.planets.isEmpty {
                renderPlanetsList()
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

// MARK: - Private Functions

extension PlanetsView {
    @ViewBuilder
    private func renderPlanetsList() -> some View {
        LazyVGrid(
            columns: [.init(.flexible(), spacing: 0, alignment: .top)],
            spacing: 0,
            content: {
                ForEach(viewModel.state.planets.indices, id: \.self) { index in
                    let item = viewModel.state.planets[index]
                    makeCell(item: item, divider: item != viewModel.state.planets.last)
                        .onTapGesture {
                            viewModel.handle(.didTapItem(item))
                        }
                }
                
                if !viewModel.state.isRefreshing {
                    Color.clear.frame(height: 0)
                        .onAppear {
                            viewModel.handle(.didReachBottom)
                        }
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
        .modifier(
            RefreshableScrollViewModifier(
                belowIOS15Action: {
                    viewModel.handle(.didTapRefresh)
                },
                fromIOS15Action: {
                    viewModel.handle(.didTapRefresh)
                    await awaitWhileRefreshableIsTrue()
                },
                isRefreshing: .init(get: { viewModel.state.isRefreshing }, set: { _ in })
            )
        )
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
    
    private func awaitWhileRefreshableIsTrue() async {
        try? await Task.sleep(nanoseconds: 200_000)
        
        while viewModel.state.isRefreshing {
            try? await Task.sleep(nanoseconds: 500_000)
        }
    }
}

#if DEBUG

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

#endif
