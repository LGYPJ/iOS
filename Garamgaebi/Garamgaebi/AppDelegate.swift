//
//  AppDelegate.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/08.
//

import UIKit
import KakaoSDKCommon
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Native App Key 보안
        // UserDefault에 key값으로 저장하여 숨김
        let KAKAO_APP_KEY: String = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? "KAKAO_APP_KEY is nil"
        KakaoSDK.initSDK(appKey: KAKAO_APP_KEY)
        
        // Firebase 프로젝트에서 사용
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print(">>> token register")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String?] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
