//
//  StarWarsUseCaseProtocolMock.swift
//  StarWarsAPIViewerTests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

@testable import StarWarsAPIViewer

final class StarWarsUseCaseProtocolMock: StarWarsUseCaseProtocol {
    // MARK: - planetsFirstPage
    
    var planetsFirstPageCallsCount = 0
    var planetsFirstPageCalled: Bool {
        planetsFirstPageCallsCount > 0
    }
    var planetsFirstPageCompletionClosure: (() async throws -> PlanetsPage)?
    var planetsFirstPageReturnValue: PlanetsPage?
    
    func planetsFirstPage() async throws -> PlanetsPage {
        planetsFirstPageCallsCount += 1
        return try await planetsFirstPageCompletionClosure?() ?? planetsFirstPageReturnValue!
    }
    
    // MARK: - planetsNextPageurl
    
    var planetsNextPageCallsCount = 0
    var planetsNextPageCalled: Bool {
        planetsNextPageCallsCount > 0
    }
    var planetsNextPageReceivedArguments: [String] = []
    var planetsNextPageCompletionClosure: ((String) async throws -> PlanetsPage)?
    var planetsNextPageReturnValue: PlanetsPage?
    
    func planetsNextPage(url: String) async throws -> PlanetsPage {
        planetsNextPageCallsCount += 1
        planetsNextPageReceivedArguments.append(url)
        return try await planetsNextPageCompletionClosure?(url) ?? planetsNextPageReturnValue!
    }
    
    // MARK: - planetDetailsid
    
    var planetDetailsCallsCount = 0
    var planetDetailsCalled: Bool {
        planetDetailsCallsCount > 0
    }
    var planetDetailsReceivedId: Int?
    var planetDetailsCompletionClosure: ((Int) async throws -> Planet)?
    var planetDetailsReturnValue: Planet?
    
    func planetDetails(id: Int) async throws -> Planet {
        planetDetailsCallsCount += 1
        planetDetailsReceivedId = id
        return try await planetDetailsCompletionClosure?(id) ?? planetDetailsReturnValue!
    }
}
