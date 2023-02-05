//
//  UIView+.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/05.
//

import Foundation
import UIKit

public enum BorderSide {
    case top, bottom, left, right
}

extension UIView { // textField 흔들기
    func shake() {
        self.layer.borderColor = UIColor(hex: 0xFF0000).cgColor
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.45
        animation.values = [-8.0, 8.0, -8.0, 8.0, -5.0, 5.0, -3.0, 3.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}

