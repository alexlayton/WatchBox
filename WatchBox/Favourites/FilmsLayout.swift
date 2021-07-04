//
//  FilmsLayout.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import UIKit

class FilmsLayout: UICollectionViewFlowLayout {
    
    private let minCellWidth = CGFloat(80)
    private let aspectRatio = CGFloat(1.5)
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minCellWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        self.itemSize = CGSize(width: cellWidth, height: cellWidth * aspectRatio)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: self.minimumInteritemSpacing, bottom: 0.0, right: self.minimumInteritemSpacing)
        self.sectionInsetReference = .fromSafeArea
    }
    
}
