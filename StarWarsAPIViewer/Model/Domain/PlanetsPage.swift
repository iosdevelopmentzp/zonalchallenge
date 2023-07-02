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

extension PlanetsPage {
    /// Expecting URL such as https://swapi.dev/api/planets/?page=2. For this case number will be 2.
    var nextPageNumber: Int? {
        guard
            let nextPageUrl = next.flatMap(URL.init(string:)),
            let urlComponents = URLComponents(url: nextPageUrl, resolvingAgainstBaseURL: true),
            let queryItems = urlComponents.queryItems,
            let pageItem = queryItems.first(where: { $0.name == "page" })
        else {
            return nil
        }
        
        return pageItem.value.flatMap { Int($0) }
    }
}
