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
    
    // profile
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
    
    func profileHistoryBox(title: String) {
        // 상단 뷰
        let topRadiusView = UIView()
        topRadiusView.layer.borderColor = UIColor.mainGray.cgColor
        topRadiusView.layer.borderWidth = 1
        topRadiusView.layer.cornerRadius = 12
        topRadiusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topRadiusView.layer.backgroundColor = UIColor(hex: 0xF5F5F5).cgColor
        self.addSubview(topRadiusView)
        topRadiusView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(47)
        }
        // 상단 타이틀
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        topRadiusView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
        // 하단 뷰
        let bottomRadiusView = UIView()
        bottomRadiusView.layer.borderColor = UIColor.mainGray.cgColor
        bottomRadiusView.layer.borderWidth = 1
        bottomRadiusView.layer.cornerRadius = 12
        
        bottomRadiusView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.addSubview(bottomRadiusView)
        bottomRadiusView.snp.makeConstraints { make in
            make.top.equalTo(topRadiusView.snp.bottom).offset(-1)
            make.leading.trailing.equalTo(topRadiusView)
            make.bottom.equalToSuperview()
        }
    }
}

