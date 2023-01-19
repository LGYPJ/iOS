//
//  EventPreviewCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/10.
//

import UIKit
import SnapKit

class EventPreviewCollectionViewCell: UICollectionViewCell {
	static let identifier = "EventPreviewCollectionViewCell"
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 12
		
		return imageView
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .black
		label.numberOfLines = 2
		label.lineBreakMode = .byCharWrapping
		
		return label
	}()
	
	lazy var userLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Medium, size: 12)
		label.textColor = UIColor(hex: 0xAEAEAE)
		
		return label
	}()
	
	lazy var belongLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
		label.textColor = UIColor(hex: 0xAEAEAE)
		
		return label
	}()
	
	lazy var detailButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		
		return button
	}()
	
	// horizontalStackView내의 이름과 소속을 왼쪽 정렬하기 위한 빈 뷰
	lazy var emptyView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		
		return view
	}()
	
	lazy var horizontalStackView: UIStackView = {
		let stackView = UIStackView()
		[userLabel, belongLabel, emptyView]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 3

		
		
		return stackView
	}()
	
	lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView()
		[titleLabel, horizontalStackView]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .vertical
		stackView.spacing = 3
		
		return stackView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
		configureDummyData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// TODO: API연동 후 삭제
	func configureDummyData() {
		profileImageView.image = UIImage(named: "ExProfileImage")
//		titleLabel.text = "docker에 대해 알아보자"
//		userLabel.text = "네온"
//		belongLabel.text = "재학생"
	}
}

extension EventPreviewCollectionViewCell {
	private func configureViews() {
		contentView.backgroundColor = UIColor(hex: 0xF9F9F9)
		[profileImageView, verticalStackView, detailButton]
			.forEach {contentView.addSubview($0)}
		
		profileImageView.snp.makeConstraints {
			$0.width.height.equalTo(80)
			$0.top.leading.equalToSuperview()
		}
		
		verticalStackView.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.leading.equalTo(profileImageView.snp.trailing).offset(12)
			$0.trailing.equalTo(detailButton.snp.leading).offset(-22)
		}

		
		detailButton.snp.makeConstraints {
			$0.width.equalTo(8)
			$0.height.equalTo(13.8)
			$0.centerY.equalToSuperview()
			$0.trailing.equalToSuperview().inset(10)
		}
	}
}

//class EventPreviewCollectionViewCell: UICollectionViewCell {
//
//	static let identifier = "EventPreviewCollectionViewCell"
//
//	lazy var titleLabel: UILabel = {
//		let label = UILabel()
//		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
//		label.textColor = .black
//
//		return label
//	}()
//
//	lazy var userLabel: UILabel = {
//		let label = UILabel()
//		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
//		label.textColor = .black
//
//		return label
//	}()
//
//	lazy var belongLabel: UILabel = {
//		let label = UILabel()
//		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
//		label.textColor = .black
//
//		return label
//	}()
//
//	lazy var detailButton: UIButton = {
//		let button = UIButton()
//		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//		button.tintColor = .black
//
//		return button
//	}()
//
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		configureViews()
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//
//
//
//}
//
//extension EventPreviewCollectionViewCell {
//	private func configureViews() {
//		contentView.backgroundColor = .mainLightBlue
//		contentView.layer.cornerRadius = 8
//		[titleLabel, userLabel, belongLabel, detailButton]
//			.forEach {contentView.addSubview($0)}
//
//		titleLabel.snp.makeConstraints {
//			$0.leading.equalToSuperview().inset(11)
//			$0.top.equalToSuperview().inset(22)
//		}
//
//		userLabel.snp.makeConstraints {
//			$0.leading.equalToSuperview().inset(11)
//			$0.top.equalTo(titleLabel.snp.bottom).offset(1)
//		}
//
//		belongLabel.snp.makeConstraints {
//			$0.leading.equalTo(userLabel.snp.trailing).offset(3)
//			$0.centerY.equalTo(userLabel)
//		}
//
//		detailButton.snp.makeConstraints {
//			$0.width.equalTo(14)
//			$0.height.equalTo(14)
//			$0.centerY.equalToSuperview()
//			$0.trailing.equalToSuperview().inset(16)
//		}
//	}
//}