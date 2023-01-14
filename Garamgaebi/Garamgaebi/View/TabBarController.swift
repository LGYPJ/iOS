//
//  TabBarController.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .white
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(hex: 0xF2F2F2).cgColor
        setupVCs()
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: HomeVC(), title: "홈", image: UIImage(named: "TabBarIconHome")!),
            createNavController(for: ViewAllVC(), title: "모아보기", image: UIImage(named: "TabBarIconViewAll")!),
            createNavController(for: ProfileVC(), title: "내 프로필", image: UIImage.init(named: "TabBarIconProfile")!),
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        tabBar.tintColor = .mainBlue
        let unSelectedColor = UIColor(hex: 0xAEAEAE)
        tabBar.unselectedItemTintColor = unSelectedColor
        
        return navController
    }
    
    
}
