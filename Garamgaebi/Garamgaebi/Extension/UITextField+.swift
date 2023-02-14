//
//  UITextField+.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/20.
//

import UIKit
import SnapKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        
    }
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
        
    }
	
	func setPlaceholderColor(_ placeholderColor: UIColor) {
		attributedPlaceholder = NSAttributedString(
			string: placeholder ?? "",
			attributes: [
				.foregroundColor: placeholderColor,
				.font: font
			].compactMapValues { $0 }
		)
	}
    
    func basicTextField() {
        self.addLeftPadding()
        self.addRightPadding()
        
        self.textColor = .mainBlack
        self.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        self.autocapitalizationType = .none

        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.mainGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func dateTextField() {
        self.basicTextField()
        
        let calenderImg = UIImageView(image: UIImage(named: "CalendarMonth"))
        self.addSubview(calenderImg)
        calenderImg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(18)
        }
    }
	
}
