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
    
    // [가천대생 ID 정규표현식 5~20자 특수문자,공백 불가]
    func isValidId() -> Bool {
        let idRegEx = "[A-Za-z0-9]{1,20}"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        
        return idTest.evaluate(with: self)
    }
    
    // nickName 정규표현식 1~8자
    func isValidNickName() -> Bool {
        let nickRegEx = "[가-힣A-Za-z0-9]{1,8}"
        let nickTest = NSPredicate(format: "SELF MATCHES %@", nickRegEx)
        
        return nickTest.evaluate(with: self)
    }
    
    // email 정규표현식
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    // instagram 아이디 정규표현식
    func isValidInstagramId() -> Bool {
        let idRegEx = "[A-Za-z0-9._-]{1,}"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        
        return idTest.evaluate(with: self)
    }
    
    func toDate() -> Date? { //"yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC+9")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
	
	func formattingDetailDate() -> String {
		guard let date = self.toDate() else {return ""}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd a h시 mm분"
		dateFormatter.locale = Locale(identifier: "ko_KR")
		
		let stringdate = dateFormatter.string(from: date)
		if stringdate.contains("00분") {
			 return stringdate.removeString(target: "00분")
		}
		
		return stringdate
	}
	
	func maxLength(length: Int) -> String {
		var str = self
		let nsString = str as NSString
		if nsString.length > length {
			str = nsString.substring(with:
				NSRange(
				 location: 0,
				 length: nsString.length > length ? length : nsString.length)
			)
			str += ".."
		}
		return  str
	}
    
    func removeString(target string: String) -> String {
        return components(separatedBy: string).joined()
    }
    
    func networkFailureString() -> String {
        let message = "Wi-Fi 또는 셀룰러 네트워크에 연결되어 있는지 확인하십시오."
        return message
    }
}
