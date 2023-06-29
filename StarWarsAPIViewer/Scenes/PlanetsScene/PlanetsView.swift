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
        Color.green.ignoresSafeArea(.all)
    }
    
    // MARK: - Constructor
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
