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
		imageView.image = UIImage(systemName: "seal.fill")
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	lazy var entranceButton: UIButton = {
		let button = UIButton()
		button.setTitle("참가하기", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		button.setImage(UIImage(systemName: "chevron.right.circle"), for: .normal)
		button.backgroundColor = .white
		button.setTitleColor(.mainBlue, for: .normal)
		button.tintColor = .mainBlue
		// TODO: iOS 15이후 deprecated
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
		// 이미지와 타이틀 위치 변경
		button.semanticContentAttribute = .forceRightToLeft
		button.contentVerticalAlignment = .bottom
		
		return button
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
		[icebreakingLabel, descriptionLabel, contentImageView, entranceButton]
			.forEach {contentView.addSubview($0)}
		
		icebreakingLabel.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.leading.equalToSuperview()
		}
		
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(icebreakingLabel.snp.bottom).offset(4)
			$0.leading.equalTo(icebreakingLabel)
		}
		
		contentImageView.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(25)
			$0.leading.trailing.equalToSuperview()
			$0.height.equalTo(contentImageView.snp.width)
			$0.bottom.equalToSuperview()
		}
		entranceButton.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.trailing.equalToSuperview().inset(16)
		}
	}
}
