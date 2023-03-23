//
//  UITabBarController+.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/03/20.
//

import UIKit

extension UITabBarController {
	// 사용법: self.tabBarController?.setTabBarVisible(visible: true, duration: 0.0)
	func setTabBarVisible(visible:Bool, duration: TimeInterval) {
		if (tabBarIsVisible() == visible) { return }
		let frame = self.tabBar.frame
		let height = frame.size.height
		let offsetY = (visible ? -height : height)

		// animation
		UIView.animate(withDuration: duration, delay: 0, animations: {
//			self.tabBar.frame = CGRectOffset(frame, 0, offsetY)
			self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + offsetY)
			self.view.setNeedsDisplay()
			self.view.layoutIfNeeded()
		})
	}

	func tabBarIsVisible() ->Bool {
		return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
	}
}
