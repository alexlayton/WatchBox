//
//  SearchViewModelTests.swift
//  WatchBoxTests
//
//  Created by Alex Layton on 05/07/2021.
//

import XCTest
import Combine
@testable import WatchBox

class SearchViewModelTests: XCTestCase {

    var searchViewModel: SearchViewModel!
    
    override func setUpWithError() throws {
        let responses = try WatchBoxTestsUtils.omdbResponses()
        let dataStore = try WatchBoxTestsUtils.inMemoryWatchBoxStore()
        
        for response in responses {
            try dataStore.addFilm(from: response)
        }
        
        searchViewModel = SearchViewModel(provider: MockOMDBClient(responses: responses), dataStore: dataStore)
    }

    func testSearching() throws {
        
        // Set the search text and see if the expected results exist
        searchViewModel.searchText = "Inception"
        
        // Since the view model uses a 1 second debounce,
        // wait for the results to be searched for
        wait(for: 2.0)
        
        XCTAssertTrue(searchViewModel.favourites.count == 1)
        XCTAssertTrue(searchViewModel.favourites.first?.title == "Inception")
        XCTAssertNotNil(searchViewModel.omdbResponse)
    }

}

extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    waitForExpectations(timeout: duration)
  }
    
}

struct MockOMDBClient: OMDBProvider {
    
    let responses: [OMDBResponse]

    init(responses: [OMDBResponse]) {
        self.responses = responses
    }

    func titleSearch(request: TitleRequest) -> AnyPublisher<OMDBResponse, Error> {
        guard let response = responses.first(where: { $0.title == request.title }) else {
            return Fail<OMDBResponse, Error>(error: OMDBError.invalidResponse)
                .eraseToAnyPublisher()
        }
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

