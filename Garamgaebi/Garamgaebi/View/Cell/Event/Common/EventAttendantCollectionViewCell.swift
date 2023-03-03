//
//  EventAttendantCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit
import Kingfisher

class EventAttendantCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "EventAttendantCollectionViewCell"
	
	let imageSize = 44.0
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = imageSize/2
		imageView.tintColor = .mainGray
		imageView.clipsToBounds = true
		imageView.layer.borderColor = UIColor.mainBlue.cgColor
		
		return imageView
	}()
	
	lazy var userNameLabel: UILabel = {
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
		userNameLabel.textColor = .mainBlack
		profileImageView.kf.cancelDownloadTask()
		profileImageView.kf.setImage(with: URL(string: ""))
		profileImageView.image = nil
		
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
			$0.top.equalToSuperview().inset(12)
		}
		
		userNameLabel.snp.makeConstraints {
			$0.top.equalTo(profileImageView.snp.bottom)
			$0.centerX.equalToSuperview()
		}
	}
}
