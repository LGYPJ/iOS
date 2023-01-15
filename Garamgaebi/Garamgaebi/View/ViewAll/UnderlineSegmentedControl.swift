//
//  UnderlineSegmentedControl.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 2.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .mainBlue
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
        self.setTitleTextColor()
        self.setTitleTextFont()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainBlue], for: .selected)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setTitleTextColor() {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainBlue], for: .selected)
    }
    
    private func setTitleTextFont() {
        self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.NotoSansKR(type: .Medium, size: 16)], for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // segment 굴곡 없애기
        layer.cornerRadius = 0
        
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }
}
