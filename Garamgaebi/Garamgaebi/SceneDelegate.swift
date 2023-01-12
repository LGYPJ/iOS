//
//  SceneDelegate.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let firstVC = UINavigationController(rootViewController: HomeVC())
        let secondVC = UINavigationController(rootViewController: ViewAllVC())
        let thirdVC = UINavigationController(rootViewController: ProfileVC())
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        tabBarController.setViewControllers([firstVC, secondVC, thirdVC], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "house")
            items[0].image = UIImage(systemName: "house")
            items[0].title = "홈"

            items[1].selectedImage = UIImage(systemName: "person.2")
            items[1].image = UIImage(systemName: "person.2")
            items[1].title = "모아보기"
            
            items[2].selectedImage = UIImage(systemName: "person.circle")
            items[2].image = UIImage(systemName: "person")
            items[2].title = "내 프로필"
        }
        
        guard let windowScene = scene as? UIWindowScene else { return }
                self.window = UIWindow(windowScene: windowScene)
                
                //let rootViewController = tabBarController
                //let rootViewController = OnboardingVC()
                //let rootViewController = LoginVC()
                //let rootViewController = EmailAuthVC()
                //let rootViewController = NickNameVC()
                let rootViewController = EmailVC()
                self.window?.rootViewController = rootViewController
                self.window?.makeKeyAndVisible()
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

