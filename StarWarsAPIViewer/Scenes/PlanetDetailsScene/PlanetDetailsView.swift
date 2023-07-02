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
            if let item = viewModel.state.planetItem {
                renderPlanetDetails(item)
            }
            
            if viewModel.state.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Details Title")
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
        LazyVGrid(columns: [.init(.flexible(), spacing: 0, alignment: .top)], spacing: 0) {
            Text(item.name)
                .font(.system(size: 20))
            
            ForEach(item.parameters.indices, id: \.self) {
                let localized = item.parameters[$0].localized
                HStack(spacing: 16) {
                    Text(localized.title)
                    Spacer()
                    Text(localized.value)
                }
            }
        }
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
                    planetId: 0,
                    useCase: StarWarsUseCaseProtocolPreviewMock(),
                    sceneDelegate: nil
                )
            )
        }
        .navigationViewStyle(.stack)
    }
}

#endif
