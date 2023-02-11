//
//  EventIceBreakingTableViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class EventIceBreakingTableViewCell: UITableViewCell {
	
	static let identifier = "EventIceBreakingTableViewCell"
	
	lazy var icebreakingLabel: UILabel = {
		let label = UILabel()
		label.text = "아이스 브레이킹"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .black
		
		return label
	}()
	
	lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.text = "아이스브레이킹 참여는\n네트워킹 당일 정해진 시간에 오픈합니다."
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		label.numberOfLines = 2
		
		return label
	}()
	
	lazy var contentImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "ExNetworkingImage")
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
//	lazy var entranceButton: UIButton = {
//		let button = UIButton()
//		button.setTitle("참가하기", for: .normal)
//		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
//		button.setImage(UIImage(systemName: "chevron.right.circle"), for: .normal)
//		button.backgroundColor = .mainBlue
//		button.layer.cornerRadius = 12
//		button.setTitleColor(.white, for: .normal)
//		// 이미지 컬러
//		button.tintColor = .white
//		// TODO: iOS 15이후 deprecated
//		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
//		// 이미지와 타이틀 위치 변경
//		button.semanticContentAttribute = .forceRightToLeft
//		button.contentVerticalAlignment = .bottom
//
//		return button
//	}()
	
	lazy var entranceContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .mainGray
		view.layer.cornerRadius = 12
		
		return view
	}()
	
	lazy var entranceLabel: UILabel = {
		let label = UILabel()
		label.font = .NotoSansKR(type: .Regular, size: 16)
		label.textColor = UIColor(hex: 0x8A8A8A)
		label.text = "참가하기"
		
		return label
	}()
	
	lazy var entranceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "chevron.right.circle")?.withTintColor(UIColor(hex: 0x8A8A8A), renderingMode: .alwaysOriginal)
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		configureViews()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension EventIceBreakingTableViewCell {
	private func configureViews() {
		contentView.backgroundColor = UIColor(hex: 0xF9F9F9)
		contentView.layer.cornerRadius = 12
		[icebreakingLabel, descriptionLabel, contentImageView, entranceContainerView]
			.forEach {contentView.addSubview($0)}
		
		icebreakingLabel.snp.makeConstraints {
			$0.top.equalToSuperview().inset(12)
			$0.leading.equalToSuperview().inset(12)
		}
		
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(icebreakingLabel.snp.bottom).offset(8)
			$0.leading.equalTo(icebreakingLabel)
		}
		
		contentImageView.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(25)
			$0.leading.trailing.equalToSuperview()
			$0.height.equalTo(154)
//			$0.height.equalTo(contentImageView.snp.width)
			$0.bottom.equalToSuperview().inset(36)
		}
		entranceContainerView.snp.makeConstraints {
			$0.centerY.equalTo(icebreakingLabel)
			$0.trailing.equalToSuperview().inset(16)
		}
		
		[entranceLabel, entranceImageView]
			.forEach {entranceContainerView.addSubview($0)}
		entranceLabel.snp.makeConstraints {
			$0.top.bottom.equalToSuperview().inset(4)
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().inset(8)
		}
		entranceImageView.snp.makeConstraints {
			$0.width.height.equalTo(17)
			$0.top.bottom.equalToSuperview().inset(4)
			$0.centerY.equalToSuperview()
			$0.leading.equalTo(entranceLabel.snp.trailing).offset(8)
			$0.trailing.equalToSuperview().inset(8)
		}
	}
}
