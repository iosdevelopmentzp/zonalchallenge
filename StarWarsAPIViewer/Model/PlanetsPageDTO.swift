//
//  PlanetsPageDTO.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import Foundation

struct PlanetsPageDTO: Decodable, Equatable {
    let next: String?
    let planets: [PlanetDTO]
    
    enum CodingKeys: String, CodingKey {
        case next
        case planets = "results"
    }
}
