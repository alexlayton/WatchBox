//
//  ImageCache.swift
//  WatchBox
//
//  Created by Alex Layton on 03/07/2021.
//

import Foundation
import UIKit
import Combine

class ImageCache {
    
    static let shared = ImageCache()
    
    private let internalCache = NSCache<NSString, UIImage>()
    
    func get(url urlString: String) -> AnyPublisher<UIImage?, Never> {
        if let cachedImage = internalCache.object(forKey: urlString as NSString) {
            return Just<UIImage?>(cachedImage)
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return Just<UIImage?>(nil)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { data, _ -> UIImage? in
                let image = UIImage(data: data)
    
                // Not sure if this is the best place to cache the image...
                if let image = image {
                    self.internalCache.setObject(image, forKey: urlString as NSString)
                }
                
                return image
            }
            .catch { error -> Just<UIImage?> in
                print("Error downloading image - \(error.localizedDescription)")
                return Just(nil)
            }
            .eraseToAnyPublisher()
    }
    
}
