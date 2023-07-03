//
//  MainCoordinatorObject.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI
import Resolver

/// The main coordinator object responsible for coordinating the application's flow.
@MainActor
final class MainCoordinatorObject: ObservableObject {
    private let resolver: ResolverType
    @Published var planetsCoordinator: PlanetsCoordinatorView?
    
    init(resolver: ResolverType) {
        self.resolver = resolver
    }
    
    func start() {
        let object = PlanetsCoordinatorObject(resolver: resolver)
        self.planetsCoordinator = .init(object: object)
        object.start()
    }
}

