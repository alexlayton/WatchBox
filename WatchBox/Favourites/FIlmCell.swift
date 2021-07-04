//
//  FilmCell.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class FilmCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseIdentifier = "FilmCell"
    
    var film: Film? {
        didSet {
            if let film = film {
                hostingController?.rootView = FilmCoverView(film: film, image: nil)
                fetchImage()
            }
        }
    }
    
    private var hostingController: UIHostingController<FilmCoverView>?
    
    private var imageCancellable: AnyCancellable?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    // MARK: UICollectionViewCell
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageCancellable?.cancel()
    }
    
    // MARK: -
    
    private func configureViews() {
        hostingController = UIHostingController(rootView: FilmCoverView(film: .default, image: nil))
        guard let view = hostingController?.view else {
            fatalError("Cannot add FilmView to cell")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        contentView.addConstraints([
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func fetchImage() {
        guard let film = film else {
            return
        }
        print("Fetching image - \(film.posterURL)")
        imageCancellable = ImageCache.shared
            .get(url: film.posterURL)
            .receive(on: DispatchQueue.main)
            .sink { image in
                self.hostingController?.rootView = FilmCoverView(film: film, image: image)
            }
    }
    
}
