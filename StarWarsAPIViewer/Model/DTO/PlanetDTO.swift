//
//  PlanetDTO.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import Foundation

struct PlanetDTO: Decodable, Hashable {
    let url: String
    let name: String
    let terrain: String
    let population: String
    let climate: String?
    let gravity: String?
    let rotationPeriod: String?
    let orbitalPeriod: String?
}
