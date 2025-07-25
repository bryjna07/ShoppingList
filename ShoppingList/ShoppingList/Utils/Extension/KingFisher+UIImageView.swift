//
//  KingFisher+UIImageView.swift
//  Magazine+369+Travel
//
//  Created by YoungJin on 7/16/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setKFImage(
        from url: URL?,
        placeholder: UIImage? = nil,
        cornerRadius: CGFloat = 8
    ) {
        guard let url = url else {
            self.image = placeholder
            return
        }
// 리사이징 +
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ]

        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options
        ) { result in
            switch result {
            case .success(let value):
                print("Loaded: \(value.source.url?.absoluteString ?? "") (cache: \(value.cacheType)")
            case .failure(let error):
                print("Load failed: \(error.localizedDescription)")
            }
        }
    }
}
