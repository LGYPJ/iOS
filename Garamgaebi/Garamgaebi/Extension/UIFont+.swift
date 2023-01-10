//
//  UIFont+.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

extension UIFont {
    class func NotoSansKR(type: NotoSansKRType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }

    public enum NotoSansKRType {
        case Black
        case Bold
        case Medium
        case Regular
        case Light
        case Thin
        
        var name: String {
            switch self {
            case .Black:
                return "NotoSansKR-Black"
            case .Bold:
                return "NotoSansKR-Bold"
            case .Medium:
                return "NotoSansKR-Medium"
            case .Regular:
                return "NotoSansKR-Regular"
            case .Light:
                return "NotoSansKR-Light"
            case .Thin:
                return "NotoSansKR-Thin"
            }
        }
    }
}
