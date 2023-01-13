//
//  IceBreakingCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/12.
//

import UIKit
import SnapKit

class IceBreakingCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "IceBreakingCollectionViewCell"
	
	lazy var mainContentView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 8
		view.layer.borderWidth = 1
		view.layer.borderColor = UIColor.black.cgColor
		
		return view
	}()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension IceBreakingCollectionViewCell {
	private func configureViews() {
		
	}
}
