//
//  CardCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class CardCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "CardCollectionViewCell"
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
//		label.text = "가천대는 나에게 네모이다."
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension CardCollectionViewCell {
	private func configureView() {
		[titleLabel]
			.forEach {contentView.addSubview($0)}
		
		titleLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
}
