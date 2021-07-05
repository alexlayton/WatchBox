//
//  WatchBoxStoreTests.swift
//  WatchBoxTests
//
//  Created by Alex Layton on 05/07/2021.
//

import XCTest
import CoreData
@testable import WatchBox

class WatchBoxStoreTests: XCTestCase {
    
    var dataStore: WatchBoxStore!
    
    var responses: [OMDBResponse]!
    
    override func setUpWithError() throws {
        dataStore = try WatchBoxTestsUtils.inMemoryWatchBoxStore()
        responses = try WatchBoxTestsUtils.omdbResponses()
    }

    func testAddFilms() throws {
        for (i, response) in responses.enumerated() {
            
            // Add a film to the store
            try dataStore.addFilm(from: response)
            
            // Check the number of films in the store is correct
            let fetchRequest: NSFetchRequest<FilmEntity> = FilmEntity.fetchRequest()
            let results = try dataStore.viewContext.fetch(fetchRequest)
            XCTAssertTrue(results.count == i + 1, "Expected \(i + 1) results, actual: \(results.count)")
        }
    }
    
    func testFilmsByTitle() throws {
        guard let response = responses.first(where: { $0.title == "Inception" }) else {
            throw TestingError("No film called Inception")
        }
        
        try dataStore.addFilm(from: response)
    
        struct TestCase {
            let searchText: String
            let expectedCount: Int
        }
        
        let testCases: [TestCase] = [
            .init(searchText: "Inception", expectedCount: 1),
            .init(searchText: "cep", expectedCount: 1),
            .init(searchText: "tion", expectedCount: 1),
            .init(searchText: "Dunkirk", expectedCount: 0)
        ]
        
        // Check that the correct number of results exist for a given search text
        for testCase in testCases {
            let films = try dataStore.filmsByTitle(containing: testCase.searchText)
            XCTAssertTrue(testCase.expectedCount == films.count)
        }
    }
    
    func testFilmsByID() throws {
        
        // Add the films to the store
        for response in responses {
            try dataStore.addFilm(from: response)
        }

        let responseIDs = responses.map { ($0.imdbID, $0.title) }
        
        // Check the id exists in the store
        for (id, title) in responseIDs {
            let film = try dataStore.filmByID(id)
            XCTAssertNotNil(film)
            XCTAssertEqual(title, film!.title)
        }
    }
    
    func testDelete() throws {
        for response in responses {
            try dataStore.addFilm(from: response)
        }
        
        guard let response = responses.first(where: { $0.title == "Inception" }) else {
            throw TestingError("No film called Inception")
        }
        
        guard let film = try dataStore.filmByID(response.imdbID) else {
            throw TestingError("Film doesn't exist in store")
        }
        
        try dataStore.delete(film: film)
        
        // Check Inception has been deleted from the store
        let fetchRequest: NSFetchRequest<FilmEntity> = FilmEntity.fetchRequest()
        let results = try dataStore.viewContext.fetch(fetchRequest)
        XCTAssertTrue(results.count == responses.count - 1)
        for result in results {
            if result.imdbID == response.imdbID {
                XCTFail("The correct film wasn't deleted from the store")
            }
        }
    }
}
