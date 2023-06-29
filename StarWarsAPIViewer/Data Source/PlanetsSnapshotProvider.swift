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
    
    private let apiClient = ZNLSWAPIClient(baseURL: URL(string: "https://swapi.dev/api/")!, using: URLSession.init(configuration: .ephemeral))
    
    
    /// Performs a fresh request to get a list of Planets from SWAPI. Any updates to the data will be passed to the `onSnapshotUpdate` closure
    func fetch() {
        apiClient.beginRequest(forEndpoint: "planets") { data, error in
            
            
            guard let responseData = data else {
                return
            }
            
            do {
                let planets = try JSONDecoder().decode(PlanetsPageDTO.self, from: responseData)
                
                var snapshot = NSDiffableDataSourceSnapshot<PlanetSections, PlanetDTO>()
                snapshot.appendSections([.main])
                snapshot.appendItems(planets.planets)
                
                self.onSnapshotUpdate?(snapshot)
            } catch {
                print(error)
            }
        }
    }
    
}
