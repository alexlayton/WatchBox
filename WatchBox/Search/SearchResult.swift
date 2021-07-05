//
//  SearchResult.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import UIKit

struct SearchResult {
    let data: SearchResultRepresentable
    let isAdded: Bool
    let hasDisclosure: Bool
}

protocol SearchResultRepresentable {
    var title: String { get }
    var posterURL: String { get }
}

extension OMDBResponse: SearchResultRepresentable {
    var posterURL: String {
        return poster
    }
    
    var searchResult: SearchResult {
        return SearchResult(data: self, isAdded: false, hasDisclosure: false)
    }
}

extension Film: SearchResultRepresentable {}

extension FilmEntity {
    var searchResult: SearchResult {
        return SearchResult(data: film, isAdded: true, hasDisclosure: true)
    }
}
