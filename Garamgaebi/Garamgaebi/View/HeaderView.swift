//
//  HeaderView.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/10.
//

import UIKit
import SnapKit

class HeaderView: UIView {
	let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		
		return label
	}()
	
	lazy var backButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "arrowBackward"), for: .normal)
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		button.clipsToBounds = true
		button.tintColor = UIColor(hex: 0x000000,alpha: 0.8)
		button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
		
		return button
	}()
	
	let separator: UIView = {
		let view = UIView()
		view.backgroundColor = .mainGray
		
		return view
	}()
	
	init(title: String?) {
		titleLabel.text = title
		super.init(frame: .zero)
		setUpView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setUpView() {
		backgroundColor = .systemBackground
		
		[titleLabel, backButton, separator]
			.forEach {addSubview($0)}
		
		titleLabel.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
		}
		
		backButton.snp.makeConstraints {
			$0.left.equalToSuperview().inset(16)
			$0.centerY.equalToSuperview()
		}
		
		separator.snp.makeConstraints {
			$0.bottom.equalToSuperview()
			$0.height.equalTo(1)
			$0.left.right.equalToSuperview()
		}
	}
	
	@objc private func didTapBackButton() {
		guard let parentVC = self.superview?.next as? UIViewController,
			  let nav = parentVC.navigationController else {return}
		nav.popViewController(animated: true)
	}
}
