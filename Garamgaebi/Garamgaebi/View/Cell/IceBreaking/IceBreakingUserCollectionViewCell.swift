//
//  IceBreakingUserCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/14.
//

import UIKit
import SnapKit

class IceBreakingUserCollectionViewCell: UICollectionViewCell {
	
	static let idetifier = "IceBreakingUserCollectionViewCell"
	
	let imageSize = 44.0
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "person.circle")
		imageView.tintColor = .mainGray
		imageView.layer.cornerRadius = imageSize/2
		imageView.layer.borderColor = UIColor.mainBlue.cgColor
		
		return imageView
	}()
	
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
		label.textColor = .mainBlack
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		profileImageView.layer.borderWidth = 0
	}
	
}

extension IceBreakingUserCollectionViewCell {
	private func configureViews() {
		[profileImageView, nameLabel]
			.forEach {contentView.addSubview($0)}
		
		profileImageView.snp.makeConstraints {
			$0.height.width.equalTo(imageSize)
			$0.top.equalToSuperview()
			$0.centerX.equalToSuperview()
		}
		nameLabel.snp.makeConstraints {
			$0.centerX.equalTo(profileImageView)
			$0.top.equalTo(profileImageView.snp.bottom)
		}
	}
}
