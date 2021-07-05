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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let film: Film
    
    let image: UIImage?
    
    @State var rating: Int
    
    var ratingHandler: ((Int) -> ())?
    
    init(film: Film, image: UIImage? = nil, initialRating: Int = 0, ratingHandler: ((Int) -> ())? = nil) {
        self.film = film
        self.image = image
        self._rating = State(initialValue: initialRating)
        self.ratingHandler = ratingHandler
    }
    
    var body: some View {
        filmView
            .onChange(of: rating) { value in
                ratingHandler?(value)
            }
    }
    
    var filmView: AnyView {
        if horizontalSizeClass == .compact {
            return AnyView(verticalLayout)
        }
        return AnyView(horizontalLayout)
    }
    
    var horizontalLayout: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding([.top])
            }
            ScrollView {
                filmDetails
                    .padding()
            }
        }
    }
    
    var verticalLayout: some View {
        ScrollView {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                }
                filmDetails
            }
            .padding()
        }
    }
    
    var filmDetails: some View {
        VStack(spacing: 8.0) {
            Text(film.title)
                .font(.largeTitle)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            Text(film.year)
            RatingView(rating: $rating)
            Text(film.plot)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(film.actors)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }
    
}

struct FilmView_Previews: PreviewProvider {
    
    static let film = Film(title: "Tenet", posterURL: "https://m.media-amazon.com/images/M/MV5BYzg0NGM2NjAtNmIxOC00MDJmLTg5ZmYtYzM0MTE4NWE2NzlhXkEyXkFqcGdeQXVyMTA4NjE0NjEy._V1_SX300.jpg", actors: "Juhan Ulfsak, Jefferson Hall, Ivo Uukkivi, Andrew Howard", plot: "Armed with only one word, Tenet, and fighting for the survival of the entire world, a Protagonist journeys through a twilight world of international espionage on a mission that will unfold in something beyond real time.", year: "2020")
    
    static let image = UIImage(named: "tenet")
    
    static var previews: some View {
        Group {
            FilmView(film: film, image: image, initialRating: 5)
        }
    }
}
