//
//  RatingView.swift
//  WatchBox
//
//  Created by Alex Layton on 05/07/2021.
//

import Foundation
import SwiftUI

struct RatingView: View {
    
    static let maxRating = 5
    
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<Self.maxRating + 1) { value in
                image(for: value)
                    .onTapGesture {
                        rating = value
                    }
            }
        }
        .foregroundColor(.blue)
        .frame(height: 44.0)
    }
    
    private func image(for value: Int) -> some View {
        if value > rating {
            return Image(systemName: "star")
        } else {
            return Image(systemName: "star.fill")
        }
    }
}

struct RatingView_Previews: PreviewProvider {

    static var previews: some View {
        RatingView(rating: .constant(1))
    }

}
