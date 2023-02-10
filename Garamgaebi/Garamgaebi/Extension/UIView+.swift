//
//  UIView+.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/05.
//

import Foundation
import UIKit
import SnapKit

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
    
    func profileTopRadiusView(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        self.layer.borderColor = UIColor.mainGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.backgroundColor = UIColor(hex: 0xF5F5F5).cgColor
    }
    
    func profileBottomRadiusView() {
        self.layer.borderColor = UIColor.mainGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

