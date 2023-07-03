//
//  PlanetsCoordinatorView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

struct PlanetsCoordinatorView: View {
    // MARK: - Properties
    
    @ObservedObject var object: PlanetsCoordinatorObject
    
    var body: some View {
        object
            .spaceViewModel.map(StarWarsSpaceView.init(viewModel:))
            .navigation(item: $object.planetsViewModel) {
                PlanetsView.init(viewModel: $0)
                    .navigation(item: $object.planetDetailsViewModel, destination: PlanetDetailsView.init(viewModel:))
            }
    }
}
