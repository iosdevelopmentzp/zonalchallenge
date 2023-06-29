//
//  Planets.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import Foundation

struct Planets: Codable {
    let planets: [Planet]
    
    enum CodingKeys: String, CodingKey {
        case planets = "results"
    }
}
