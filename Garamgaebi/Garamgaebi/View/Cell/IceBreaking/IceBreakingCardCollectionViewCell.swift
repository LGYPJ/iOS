//
//  IceBreakingCardCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class IceBreakingCardCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "IceBreakingCardCollectionViewCell"
	
	lazy var contentImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension IceBreakingCardCollectionViewCell {
	private func configureView() {
		contentView.layer.borderColor = UIColor.mainBlue.cgColor
		contentView.layer.borderWidth = 2
		contentView.layer.cornerRadius = 20
		
		contentView.backgroundColor = .white
		[contentImageView]
			.forEach {contentView.addSubview($0)}
		
		contentImageView.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(72)
		}
	}
}
