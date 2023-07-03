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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()
            
            switch viewModel.state {
            case .idle, .loaded:
                EmptyView()
                
            case .emptyList:
                renderEmptyListView()
                
            case .failedLoading(let errorMessage, let planets):
                if planets?.isEmpty ?? true {
                    FailedView(errorMessage: errorMessage) {
                        viewModel.handle(.didTapTryAgain)
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
        .onLoad {
            viewModel.handle(.viewDidLoad)
        }
    }
    
    // MARK: - Constructor
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Functions

private extension PlanetsView {
    private var gridItems: [SwiftUI.GridItem] {
        if horizontalSizeClass == .regular {
            return [
                .init(.flexible(), alignment: .top),
                .init(.flexible(), alignment: .top)
            ]
        } else {
            return [.init(.flexible(), spacing: 0, alignment: .top)]
        }
    }
    
    @ViewBuilder
    private func renderEmptyListView() -> some View {
        Text("There are no planets to display")
            .padding()
    }
    
    @ViewBuilder
    private func renderPlanetsList() -> some View {
        LazyVGrid(columns: gridItems, spacing: 0) {
            ForEach(viewModel.state.planets.indices, id: \.self) { index in
                let item = viewModel.state.planets[index]
                makeCell(item: item, divider: item != viewModel.state.planets.last)
                    .onTapGesture {
                        item.id.map {
                            viewModel.handle(.didTapItem(id: $0))
                        }
                    }
            }
            
            if !viewModel.state.isRefreshing, !viewModel.state.isLoading {
                Color.clear.frame(height: 0)
                    .onAppear {
                        viewModel.handle(.didReachBottom)
                    }
            }
        }
        .padding([.horizontal])
        .background(
            Color.white
                .cornerRadius(8)
                .padding([.horizontal])
        )
        .embeddedIntoRefreshableScrollView(
            belowIOS15Input: (
                action: { viewModel.handle(.didTapRefresh) },
                isRefreshing: .init(get: { viewModel.state.isRefreshing }, set: { _ in })
            ),
            fromIOS15Action: {
                viewModel.handle(.didTapRefresh)
                await awaitWhileRefreshingIsTrue()
            },
            bottomContent: {
                if viewModel.state.isLoading {
                    ProgressView()
                        .frame(minHeight: 50)
                }
            }
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
    
    private func awaitWhileRefreshingIsTrue() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        while viewModel.state.isRefreshing {
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }
}

#if DEBUG

struct PlanetsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlanetsView(
                viewModel: PlanetsViewModel(
                    useCase: StarWarsUseCaseProtocolUITestsMock(),
                    sceneDelegate: nil
                )
            )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName("Successful response")
        
        NavigationView {
            PlanetsView(
                viewModel: PlanetsViewModel(
                    useCase: StarWarsUseCaseProtocolUITestsMock()
                        .setIsPlanetsFirstPageSuccessful(false),
                    sceneDelegate: nil
                )
            )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName("Error response")
    }
}

#endif
