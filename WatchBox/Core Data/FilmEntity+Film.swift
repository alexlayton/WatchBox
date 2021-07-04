//
//  FilmEntity+Film.swift
//  WatchBox
//
//  Created by Alex Layton on 03/07/2021.
//

import Foundation
import UIKit

struct Film {
    
    static let `default` = Film(title: "", posterURL: "", actors: "", plot: "", year: "")
    
    let title: String
    let posterURL: String
    let actors: String
    let plot: String
    let year: String
}

extension FilmEntity {
    var film: Film {
        return .init(title: title ?? "", posterURL: posterURL ?? "", actors: actors ?? "", plot: plot ?? "", year: year ?? "")
    }
}
