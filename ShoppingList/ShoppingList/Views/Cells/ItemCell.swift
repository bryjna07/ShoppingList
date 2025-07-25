//
//  ItemCell.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ItemCell: UICollectionViewCell {
    
    static let id = "ItemCell"
    
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
    
    private let likeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    private let mallLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 2
        $0.textColor = .white
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension ItemCell: ConfigureUI {
    
    func configureUIWithData() {
        guard let item else { return } // 예외처리
        mallLabel.text = item.mallName
        titleLabel.text = item.title
        priceLabel.text = item.lprice // 콤마처리
        let url = URL(string: item.image)
        imageView.setKFImage(from: url)
    }
    
    func configureHierarachy() {
        imageView.addSubview(likeButton)
        [
            imageView,
            mallLabel,
            titleLabel,
            priceLabel,
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.bounds.width)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(8)
            $0.size.equalTo(44)
        }
        
        mallLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
    
    func configureView() {
        backgroundColor = .clear
    }
}
