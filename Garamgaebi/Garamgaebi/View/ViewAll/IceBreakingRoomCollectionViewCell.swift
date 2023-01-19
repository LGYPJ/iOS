//
//  IceBreakingRoomCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/14.
//

import UIKit
import SnapKit

class IceBreakingRoomCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "IceBreakingRoomCollectionViewCell"
	
	lazy var roomTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .black
		
		return label
	}()
    
	lazy var entranceButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		button.tintColor = .black
		
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}

extension IceBreakingRoomCollectionViewCell {
	private func configureViews() {
		contentView.backgroundColor = .mainLightBlue
		contentView.layer.cornerRadius = 8
		[roomTitleLabel, entranceButton]
			.forEach {contentView.addSubview($0)}
		roomTitleLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.centerY.equalToSuperview()
		}
		entranceButton.snp.makeConstraints {
			$0.width.equalTo(8)
			$0.height.equalTo(13.8)
			$0.trailing.equalToSuperview().inset(15)
			$0.centerY.equalToSuperview()
		}
	}
}
