//
//  UIImageView+Cache.swift
//  FoodDigger
//
//  Created by JihyeKim on 5/13/26.
//

import UIKit

class CacheImageView: UIImageView {
    private var currentImageUrlString: String?

    func loadImage(from urlString: String?) {
        self.currentImageUrlString = urlString

        guard let urlString = urlString, let url  = URL(string: urlString) else {
            //default image
            self.image = UIImage(systemName: "photo.fill")
            return
        }

        if let cachedImage = ImageCacheManager.shared.getImage(forKey: urlString) {
            self.image  = cachedImage
            return
        }
        self.image = UIImage(systemName: "arrow.2.circlepath.circle")

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return }

                ImageCacheManager.shared.setImage(image, forKey: urlString)

                if self.currentImageUrlString == urlString {
                    await MainActor.run(body: {
                        self.image = image
                    })
                }

            } catch {
                if self.currentImageUrlString == urlString {
                    await MainActor.run(body: {
                        self.image = UIImage(systemName: "exclamationmark.triangle")
                    })
                }
            }
        }
    }
}
