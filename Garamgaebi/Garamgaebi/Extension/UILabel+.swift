//
//  UILabel+.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/02/10.
//

import UIKit

class BasicPaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mainGray.cgColor
        self.layer.cornerRadius = 12
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
