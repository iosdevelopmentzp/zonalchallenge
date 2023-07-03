//
//  PlanetDetailsView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 02.07.2023.
//

import Foundation

import SwiftUI

struct PlanetDetailsView<ViewModel: PlanetDetailsViewModelProtocol>: View {
    // MARK: - Properties
    
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()
            
            if let item = viewModel.state.planetItem {
                renderPlanetDetails(item)
            }
            
            switch viewModel.state {
            case .idle, .refreshing, .loaded:
                EmptyView()
                
            case .loading:
                ProgressView()
                
            case .failed(let errorMessage, let planetItem):
                if planetItem == nil {
                    FailedView(errorMessage: errorMessage) {
                        viewModel.handle(.didTapTryAgain)
                    }
                }
            }
        }
        .navigationTitle(viewModel.state.planetItem?.name ?? "Loading...")
        .onLoad {
            viewModel.handle(.viewDidLoad)
        }
    }
    
    // MARK: - Constructor
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private
    
    private func awaitWhileRefreshingIsTrue() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        while viewModel.state.isRefreshing {
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }
    
    @ViewBuilder
    private func renderPlanetDetails(_ item: PlanetDetailsViewState.PlanetItem) -> some View {
        LazyVGrid(columns: [.init(.flexible(), spacing: 0, alignment: .leading)], spacing: 0) {
            ForEach(item.parameters.indices, id: \.self) {
                let localized = item.parameters[$0].localized
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    Text(localized.title + ":")
                        .font(.system(size: 20, weight: .bold))
                    +
                    Text("\n\(localized.value)")
                }
                .padding()
            }
        }
        .padding()
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
            bottomContent: { EmptyView() }
        )
    }
}

#if DEBUG

struct PlanetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlanetDetailsView(
                viewModel: PlanetDetailsViewModel(
                    planetId: 1,
                    useCase: StarWarsUseCaseProtocolUITestsMock(),
                    sceneDelegate: nil
                )
            )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName("Successful response")
        
        NavigationView {
            PlanetDetailsView(
                viewModel: PlanetDetailsViewModel(
                    planetId: 1,
                    useCase: StarWarsUseCaseProtocolUITestsMock()
                        .setIsPlanetsDetailsSuccessful(false),
                    sceneDelegate: nil
                )
            )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName("Error response")
    }
}

#endif
