//
//  Resolver+SetupDependencies.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Resolver

extension ResolverType {
    func setupDependencies() {
        self.register(type: NetworkingServiceProtocol.self, strategy: .alwaysNewInstance) { _ in
            let plugins: [NetworkingPluginProtocol] = {
                #if DEBUG
                [LoggingPlugin()]
                #else
                []
                #endif
            }()
            return NetworkingService(plugins: plugins)
        }
        
        self.register(type: SwapiClientServiceProtocol.self, strategy: .alwaysNewInstance) { resolver in
            SwapiClientService(networking: resolver.resolve(), baseURL: "https://swapi.dev/")
        }
        
        self.register(type: StarWarsNetworkServiceProtocol.self, strategy: .alwaysNewInstance) { resolver in
            StarWarsNetworkService(client: resolver.resolve())
        }
        
        self.register(type: StarWarsUseCaseProtocol.self, strategy: .alwaysNewInstance) { resolver in
            StarWarsUseCase(starWarsNetwork: resolver.resolve())
        }
    }
}
