//
//  OMDBClient.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import Combine

enum OMDBError: Error {
    case invalidURL
    case invalidResponse
}

protocol OMDBProvider {
    func titleSearch(request: TitleRequest) -> AnyPublisher<OMDBResponse, Error>
}

struct OMDBClient: OMDBProvider {
    
    private static let baseURLString = "http://www.omdbapi.com"
    
    private static let apiKey = "2082b5f2"
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    func titleSearch(request: TitleRequest) -> AnyPublisher<OMDBResponse, Error> {
        guard var components = URLComponents(string: Self.baseURLString) else {
            return Fail(outputType: OMDBResponse.self, failure: OMDBError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var queryItems = [
            URLQueryItem(name: "apikey", value: Self.apiKey),
            URLQueryItem(name: "t", value: request.title)
        ]
        
        if let type = request.mediaType {
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
        }
        
        if let plot = request.plot {
            queryItems.append(URLQueryItem(name: "plot", value: plot.rawValue))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return Fail(outputType: OMDBResponse.self, failure: OMDBError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let session = URLSession.shared
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw  OMDBError.invalidResponse
                }
                return data
            }
            .decode(type: OMDBResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

struct TitleRequest {
    
    // MARK: Types
    enum MediaType: String {
        case movie, series, episode
    }
    
    enum Plot: String {
        case short, full
    }
    
    // MARK: Properties
    let title: String
    let mediaType: MediaType?
    let plot: Plot?
    
    // MARK: Initializers
    
    init(title: String, mediaType: MediaType? = nil, plot: Plot? = nil) {
        self.title = title
        self.mediaType = mediaType
        self.plot = plot
    }
}
