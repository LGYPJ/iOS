//
//  IceBreakingStartCardCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/16.
//

import UIKit
import SnapKit

class IceBreakingStartCardCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "IceBreakingStartCardCollectionViewCell"
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "시작하기"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 24)
		label.textColor = .mainBlue
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = .mainLightBlue
		contentView.layer.borderColor = UIColor.mainBlue.cgColor
		contentView.layer.borderWidth = 2
		contentView.layer.cornerRadius = 20
		
		configureViews()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}

extension IceBreakingStartCardCollectionViewCell {
	private func configureViews() {
		contentView.addSubview(titleLabel)
		
		titleLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
}
