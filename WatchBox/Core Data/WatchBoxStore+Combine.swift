//
//  WatchBoxStore+Combine.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import Combine

extension WatchBoxStore {
    
    func filmsByTitlePublisher(containing text: String) -> AnyPublisher<[FilmEntity], Error> {
        let future = Future<[FilmEntity], Error> { promise in
            do {
                let results = try self.filmsByTitle(containing: text)
                promise(.success(results))
            } catch {
                promise(.failure(error))
            }
        }
        return future.eraseToAnyPublisher()
    }
    
    func filmByIDPublisher(id: String) -> AnyPublisher<FilmEntity?, Error> {
        let future = Future<FilmEntity?, Error> { promise in
            do {
                let results = try self.filmByID(id)
                promise(.success(results))
            } catch {
                promise(.failure(error))
            }
        }
        return future.eraseToAnyPublisher()
    }

}
