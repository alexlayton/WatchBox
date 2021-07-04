//
//  EmptyView.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import SwiftUI

struct EmptyView: View {
    
    var body: some View {
        VStack(spacing: 20.0) {
            Image(systemName: "film")
                .font(.system(size: 44.0))
            Text("No Favourites")
                .font(.headline)
            Text("Search to add some films to your favourites")
                .font(.subheadline)
        }
    }
    
}

struct EmptyView_Previews: PreviewProvider {

    static var previews: some View {
        EmptyView()
    }
}
