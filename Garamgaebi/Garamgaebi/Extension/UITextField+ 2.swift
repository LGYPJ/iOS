//
//  UITextField+.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/20.
//

import UIKit

extension UITextField {
	func addLeftPadding() {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
		self.leftView = paddingView
		self.leftViewMode = ViewMode.always
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
	
}
