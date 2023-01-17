//
//  BankListCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/17.
//

import UIKit
import SnapKit

class BankListCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "BankListCollectionViewCell"
	
	lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		
		return imageView
	}()
	
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    
}

extension BankListCollectionViewCell {
	private func configureViews() {
		contentView.backgroundColor = UIColor(hex: 0xF9F9F9)
		contentView.layer.cornerRadius = 8
		[imageView, nameLabel]
			.forEach {contentView.addSubview($0)}
		
		imageView.snp.makeConstraints {
			$0.width.height.equalTo(32)
			$0.centerX.equalToSuperview()
			$0.top.equalToSuperview().inset(16)
		}
		
		nameLabel.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.top.equalTo(imageView.snp.bottom).offset(4)
		}
	}
}
