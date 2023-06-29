//
//  PlanetsCoordinatorView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

struct PlanetsCoordinatorView: View {
    @ObservedObject var object: PlanetsCoordinatorObject
    
    var body: some View {
        object.planetsViewModel.map { PlanetsView(viewModel: $0) }
    }
}
