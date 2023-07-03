//
//  StarWarsUseCaseProtocolUITestsMock.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Foundation

#if DEBUG

final class StarWarsUseCaseProtocolUITestsMock: StarWarsUseCaseProtocol {
    private var isPlanetsFirstPageSuccessful: () -> Bool = { true }
    private var isPlanetsNextPageSuccessful: () -> Bool = { true }
    private var isPlanetsDetailsSuccessful: () -> Bool = { true }
    
    private var planetsFirstPageResponse = StarWarsUseCaseProtocolUITestsMock.firstPageResponse
    private var planetsNextPageResponse = StarWarsUseCaseProtocolUITestsMock.nextPageResponse
    private var planetDetailsResponse: Planet?
    
    private var requestDelay: UInt64 = 1_000_000_000 // 1 second
    
    func planetsFirstPage() async throws -> PlanetsPage {
        if requestDelay > 0 {
            try? await Task.sleep(nanoseconds: requestDelay)
        }
        
        if isPlanetsFirstPageSuccessful() {
            return planetsFirstPageResponse
        } else {
            throw MockedError.generic
        }
    }
    
    func planetsNextPage(url: String) async throws -> PlanetsPage {
        if requestDelay > 0 {
            try? await Task.sleep(nanoseconds: requestDelay)
        }
        
        if isPlanetsNextPageSuccessful() {
            return planetsNextPageResponse
        } else {
            throw MockedError.generic
        }
    }
    
    func planetDetails(id: Int) async throws -> Planet {
        if requestDelay > 0 {
            try? await Task.sleep(nanoseconds: requestDelay)
        }
        
        guard isPlanetsDetailsSuccessful() else {
            throw MockedError.generic
        }
        
        guard let planetDetailsResponse else {
            let allPlanets = [Self.firstPageResponse, Self.nextPageResponse].flatMap(\.planets)
            
            if let planet = allPlanets.first(where: { $0.id == id }) {
                return planet
            } else {
                throw MockedError.generic
            }
        }
        
        return planetDetailsResponse
    }
    
    // MARK: - Configurations
    
    @discardableResult
    func setIsPlanetsFirstPageSuccessful(_ isSuccessful: @autoclosure @escaping () ->  Bool) -> Self {
        self.isPlanetsFirstPageSuccessful = isSuccessful
        return self
    }
    
    @discardableResult
    func setPlanetsFirstPageResponse(_ response: PlanetsPage) -> Self {
        self.planetsFirstPageResponse = response
        return self
    }
    
    @discardableResult
    func setIsPlanetsNextPageSuccessful(_ isSuccessful: @autoclosure @escaping () ->  Bool) -> Self {
        self.isPlanetsNextPageSuccessful = isSuccessful
        return self
    }
    
    @discardableResult
    func setIsPlanetsDetailsSuccessful(_ isSuccessful: @autoclosure @escaping () ->  Bool) -> Self {
        self.isPlanetsDetailsSuccessful = isSuccessful
        return self
    }
    
    @discardableResult
    func requestDelay(_ delay: UInt64) -> Self {
        requestDelay = delay
        return self
    }
}

extension StarWarsUseCaseProtocolUITestsMock {
    static var firstPageResponse: PlanetsPage {
        .fixture(
            next: "https://swapi.dev/api/planets/?page=2",
            planets: [
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/1/",
                    name: "Tatooine",
                    terrain: "desert",
                    population: "200000",
                    climate: "arid",
                    gravity: "1 standard",
                    rotationPeriod: "23",
                    orbitalPeriod: "304"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/2/",
                    name: "Alderaan",
                    terrain: "grasslands, mountains",
                    population: "2000000000",
                    climate: "temperate",
                    gravity: "1 standard",
                    rotationPeriod: "24",
                    orbitalPeriod: "364"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/3/",
                    name: "Yavin IV",
                    terrain: "jungle, rainforests",
                    population: "1000",
                    climate: "temperate, tropical",
                    gravity: "1 standard",
                    rotationPeriod: "24",
                    orbitalPeriod: "4818"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/4/",
                    name: "Hoth",
                    terrain: "tundra, ice caves, mountain ranges",
                    population: "unknown",
                    climate: "frozen",
                    gravity: "1.1 standard",
                    rotationPeriod: "23",
                    orbitalPeriod: "549"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/5/",
                    name: "Dagobah",
                    terrain: "swamp, jungles",
                    population: "unknown",
                    climate: "murky",
                    gravity: "N/A",
                    rotationPeriod: "23",
                    orbitalPeriod: "341"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/6/",
                    name: "Bespin",
                    terrain: "gas giant",
                    population: "6000000",
                    climate: "temperate",
                    gravity: "1.5 (surface), 1 standard (Cloud City)",
                    rotationPeriod: "12",
                    orbitalPeriod: "5110"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/7/",
                    name: "Endor",
                    terrain: "forests, mountains, lakes",
                    population: "30000000",
                    climate: "temperate",
                    gravity: "0.85 standard",
                    rotationPeriod: "18",
                    orbitalPeriod: "402"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/8/",
                    name: "Naboo",
                    terrain: "grassy hills, swamps, forests, mountains",
                    population: "4500000000",
                    climate: "temperate",
                    gravity: "1 standard",
                    rotationPeriod: "26",
                    orbitalPeriod: "312"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/9/",
                    name: "Coruscant",
                    terrain: "cityscape, mountains",
                    population: "1000000000000",
                    climate: "temperate",
                    gravity: "1 standard",
                    rotationPeriod: "24",
                    orbitalPeriod: "368"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/10/",
                    name: "Kamino",
                    terrain: "ocean",
                    population: "1000000000",
                    climate: "temperate",
                    gravity: "1 standard",
                    rotationPeriod: "27",
                    orbitalPeriod: "463"
                )
            ]
        )
    }
    
    static var nextPageResponse: PlanetsPage {
        .fixture(
            next: nil,
            planets: [
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/11/",
                    name: "Geonosis",
                    terrain: "rock, desert, mountain, barren",
                    population: "100000000000",
                    climate: "temperate, arid",
                    gravity: "0.9 standard",
                    rotationPeriod: "30",
                    orbitalPeriod: "256"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/12/",
                    name: "Utapau",
                    terrain: "scrublands, savanna, canyons, sinkholes",
                    population: "95000000",
                    climate: "temperate, arid, windy",
                    gravity: "1 standard",
                    rotationPeriod: "27",
                    orbitalPeriod: "351"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/13/",
                    name: "Mustafar",
                    terrain: "volcanoes, lava rivers, mountains, caves",
                    population: "20000",
                    climate: "hot",
                    gravity: "1 standard",
                    rotationPeriod: "36",
                    orbitalPeriod: "412"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/14/",
                    name: "Kashyyyk",
                    terrain: "jungle, forests, lakes, rivers",
                    population: "45000000",
                    climate: "tropical",
                    gravity: "1 standard",
                    rotationPeriod: "26",
                    orbitalPeriod: "381"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/15/",
                    name: "Polis Massa",
                    terrain: "airless asteroid",
                    population: "1000000",
                    climate: "artificial temperate",
                    gravity: "0.56 standard",
                    rotationPeriod: "24",
                    orbitalPeriod: "590"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/16/",
                    name: "Mygeeto",
                    terrain: "glaciers, mountains, ice canyons",
                    population: "19000000",
                    climate: "frigid",
                    gravity: "1 standard",
                    rotationPeriod: "12",
                    orbitalPeriod: "167"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/17/",
                    name: "Felucia",
                    terrain: "fungus forests",
                    population: "8500000",
                    climate: "hot, humid",
                    gravity: "0.75 standard",
                    rotationPeriod: "34",
                    orbitalPeriod: "231"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/18/",
                    name: "Cato Neimoidia",
                    terrain: "mountains, fields, forests, rock arches",
                    population: "10000000",
                    climate: "temperate, moist",
                    gravity: "1 standard",
                    rotationPeriod: "25",
                    orbitalPeriod: "278"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/19/",
                    name: "Saleucami",
                    terrain: "caves, desert, mountains, volcanoes",
                    population: "1400000000",
                    climate: "hot",
                    gravity: "unknown",
                    rotationPeriod: "26",
                    orbitalPeriod: "392"
                ),
                
                Planet.fixture(
                    url: "https://swapi.dev/api/planets/20/",
                    name: "Stewjon",
                    terrain: "grass",
                    population: "unknown",
                    climate: "temperate",
                    gravity: "1 standard",
                    rotationPeriod: "unknown",
                    orbitalPeriod: "unknown"
                )
            ]
        )
    }
}

#endif
