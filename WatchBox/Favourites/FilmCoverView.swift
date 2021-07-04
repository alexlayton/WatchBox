//
//  MediaView.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import SwiftUI

struct FilmCoverView: View {
    
    let film: Film
    
    let image: UIImage?
    
    var body: some View {
        ZStack {
            Color.black
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text(film.title)
                    .foregroundColor(.white)
            }
        }
        .cornerRadius(10.0)
    }
}

extension Film: Identifiable {
    
    // TODO: We want to change this to rotten tomatoes id at somepoint
    var id: String {
        return title
    }
}

struct FilmCoverView_Previews: PreviewProvider {
    
    static let films: [(Film, UIImage?)] = [
        film(title: "Tenet", imageName: "tenet"),
        film(title: "Dunkirk", imageName: "dunkirk"),
        film(title: "Batman Begins", imageName: "nil"),
    ]
    
    static func film(title: String, imageName: String?) -> (Film, UIImage?) {
        let film = Film(title: title, posterURL: "", actors: "", plot: "", year: "")
        var image: UIImage? = nil
        if let imageName = imageName {
            image = UIImage(named: imageName)
        }
        return (film, image)
    }
    
    static var previews: some View {
        Group {
            FilmCoverView(film: films[0].0, image: films[0].1)
                .frame(width: 200, height: 300)
            FilmCoverView(film: films[1].0, image: films[1].1)
                .frame(width: 128, height: 192)
            FilmCoverView(film: films[2].0, image: films[2].1)
                .frame(width: 128, height: 192)
        }
    }
}
