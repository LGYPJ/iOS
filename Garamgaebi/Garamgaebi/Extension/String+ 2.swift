//
//  String+.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/20.
//

import UIKit

extension String {
	// 숫자 6자일때 -> True
	func isValidAuthNumber() -> Bool {
		let authNumberRegEx = "[0-9]{6}"
		let authNumberTest = NSPredicate.init(format: "SELF MATCHES %@", authNumberRegEx)
		
		return authNumberTest.evaluate(with: self)
	}
	
	// id 정규표현식 5~13자
	func isValidId() -> Bool {
		let idRegEx = "[A-Za-z0-9]{5,13}"
		let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
		
		return idTest.evaluate(with: self)
	}
}
