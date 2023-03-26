//
//  UIColor+.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
	class var mainBlue: UIColor { UIColor(hex: 0x2294FF) }
    class var mainLightBlue: UIColor { mainBlue.withAlphaComponent(0.1) }
    class var mainYellow: UIColor { UIColor(hex: 0xFFE600) }
    class var mainGray: UIColor { UIColor(hex: 0xD9D9D9) }
    class var mainLightGray: UIColor { UIColor(hex: 0xF1F1F1) }
	class var mainBlack: UIColor { UIColor(hex: 0x000000, alpha: 0.8) }
	class var mainPurple: UIColor { UIColor(hex: 0x356EFF, alpha: 0.8) }
	class var mainLightPurple: UIColor { UIColor(hex: 0x356EFF, alpha: 0.1) }
}
