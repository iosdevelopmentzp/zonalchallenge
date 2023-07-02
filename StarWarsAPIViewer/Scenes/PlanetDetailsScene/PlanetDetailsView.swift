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
        EmptyView()
            .onLoad {
                viewModel.handle(.viewDidLoad)
            }
    }
    
    // MARK: - Constructor
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG

struct PlanetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlanetDetailsView(
                viewModel: PlanetDetailsViewModel(
                    useCase: StarWarsUseCaseProtocolPreviewMock(),
                    sceneDelegate: nil
                )
            )
        }
        .navigationViewStyle(.stack)
    }
}

#endif
