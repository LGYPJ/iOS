//
//  SeminarHeaderView.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/11.
//

import UIKit

class SeminarHeaderView: UICollectionReusableView {
	static let identifier = "SeminarHeaderView"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .mainLightBlue
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
