//
//  UIButton+.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/22.
//

import UIKit

extension UIButton {
    
    // 기본 버튼
    func basicButton() {
        self.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .mainBlue
        
        self.layer.cornerRadius = 12
        self.frame.size.height = 48
    }
    
    // SNS, 경력, 교육 추가 버튼 디자인
    func profilePlusButton() {
        self.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
        self.setTitleColor(.mainBlue, for: .normal)
        self.tintColor = .mainBlue
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
    }
    
}
