//
//  PlanetDTO.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import Foundation

struct PlanetDTO: Decodable, Hashable {

    let name: String
    let terrain: String
    let population: String
}
