//
//  FilmView.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import SwiftUI
import UIKit

struct FilmView: View {
    
    let film: Film
    
    let image: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16.0) {
                if let image = image {
                    Image(uiImage: image)
                }
                HStack(alignment: .center) {
                    Text(film.title)
                        .font(.largeTitle)
                    Text(film.year)
                }
                Text(film.plot)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text(film.actors)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
}

struct FilmView_Previews: PreviewProvider {
    
    static let film = Film(title: "Tenet", posterURL: "https://m.media-amazon.com/images/M/MV5BYzg0NGM2NjAtNmIxOC00MDJmLTg5ZmYtYzM0MTE4NWE2NzlhXkEyXkFqcGdeQXVyMTA4NjE0NjEy._V1_SX300.jpg", actors: "Juhan Ulfsak, Jefferson Hall, Ivo Uukkivi, Andrew Howard", plot: "Armed with only one word, Tenet, and fighting for the survival of the entire world, a Protagonist journeys through a twilight world of international espionage on a mission that will unfold in something beyond real time.", year: "2020")
    
    static let image = UIImage(named: "tenet")
    
    static var previews: some View {
        Group {
            FilmView(film: film, image: image)
        }
    }
}
