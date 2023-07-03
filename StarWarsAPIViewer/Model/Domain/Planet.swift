//
//  Planet.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

struct Planet: Equatable {
    let url: String
    let name: String
    let terrain: String
    let population: String
    let climate: String?
    let gravity: String?
    let rotationPeriod: String?
    let orbitalPeriod: String?
}

extension Planet {
    /// Expecting url such https://swapi.dev/api/planets/13/. So for this case id will be 13.
    var id: Int? {
        guard let lastComponent = URL(string: url)?.lastPathComponent else {
            return nil
        }
        return Int(lastComponent)
    }
}
