//
//  Planet.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

struct Planet: Equatable {
    let name: String
    let terrain: String
    let population: String
    let climate: String?
    let gravity: String?
    let rotationPeriod: Int?
    let orbitalPeriod: Int?
}
