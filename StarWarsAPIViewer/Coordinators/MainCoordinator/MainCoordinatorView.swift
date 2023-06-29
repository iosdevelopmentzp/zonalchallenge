//
//  MainCoordinatorView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

/// Represents the main coordinator view in the application.
struct MainCoordinatorView: View {
    @ObservedObject var object: MainCoordinatorObject
    
    var body: some View {
        NavigationView {
            object.planetsCoordinator
        }
        .navigationViewStyle(.stack)
    }
}

