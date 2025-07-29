//
//  horizontalCell.swift
//  ShoppingList
//
//  Created by YoungJin on 7/29/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class horizontalCell: BaseCollectionViewCell {
    
    static let id = "horizontalCell"
    
    var item: Item? {
        didSet {
            configureUIWithData()
        }
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension horizontalCell {
    
    override func configureUIWithData() {
        guard let item else { return } // 예외처리
        let url = URL(string: item.image)
        imageView.setKFImage(from: url)
    }
    
    override func configureHierarachy() {
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
