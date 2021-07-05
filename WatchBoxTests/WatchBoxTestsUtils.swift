//
//  WatchBoxTestsUtils.swift
//  WatchBoxTests
//
//  Created by Alex Layton on 05/07/2021.
//

import Foundation
import CoreData
@testable import WatchBox

struct WatchBoxTestsUtils {

    static func inMemoryWatchBoxStore() throws -> WatchBoxStore {
        let lock = DispatchSemaphore(value: 0)
        
        // Create in memory store for testing purposes
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        let dataStore = WatchBoxStore()
        dataStore.persistentStoreDescriptions = [description]
        
        var error: Error?
        dataStore.loadPersistentStores { _, internalError in
            error = internalError
            lock.signal()
        }
        
        lock.wait()
        
        if let error = error {
            throw error
        }
        
        return dataStore
    }
    
    static func omdbResponses() throws -> [OMDBResponse] {
        let decoder = JSONDecoder()
        let responses = try filmsJSONArray.compactMap { jsonString throws -> OMDBResponse? in
            guard let data = jsonString.data(using: .utf8) else {
                return nil
            }
            return try decoder.decode(OMDBResponse.self, from: data)
        }
        return responses
    }
    
    private static let filmsJSONArray: [String] = [
        #"{"Title":"Tenet","Year":"2020","Rated":"PG-13","Released":"03 Sep 2020","Runtime":"150 min","Genre":"Action, Sci-Fi, Thriller","Director":"Christopher Nolan","Writer":"Christopher Nolan","Actors":"Juhan Ulfsak, Jefferson Hall, Ivo Uukkivi, Andrew Howard","Plot":"Armed with only one word, Tenet, and fighting for the survival of the entire world, a Protagonist journeys through a twilight world of international espionage on a mission that will unfold in something beyond real time.","Language":"English, Russian, Ukrainian, Estonian, Norwegian, Hindi","Country":"USA, UK","Awards":"Won 1 Oscar. Another 41 wins & 133 nominations.","Poster":"https://m.media-amazon.com/images/M/MV5BYzg0NGM2NjAtNmIxOC00MDJmLTg5ZmYtYzM0MTE4NWE2NzlhXkEyXkFqcGdeQXVyMTA4NjE0NjEy._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"7.4/10"},{"Source":"Rotten Tomatoes","Value":"70%"},{"Source":"Metacritic","Value":"69/100"}],"Metascore":"69","imdbRating":"7.4","imdbVotes":"369,622","imdbID":"tt6723592","Type":"movie","DVD":"15 Dec 2020","BoxOffice":"$58,456,624","Production":"Syncopy, Warner Bros. Pictures","Website":"N/A","Response":"True"}"#,
        #"{"Title":"Batman Begins","Year":"2005","Rated":"PG-13","Released":"15 Jun 2005","Runtime":"140 min","Genre":"Action, Adventure","Director":"Christopher Nolan","Writer":"Bob Kane, David S. Goyer, Christopher Nolan","Actors":"Christian Bale, Michael Caine, Ken Watanabe","Plot":"After training with his mentor, Batman begins his fight to free crime-ridden Gotham City from corruption.","Language":"English, Mandarin","Country":"United Kingdom, United States","Awards":"Nominated for 1 Oscar. 13 wins & 79 nominations total","Poster":"https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"8.2/10"},{"Source":"Rotten Tomatoes","Value":"84%"},{"Source":"Metacritic","Value":"70/100"}],"Metascore":"70","imdbRating":"8.2","imdbVotes":"1,334,626","imdbID":"tt0372784","Type":"movie","DVD":"09 Sep 2009","BoxOffice":"$206,852,432","Production":"Warner Brothers, Di Bonaventura Pictures","Website":"N/A","Response":"True"}"#,
        #"{"Title":"Inception","Year":"2010","Rated":"PG-13","Released":"16 Jul 2010","Runtime":"148 min","Genre":"Action, Adventure, Sci-Fi, Thriller","Director":"Christopher Nolan","Writer":"Christopher Nolan","Actors":"Leonardo DiCaprio, Joseph Gordon-Levitt, Elliot Page, Tom Hardy","Plot":"A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.","Language":"English, Japanese, French","Country":"USA, UK","Awards":"Won 4 Oscars. Another 153 wins & 220 nominations.","Poster":"https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"8.8/10"},{"Source":"Rotten Tomatoes","Value":"87%"},{"Source":"Metacritic","Value":"74/100"}],"Metascore":"74","imdbRating":"8.8","imdbVotes":"2,124,584","imdbID":"tt1375666","Type":"movie","DVD":"20 Jun 2013","BoxOffice":"$292,576,195","Production":"Syncopy, Warner Bros.","Website":"N/A","Response":"True"}"#,
        #"{"Title":"Dunkirk","Year":"2017","Rated":"PG-13","Released":"21 Jul 2017","Runtime":"106 min","Genre":"Action, Drama, History, Thriller, War","Director":"Christopher Nolan","Writer":"Christopher Nolan","Actors":"Fionn Whitehead, Damien Bonnard, Aneurin Barnard, Lee Armstrong","Plot":"Allied soldiers from Belgium, the British Commonwealth and Empire, and France are surrounded by the German Army and evacuated during a fierce battle in World War II.","Language":"English, French, German","Country":"UK, Netherlands, France, USA","Awards":"Won 3 Oscars. Another 60 wins & 230 nominations.","Poster":"https://m.media-amazon.com/images/M/MV5BN2YyZjQ0NTEtNzU5MS00NGZkLTg0MTEtYzJmMWY3MWRhZjM2XkEyXkFqcGdeQXVyMDA4NzMyOA@@._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"7.8/10"},{"Source":"Rotten Tomatoes","Value":"92%"},{"Source":"Metacritic","Value":"94/100"}],"Metascore":"94","imdbRating":"7.8","imdbVotes":"577,647","imdbID":"tt5013056","Type":"movie","DVD":"12 Dec 2017","BoxOffice":"$189,740,665","Production":"Warner Bros. Pictures, IMAX Corporation","Website":"N/A","Response":"True"}"#
    ]
    
}
