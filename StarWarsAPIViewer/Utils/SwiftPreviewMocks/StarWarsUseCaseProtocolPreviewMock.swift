//
//  StarWarsUseCaseProtocolPreviewMock.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 30.06.2023.
//

import Foundation

#if DEBUG

struct StarWarsUseCaseProtocolPreviewMock: StarWarsUseCaseProtocol {
    func planetsFirstPage() async throws -> PlanetsPage {
        let dto = try SwapiDecoder().decode(PlanetsPageDTO.self, from: Self.firstPageJSON.data(using: .utf8)!)
        return PlanetsPage(planetPage: dto)
    }
    
    func planetsNextPage(url: String) async throws -> PlanetsPage {
        let dto = try SwapiDecoder().decode(PlanetsPageDTO.self, from: Self.secondPageJSON.data(using: .utf8)!)
        return PlanetsPage(planetPage: dto)
    }
    
    func planetDetails(id: Int) async throws -> Planet {
        let dto = try SwapiDecoder().decode(PlanetDTO.self, from: Self.planetDetailsJSON.data(using: .utf8)!)
        return Planet(planet: dto)
    }
}

private extension StarWarsUseCaseProtocolPreviewMock {
    static var firstPageJSON: String {
        """
        {
          "previous" : null,
          "results" : [
            {
              "population" : "200000",
              "terrain" : "desert",
              "edited" : "2014-12-20T20:58:18.411000Z",
              "diameter" : "10465",
              "residents" : [
                "https://swapi.dev/api/people/1/",
                "https://swapi.dev/api/people/2/",
                "https://swapi.dev/api/people/4/",
                "https://swapi.dev/api/people/6/",
                "https://swapi.dev/api/people/7/",
                "https://swapi.dev/api/people/8/",
                "https://swapi.dev/api/people/9/",
                "https://swapi.dev/api/people/11/",
                "https://swapi.dev/api/people/43/",
                "https://swapi.dev/api/people/62/"
              ],
              "orbital_period" : "304",
              "surface_water" : "1",
              "rotation_period" : "23",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/1/",
                "https://swapi.dev/api/films/3/",
                "https://swapi.dev/api/films/4/",
                "https://swapi.dev/api/films/5/",
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/1/",
              "created" : "2014-12-09T13:50:49.641000Z",
              "climate" : "arid",
              "name" : "Tatooine"
            },
            {
              "population" : "2000000000",
              "terrain" : "grasslands, mountains",
              "edited" : "2014-12-20T20:58:18.420000Z",
              "diameter" : "12500",
              "residents" : [
                "https://swapi.dev/api/people/5/",
                "https://swapi.dev/api/people/68/",
                "https://swapi.dev/api/people/81/"
              ],
              "orbital_period" : "364",
              "surface_water" : "40",
              "rotation_period" : "24",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/1/",
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/2/",
              "created" : "2014-12-10T11:35:48.479000Z",
              "climate" : "temperate",
              "name" : "Alderaan"
            },
            {
              "population" : "1000",
              "terrain" : "jungle, rainforests",
              "edited" : "2014-12-20T20:58:18.421000Z",
              "diameter" : "10200",
              "residents" : [

              ],
              "orbital_period" : "4818",
              "surface_water" : "8",
              "rotation_period" : "24",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/1/"
              ],
              "url" : "https://swapi.dev/api/planets/3/",
              "created" : "2014-12-10T11:37:19.144000Z",
              "climate" : "temperate, tropical",
              "name" : "Yavin IV"
            },
            {
              "population" : "unknown",
              "terrain" : "tundra, ice caves, mountain ranges",
              "edited" : "2014-12-20T20:58:18.423000Z",
              "diameter" : "7200",
              "residents" : [

              ],
              "orbital_period" : "549",
              "surface_water" : "100",
              "rotation_period" : "23",
              "gravity" : "1.1 standard",
              "films" : [
                "https://swapi.dev/api/films/2/"
              ],
              "url" : "https://swapi.dev/api/planets/4/",
              "created" : "2014-12-10T11:39:13.934000Z",
              "climate" : "frozen",
              "name" : "Hoth"
            },
            {
              "population" : "unknown",
              "terrain" : "swamp, jungles",
              "edited" : "2014-12-20T20:58:18.425000Z",
              "diameter" : "8900",
              "residents" : [

              ],
              "orbital_period" : "341",
              "surface_water" : "8",
              "rotation_period" : "23",
              "gravity" : "N/A",
              "films" : [
                "https://swapi.dev/api/films/2/",
                "https://swapi.dev/api/films/3/",
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/5/",
              "created" : "2014-12-10T11:42:22.590000Z",
              "climate" : "murky",
              "name" : "Dagobah"
            },
            {
              "population" : "6000000",
              "terrain" : "gas giant",
              "edited" : "2014-12-20T20:58:18.427000Z",
              "diameter" : "118000",
              "residents" : [
                "https://swapi.dev/api/people/26/"
              ],
              "orbital_period" : "5110",
              "surface_water" : "0",
              "rotation_period" : "12",
              "gravity" : "1.5 (surface), 1 standard (Cloud City)",
              "films" : [
                "https://swapi.dev/api/films/2/"
              ],
              "url" : "https://swapi.dev/api/planets/6/",
              "created" : "2014-12-10T11:43:55.240000Z",
              "climate" : "temperate",
              "name" : "Bespin"
            },
            {
              "population" : "30000000",
              "terrain" : "forests, mountains, lakes",
              "edited" : "2014-12-20T20:58:18.429000Z",
              "diameter" : "4900",
              "residents" : [
                "https://swapi.dev/api/people/30/"
              ],
              "orbital_period" : "402",
              "surface_water" : "8",
              "rotation_period" : "18",
              "gravity" : "0.85 standard",
              "films" : [
                "https://swapi.dev/api/films/3/"
              ],
              "url" : "https://swapi.dev/api/planets/7/",
              "created" : "2014-12-10T11:50:29.349000Z",
              "climate" : "temperate",
              "name" : "Endor"
            },
            {
              "population" : "4500000000",
              "terrain" : "grassy hills, swamps, forests, mountains",
              "edited" : "2014-12-20T20:58:18.430000Z",
              "diameter" : "12120",
              "residents" : [
                "https://swapi.dev/api/people/3/",
                "https://swapi.dev/api/people/21/",
                "https://swapi.dev/api/people/35/",
                "https://swapi.dev/api/people/36/",
                "https://swapi.dev/api/people/37/",
                "https://swapi.dev/api/people/38/",
                "https://swapi.dev/api/people/39/",
                "https://swapi.dev/api/people/42/",
                "https://swapi.dev/api/people/60/",
                "https://swapi.dev/api/people/61/",
                "https://swapi.dev/api/people/66/"
              ],
              "orbital_period" : "312",
              "surface_water" : "12",
              "rotation_period" : "26",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/3/",
                "https://swapi.dev/api/films/4/",
                "https://swapi.dev/api/films/5/",
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/8/",
              "created" : "2014-12-10T11:52:31.066000Z",
              "climate" : "temperate",
              "name" : "Naboo"
            },
            {
              "population" : "1000000000000",
              "terrain" : "cityscape, mountains",
              "edited" : "2014-12-20T20:58:18.432000Z",
              "diameter" : "12240",
              "residents" : [
                "https://swapi.dev/api/people/34/",
                "https://swapi.dev/api/people/55/",
                "https://swapi.dev/api/people/74/"
              ],
              "orbital_period" : "368",
              "surface_water" : "unknown",
              "rotation_period" : "24",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/3/",
                "https://swapi.dev/api/films/4/",
                "https://swapi.dev/api/films/5/",
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/9/",
              "created" : "2014-12-10T11:54:13.921000Z",
              "climate" : "temperate",
              "name" : "Coruscant"
            },
            {
              "population" : "1000000000",
              "terrain" : "ocean",
              "edited" : "2014-12-20T20:58:18.434000Z",
              "diameter" : "19720",
              "residents" : [
                "https://swapi.dev/api/people/22/",
                "https://swapi.dev/api/people/72/",
                "https://swapi.dev/api/people/73/"
              ],
              "orbital_period" : "463",
              "surface_water" : "100",
              "rotation_period" : "27",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/5/"
              ],
              "url" : "https://swapi.dev/api/planets/10/",
              "created" : "2014-12-10T12:45:06.577000Z",
              "climate" : "temperate",
              "name" : "Kamino"
            }
          ],
          "count" : 60,
          "next" : "https://swapi.dev/api/planets/?page=2"
        }
        """
    }
    
    static var secondPageJSON: String {
        """
        {
          "previous" : "https://swapi.dev/api/planets/?page=1",
          "results" : [
            {
              "population" : "100000000000",
              "terrain" : "rock, desert, mountain, barren",
              "edited" : "2014-12-20T20:58:18.437000Z",
              "diameter" : "11370",
              "residents" : [
                "https://swapi.dev/api/people/63/"
              ],
              "orbital_period" : "256",
              "surface_water" : "5",
              "rotation_period" : "30",
              "gravity" : "0.9 standard",
              "films" : [
                "https://swapi.dev/api/films/5/"
              ],
              "url" : "https://swapi.dev/api/planets/11/",
              "created" : "2014-12-10T12:47:22.350000Z",
              "climate" : "temperate, arid",
              "name" : "Geonosis"
            },
            {
              "population" : "95000000",
              "terrain" : "scrublands, savanna, canyons, sinkholes",
              "edited" : "2014-12-20T20:58:18.439000Z",
              "diameter" : "12900",
              "residents" : [
                "https://swapi.dev/api/people/83/"
              ],
              "orbital_period" : "351",
              "surface_water" : "0.9",
              "rotation_period" : "27",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/12/",
              "created" : "2014-12-10T12:49:01.491000Z",
              "climate" : "temperate, arid, windy",
              "name" : "Utapau"
            },
            {
              "population" : "20000",
              "terrain" : "volcanoes, lava rivers, mountains, caves",
              "edited" : "2014-12-20T20:58:18.440000Z",
              "diameter" : "4200",
              "residents" : [

              ],
              "orbital_period" : "412",
              "surface_water" : "0",
              "rotation_period" : "36",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/13/",
              "created" : "2014-12-10T12:50:16.526000Z",
              "climate" : "hot",
              "name" : "Mustafar"
            },
            {
              "population" : "45000000",
              "terrain" : "jungle, forests, lakes, rivers",
              "edited" : "2014-12-20T20:58:18.442000Z",
              "diameter" : "12765",
              "residents" : [
                "https://swapi.dev/api/people/13/",
                "https://swapi.dev/api/people/80/"
              ],
              "orbital_period" : "381",
              "surface_water" : "60",
              "rotation_period" : "26",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/14/",
              "created" : "2014-12-10T13:32:00.124000Z",
              "climate" : "tropical",
              "name" : "Kashyyyk"
            },
            {
              "population" : "1000000",
              "terrain" : "airless asteroid",
              "edited" : "2014-12-20T20:58:18.444000Z",
              "diameter" : "0",
              "residents" : [

              ],
              "orbital_period" : "590",
              "surface_water" : "0",
              "rotation_period" : "24",
              "gravity" : "0.56 standard",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/15/",
              "created" : "2014-12-10T13:33:46.405000Z",
              "climate" : "artificial temperate ",
              "name" : "Polis Massa"
            },
            {
              "population" : "19000000",
              "terrain" : "glaciers, mountains, ice canyons",
              "edited" : "2014-12-20T20:58:18.446000Z",
              "diameter" : "10088",
              "residents" : [

              ],
              "orbital_period" : "167",
              "surface_water" : "unknown",
              "rotation_period" : "12",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/16/",
              "created" : "2014-12-10T13:43:39.139000Z",
              "climate" : "frigid",
              "name" : "Mygeeto"
            },
            {
              "population" : "8500000",
              "terrain" : "fungus forests",
              "edited" : "2014-12-20T20:58:18.447000Z",
              "diameter" : "9100",
              "residents" : [

              ],
              "orbital_period" : "231",
              "surface_water" : "unknown",
              "rotation_period" : "34",
              "gravity" : "0.75 standard",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/17/",
              "created" : "2014-12-10T13:44:50.397000Z",
              "climate" : "hot, humid",
              "name" : "Felucia"
            },
            {
              "population" : "10000000",
              "terrain" : "mountains, fields, forests, rock arches",
              "edited" : "2014-12-20T20:58:18.449000Z",
              "diameter" : "0",
              "residents" : [
                "https://swapi.dev/api/people/33/"
              ],
              "orbital_period" : "278",
              "surface_water" : "unknown",
              "rotation_period" : "25",
              "gravity" : "1 standard",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/18/",
              "created" : "2014-12-10T13:46:28.704000Z",
              "climate" : "temperate, moist",
              "name" : "Cato Neimoidia"
            },
            {
              "population" : "1400000000",
              "terrain" : "caves, desert, mountains, volcanoes",
              "edited" : "2014-12-20T20:58:18.450000Z",
              "diameter" : "14920",
              "residents" : [

              ],
              "orbital_period" : "392",
              "surface_water" : "unknown",
              "rotation_period" : "26",
              "gravity" : "unknown",
              "films" : [
                "https://swapi.dev/api/films/6/"
              ],
              "url" : "https://swapi.dev/api/planets/19/",
              "created" : "2014-12-10T13:47:46.874000Z",
              "climate" : "hot",
              "name" : "Saleucami"
            },
            {
              "population" : "unknown",
              "terrain" : "grass",
              "edited" : "2014-12-20T20:58:18.452000Z",
              "diameter" : "0",
              "residents" : [
                "https://swapi.dev/api/people/10/"
              ],
              "orbital_period" : "unknown",
              "surface_water" : "unknown",
              "rotation_period" : "unknown",
              "gravity" : "1 standard",
              "films" : [

              ],
              "url" : "https://swapi.dev/api/planets/20/",
              "created" : "2014-12-10T16:16:26.566000Z",
              "climate" : "temperate",
              "name" : "Stewjon"
            }
          ],
          "count" : 60,
          "next" : null
        }
        """
    }
    
    static var planetDetailsJSON: String {
        """
        {
          "population" : "2000000000",
          "terrain" : "grasslands, mountains",
          "edited" : "2014-12-20T20:58:18.420000Z",
          "diameter" : "12500",
          "residents" : [
            "https://swapi.dev/api/people/5/",
            "https://swapi.dev/api/people/68/",
            "https://swapi.dev/api/people/81/"
          ],
          "orbital_period" : "364",
          "surface_water" : "40",
          "rotation_period" : "24",
          "gravity" : "1 standard",
          "films" : [
            "https://swapi.dev/api/films/1/",
            "https://swapi.dev/api/films/6/"
          ],
          "url" : "https://swapi.dev/api/planets/2/",
          "created" : "2014-12-10T11:35:48.479000Z",
          "climate" : "temperate",
          "name" : "Alderaan"
        }
        """
    }
}

#endif
