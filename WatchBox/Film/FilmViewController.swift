//
//  FilmViewController.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class FilmViewController: UIViewController {
    
    // MARK: Properties
    
    static let storyboardIdentifier = "Film"
    
    var viewModel: FilmViewModel?
    
    private var hostingController: UIHostingController<FilmView>?
    
    private var imageCancellable: AnyCancellable?
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if let film = viewModel?.film.film {
            let filmView = FilmView(film: film, image: nil)
            hostingController?.rootView = filmView
        }
        
        navigationItem.title = viewModel?.film.title
        fetchImage()
    }
    
    // MARK: -
    
    private func fetchImage() {
        guard let film = viewModel?.film.film else {
            return
        }
        print("Fetching image - \(film.posterURL)")
        imageCancellable = ImageCache.shared
            .get(url: film.posterURL)
            .receive(on: DispatchQueue.main)
            .sink { image in
                self.hostingController?.rootView = FilmView(film: film, image: image)
            }
    }
    
    private func setupViews() {
        hostingController = UIHostingController<FilmView>(rootView: FilmView(film: .default, image: nil))
        guard let hostingView = hostingController?.view else {
            return
        }
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
}
