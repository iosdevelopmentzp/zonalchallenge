//
//  PlanetsViewModelTests.swift
//  StarWarsAPIViewerTests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import XCTest
import Combine
@testable import StarWarsAPIViewer

@MainActor
final class PlanetsViewModelTests: XCTestCase {
    // MARK: - Properties
    
    private var starWarsUseCase: StarWarsUseCaseProtocolMock!
    private var sceneDelegate: PlanetsViewSceneDelegateMock!
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Override
    
    override func setUpWithError() throws {
        starWarsUseCase = StarWarsUseCaseProtocolMock()
        sceneDelegate = PlanetsViewSceneDelegateMock()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        starWarsUseCase = nil
        sceneDelegate = nil
        cancellables = []
    }
    
    // MARK: - Tests
    
    func test_state_successfulFirstPageResponse_correctStateScenario() {
        mockFirstPageResponse(isError: false)
        let sut = makeSUT()
        
        let states = waitStatusUpdates(expectedCount: 3, sut: sut) {
            sut.handle(.viewDidLoad)
        }
        
        XCTAssertTrue(states.count == 3)
        XCTAssertTrue(states[0].isIdle)
        XCTAssertTrue(states[1].isRefreshing)
        XCTAssertTrue(states[2].isLoaded)
        XCTAssertTrue(sut.state.isLoaded)
        XCTAssertEqual(sut.state.planets.count, 5)
        XCTAssertEqual(starWarsUseCase.planetsFirstPageCallsCount, 1)
    }
    
    func test_state_failedFirstPageResponse_correctStateScenario() {
        mockFirstPageResponse(isError: true)
        let sut = makeSUT()
        
        let states = waitStatusUpdates(expectedCount: 3, sut: sut) {
            sut.handle(.viewDidLoad)
        }
        
        XCTAssertTrue(states.count == 3)
        XCTAssertTrue(states[0].isIdle)
        XCTAssertTrue(states[1].isRefreshing)
        XCTAssertTrue(states[2].isFailedLoading)
        XCTAssertTrue(sut.state.isFailedLoading)
        XCTAssertEqual(starWarsUseCase.planetsFirstPageCallsCount, 1)
    }
    
    func test_state_failedFirstPageResponseThenSuccessfulRetry_correctStateScenario() {
        mockFirstPageResponse(isError: true)
        let sut = makeSUT()
        
        _ = waitStatusUpdates(expectedCount: 3, sut: sut) {
            sut.handle(.viewDidLoad)
        }
        
        XCTAssertTrue(sut.state.isFailedLoading)
        
        mockFirstPageResponse(isError: false)
        
        let afterRetryStatuses = waitStatusUpdates(expectedCount: 2, sut: sut) {
            sut.handle(.didTapTryAgain)
        }

        XCTAssertTrue(afterRetryStatuses.count == 2)
        XCTAssertTrue(afterRetryStatuses[0].isRefreshing)
        XCTAssertTrue(afterRetryStatuses[1].isLoaded)
        XCTAssertTrue(sut.state.isLoaded)
        XCTAssertEqual(sut.state.planets.count, 5)
        XCTAssertEqual(starWarsUseCase.planetsFirstPageCallsCount, 2)
    }
    
    func test_state_successfulFirstPageAndSuccessfulNextLoading_correctStateScenario() {
        mockFirstPageResponse(isError: false)
        mockNextPageResponse(isError: false)
        
        let sut = makeSUT()
        
        _ = waitStatusUpdates(expectedCount: 3, sut: sut) {
            sut.handle(.viewDidLoad)
        }
        
        XCTAssertTrue(sut.state.isLoaded)
        
        let statuses = waitStatusUpdates(expectedCount: 2, sut: sut) {
            sut.handle(.didReachBottom)
        }

        XCTAssertTrue(statuses.count == 2)
        XCTAssertTrue(statuses[0].isLoading)
        XCTAssertTrue(statuses[1].isLoaded)
        XCTAssertTrue(sut.state.isLoaded)
        XCTAssertEqual(sut.state.planets.count, 10)
        XCTAssertEqual(starWarsUseCase.planetsNextPageReceivedArguments, ["https://nextpageurl/"])
        XCTAssertEqual(starWarsUseCase.planetsFirstPageCallsCount, 1)
        XCTAssertEqual(starWarsUseCase.planetsNextPageCallsCount, 1)
    }
    
    func test_state_successfulFirstPageAndFailedNextLoading_correctStateScenario() {
        mockFirstPageResponse(isError: false)
        mockNextPageResponse(isError: true)
        
        let sut = makeSUT()
        
        _ = waitStatusUpdates(expectedCount: 3, sut: sut) {
            sut.handle(.viewDidLoad)
        }
        
        XCTAssertTrue(sut.state.isLoaded)
        
        let statuses = waitStatusUpdates(expectedCount: 2, sut: sut) {
            sut.handle(.didReachBottom)
        }

        XCTAssertTrue(statuses.count == 2)
        XCTAssertTrue(statuses[0].isLoading)
        XCTAssertTrue(statuses[1].isFailedLoading)
        XCTAssertTrue(sut.state.isFailedLoading)
        XCTAssertEqual(sut.state.planets.count, 5)
        XCTAssertEqual(starWarsUseCase.planetsFirstPageCallsCount, 1)
        XCTAssertEqual(starWarsUseCase.planetsNextPageCallsCount, 1)
    }
    
    func test_delegateCall_didTapItem_delegateMethodHasBeenCalled() {
        mockFirstPageResponse(isError: false)
        let sut = makeSUT()
        
        _ = waitStatusUpdates(expectedCount: 3, sut: sut) {
            sut.handle(.viewDidLoad)
        }
        
        XCTAssertTrue(sut.state.isLoaded)
        
        sut.handle(.didTapItem(id: 3))
        
        XCTAssertTrue(sceneDelegate.openPlanetDetailsCalled)
        XCTAssertEqual(sceneDelegate.openPlanetDetailsCallsCount, 1)
        XCTAssertEqual(sceneDelegate.openPlanetDetailsReceivedPlanetId, 3)
    }
}

private extension PlanetsViewModelTests {
    func makeSUT() -> PlanetsViewModel {
        .init(
            useCase: starWarsUseCase,
            sceneDelegate: sceneDelegate
        )
    }
    
    func waitStatusUpdates(
        expectedCount: Int,
        sut: PlanetsViewModel,
        actionBeforeExpecting: () -> Void
    ) -> [PlanetsViewState] {
        let expectation = XCTestExpectation(description: "Expected number of state toggles")
        
        var states: [PlanetsViewState] = []
        
        sut.$state
            .dropFirst()
            .sink(
                receiveCompletion: { _ in
                    XCTFail("Unexpected completion")
                }, receiveValue: {
                    states.append($0)
                    
                    if states.count == expectedCount {
                        expectation.fulfill()
                    }
                }
            )
            .store(in: &cancellables)
        
        actionBeforeExpecting()
        
        wait(for: [expectation], timeout: 1)
        
        return states
    }
    
    func mockFirstPageResponse(isError: Bool) {
        starWarsUseCase.planetsFirstPageCompletionClosure = {
            if isError {
                throw MockedError.localizedDescription("Load first page error")
            } else {
                return .fixture(
                    next: "https://nextpageurl/",
                    planets: [
                        .fixture(url: "https://swapi.dev/api/planets/1/", name: "1planet", terrain: "terrain1", population: "10000"),
                        .fixture(url: "https://swapi.dev/api/planets/2", name: "2planet", terrain: "terrain2", population: "20000"),
                        .fixture(url: "https://swapi.dev/api/planets/3/", name: "3planet", terrain: "terrain3", population: "30000"),
                        .fixture(url: "https://swapi.dev/api/planets/4/", name: "4planet", terrain: "terrain4", population: "40000"),
                        .fixture(url: "https://swapi.dev/api/planets/5/", name: "5planet", terrain: "terrain5", population: "50000")
                    ]
                )
            }
        }
    }
    
    func mockNextPageResponse(isError: Bool) {
        starWarsUseCase.planetsNextPageCompletionClosure = { _ in
            if isError {
                throw MockedError.localizedDescription("Load next page error")
            } else {
                return .fixture(
                    next: nil,
                    planets: [
                        .fixture(url: "https://swapi.dev/api/planets/6/", name: "6planet", terrain: "terrain6", population: "60000"),
                        .fixture(url: "https://swapi.dev/api/planets/7/", name: "7planet", terrain: "terrain7", population: "70000"),
                        .fixture(url: "https://swapi.dev/api/planets/8/", name: "8planet", terrain: "terrain8", population: "80000"),
                        .fixture(url: "https://swapi.dev/api/planets/9/", name: "9planet", terrain: "terrain9", population: "90000"),
                        .fixture(url: "https://swapi.dev/api/planets/10/", name: "10planet", terrain: "terrain10", population: "100000")
                    ]
                )
            }
        }
    }
}
