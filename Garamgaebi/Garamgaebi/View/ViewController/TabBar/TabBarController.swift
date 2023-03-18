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
        self.delegate = self
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

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        /// 현재 index
        let currentIndex = tabBarController.selectedIndex
        /// 현재 index의 vc
        let currentViewController = tabBarController.viewControllers?[currentIndex]
        /// 현재 vc와 활성화하려는 vc가 같은 vc인지 확인
        guard currentViewController == viewController else {
          /// 현재 ViewController와 활성화 하려는 ViewController가 다르다면 true를 return 한다.
          /// true == 활성화한다(탭을 이동한다)
          return true
        }
        /// 현재 ViewController와 활성화 하려는 ViewController가 다르다면 scrollView의 scroll을 최상단으로 이동시킨다.
        let naviVC = viewController as? UINavigationController
        
        // 모아보기는 계층구조가 다르므로 따로 처리
        if currentViewController?.tabBarItem.title == "모아보기" {
            let vc = naviVC?.viewControllers.last
            let pageVC = vc!.children.first(where: { $0 is UIPageViewController}) as? UIPageViewController
            let currentPageVC = pageVC?.children.last
            let scrollView = currentPageVC?.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
            scrollView?.scrollRectToVisible(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), animated: true)
        } else {
            let rootVC = naviVC?.viewControllers.last
            let scrollView = rootVC?.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
            scrollView?.scrollRectToVisible(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), animated: true)
        }
        
        /// 현재 ViewController와 활성화 하려는 ViewController가 다르다면 false를 return 한다.
        /// false == 활성화하지 않는다(탭을 이동하지 않는다)
        return false
    }
}
