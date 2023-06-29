//
//  PlanetsSnapshotProvider.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import UIKit


/// A class which provides an `NSDiffableDataSourceSnapshot` providing wrapper around the retrieval of `Planets` from SWAPI
class PlanetSnapshotProvider {
    
    /// Dictates the sections we have available for display. Current UI design does not ask for any sections so we use this as a dummy for now
    enum PlanetSections {
        case main
    }
    
    /// Called when a change to the Planets occurs
    var onSnapshotUpdate: ((NSDiffableDataSourceSnapshot<PlanetSections, PlanetDTO>) -> Void)?
    
    private let newApiClient = StarWarsNetworkService(client: SwapiClientService(networking: NetworkingService(plugins: [LoggingPlugin()]), baseURL: "https://swapi.dev/"))
    
    func fetch() {
        Task {
            do {
                let page = try await newApiClient.loadPlanetsFirstPage()
                var snapshot = NSDiffableDataSourceSnapshot<PlanetSections, PlanetDTO>()
                snapshot.appendSections([.main])
                snapshot.appendItems(page.planets)
                
                self.onSnapshotUpdate?(snapshot)
            } catch {
                print(error)
            }
        }
    }
    
}
