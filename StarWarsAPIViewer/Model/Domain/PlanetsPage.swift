//
//  PlanetsPage.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

struct PlanetsPage: Equatable {
    let next: String?
    let planets: [Planet]
}
