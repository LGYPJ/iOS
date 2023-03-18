//
//  TabBarController.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

class TabBarController: UITabBarController {
    
    var pushProgramIdx: Int?
    var pushProgramtype: String?
    init(pushProgramIdx: Int?, pushProgramtype: String?) {
        self.pushProgramIdx = pushProgramIdx
        self.pushProgramtype = pushProgramtype
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            createNavController(for: HomeVC(pushProgramIdx: self.pushProgramIdx, pushProgramtype: self.pushProgramtype), title: "홈", image: UIImage(named: "TabBarIconHome")!),
            createNavController(for: ViewAllVC(), title: "모아보기", image: UIImage(named: "TabBarIconViewAll")!),
            createNavController(for: ProfileVC(), title: "내 프로필", image: UIImage.init(named: "TabBarIconProfile")!),
        ]
        // HomeVC의 세미나/네트워킹 모아보기 버튼 활성화를 위한 TabbarController 하위계층 중 ViewAllVC를 미리 로딩
        self.viewControllers?.forEach {
            if let navController = $0 as? UINavigationController,
               $0.tabBarItem.title == "모아보기" {
                let _ = navController.topViewController?.view
            } else {
                let _ = $0.view
            }
        }
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
