//
//  CALayer+.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

extension CALayer {
    func addBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case .top:
                addBorderEdge(border, x: 0, y: 0, width: frame.width, height: width)
            case .bottom:
                addBorderEdge(border, x: 0, y: frame.height - width, width: frame.width, height: width)
            case .left:
                addBorderEdge(border, x: 0, y: 0, width: width, height: frame.height)
            case .right:
                addBorderEdge(border, x: frame.width - width, y: 0, width: width, height: frame.height)
            default:
                break
            }
        }
        
        func addBorderEdge(_ border: CALayer, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
            border.frame = CGRect(x: x, y: y, width: width, height: height)
            border.backgroundColor = color.cgColor
            addSublayer(border)
        }
    }
}
