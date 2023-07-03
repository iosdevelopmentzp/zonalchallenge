//
//  Resolver+UITestsSetupDependencies.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Resolver

#if DEBUG

extension ResolverType {
    func setupUITestsDependencies() {
        self.register(type: StarWarsUseCaseProtocol.self, strategy: .alwaysNewInstance) { _ in
            StarWarsUseCaseProtocolUITestsMock()
        }
    }
}

#endif
