//
//  EventAttendantCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class EventAttendantCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "EventAttendantCollectionViewCell"
	
	let imageSize = 44.0
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = imageSize/2
		imageView.tintColor = .mainGray
		imageView.clipsToBounds = true
		
		return imageView
	}()
	
	lazy var userNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
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

extension EventAttendantCollectionViewCell {
	private func configureViews() {
		contentView.backgroundColor = .white
		[profileImageView, userNameLabel]
			.forEach {contentView.addSubview($0)}
		
		profileImageView.snp.makeConstraints {
			$0.width.equalTo(imageSize)
			$0.height.equalTo(imageSize)
			$0.centerX.equalToSuperview()
			$0.top.equalToSuperview()
		}
		
		userNameLabel.snp.makeConstraints {
			$0.top.equalTo(profileImageView.snp.bottom)
			$0.centerX.equalToSuperview()
		}
	}
}
