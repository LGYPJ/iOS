//
//  SeminarPreviewListCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/10.
//

import UIKit
import SnapKit

class SeminarPreviewListCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "SeminarPreviewListCollectionViewCell"
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var userLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var belongLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var detailButton: UIButton = {
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

extension SeminarPreviewListCollectionViewCell {
	private func configureViews() {
		contentView.backgroundColor = .mainLightBlue
		contentView.layer.cornerRadius = 8
		[titleLabel, userLabel, belongLabel, detailButton]
			.forEach {contentView.addSubview($0)}
		
		titleLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(11)
			$0.top.equalToSuperview().inset(22)
		}
		
		userLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(11)
			$0.top.equalTo(titleLabel.snp.bottom).offset(1)
		}
		
		belongLabel.snp.makeConstraints {
			$0.leading.equalTo(userLabel.snp.trailing).offset(3)
			$0.centerY.equalTo(userLabel)
		}
		
		detailButton.snp.makeConstraints {
			$0.width.equalTo(14)
			$0.height.equalTo(14)
			$0.centerY.equalToSuperview()
			$0.trailing.equalToSuperview().inset(16)
		}
	}
}
