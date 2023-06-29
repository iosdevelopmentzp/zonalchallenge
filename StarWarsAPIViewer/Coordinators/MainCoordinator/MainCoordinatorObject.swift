//
//  MainCoordinatorObject.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

/// The main coordinator object responsible for coordinating the application's flow.
@MainActor
final class MainCoordinatorObject: ObservableObject {
    @Published var planetsCoordinator: PlanetsCoordinatorView?
    
    init() {}
    
    func start() {
        let object = PlanetsCoordinatorObject()
        self.planetsCoordinator = .init(object: object)
        object.start()
    }
}

