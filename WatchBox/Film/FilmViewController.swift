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
        
        guard let viewModel = viewModel else {
            return
        }
        let film = viewModel.filmEntity.film
        let filmView = FilmView(film: film,
                                initialRating: Int(viewModel.filmEntity.rating),
                                ratingHandler: self.onRatingChange)
        hostingController?.rootView = filmView
        navigationItem.title = film.title
        fetchImage()
    }
    
    // MARK: -
    
    private func fetchImage() {
        guard let viewModel = viewModel else {
            return
        }
        let film = viewModel.filmEntity.film
        print("Fetching image - \(film.posterURL)")
        imageCancellable = ImageDownloader.shared
            .get(url: film.posterURL)
            .receive(on: DispatchQueue.main)
            .sink { image in
                self.hostingController?.rootView = FilmView(film: film,
                                                            image: image,
                                                            initialRating: Int(viewModel.filmEntity.rating),
                                                            ratingHandler: self.onRatingChange)
            }
    }
    
    private func setupViews() {
        hostingController = UIHostingController<FilmView>(rootView: FilmView(film: .default))
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
    
    private func onRatingChange(value: Int) {
        viewModel?.addRating(value: value)
    }
    
    // MARK: Actions
    
    @IBAction func deleteTapped(_ sender: Any) {
        guard let title = viewModel?.filmEntity.title else {
            return
        }
        let alertController = UIAlertController(title: "Delete film", message: "Are you sure you want to delete \(title)?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel?.delete()
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
