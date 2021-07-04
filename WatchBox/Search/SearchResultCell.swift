//
//  SearchResultCell.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import UIKit
import Combine

class SearchResultCell: UITableViewCell {

    // MARK: Types
    
    typealias AddHandler = () -> ()
    
    // MARK: Properties
    
    static let reuseIdentifier = "SearchResultCell"

    var searchResult: SearchResult? {
        didSet {
            configureViews()
        }
    }
    
    var addHandler: AddHandler?
    
    private let titleLabel = UILabel()
    
    private let _imageView = UIImageView()
    
    private var addButton = UIButton()
    
    private var imageCancellable: AnyCancellable?
    
    private let padding = CGFloat(20.0)
    
    // MARK: Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    // MARK: UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageCancellable?.cancel()
    }
    
    // MARK: -
    
    private func fetchImage() {
        guard let posterURL = searchResult?.data.posterURL else {
            return
        }
        imageCancellable = ImageCache.shared
            .get(url: posterURL)
            .receive(on: DispatchQueue.main)
            .sink { image in
                self._imageView.image = image
            }
    }
    
    private func configureViews() {
        guard let searchResult = searchResult else {
            return
        }
        
        titleLabel.text = searchResult.data.title
        
        if searchResult.isAdded {
            addButton.isEnabled = false
            addButton.isHidden = true
            accessoryType = .disclosureIndicator
            selectionStyle = .blue
        } else {
            addButton.isEnabled = true
            addButton.isHidden = false
            accessoryType = .none
            selectionStyle = .none
        }

        
        fetchImage()
    }
    
    private func setupViews() {
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.layer.cornerRadius = 4.0
   
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
        
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 32.0, weight: .medium, scale: .default)
        let symbolImage = UIImage(systemName: "plus.circle.fill", withConfiguration: symbolConfig)
        addButton.setImage(symbolImage, for: .normal)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(_imageView)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            // Image View
            _imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            _imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            _imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            _imageView.widthAnchor.constraint(equalTo: _imageView.heightAnchor, multiplier: CGFloat(2.0 / 3.0)),
            
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: _imageView.trailingAnchor, constant: padding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -padding),

            // Add Button
            addButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc
    private func addTapped(_ sender: Any) {
        addHandler?()
    }
}
