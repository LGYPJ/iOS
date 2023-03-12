//
//  AppDelegate.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/08.
//

import UIKit
import KakaoSDKCommon
import UserNotifications
import Firebase
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Native App Key 보안
        // UserDefault에 key값으로 저장하여 숨김
        let KAKAO_APP_KEY: String = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? "KAKAO_APP_KEY is nil"
        KakaoSDK.initSDK(appKey: KAKAO_APP_KEY)
        
        // Firebase 초기화 세팅.
        FirebaseApp.configure()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true
        
        // 푸시 알림 권한 설정 및 푸시 알림에 앱 등록
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, _ in
            // 완료 핸들러는 인증이 성공했는지 여부를 나타내는 Bool을 수신합니다. 인증 결과를 표시합니다.
            print("Permission granted: \(granted)")
            // 추가
            guard granted else { return }
            
            self.getNotificationSettings()
        })
        application.registerForRemoteNotifications()
        
        // device token 요청.
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    
    /// APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func getNotificationSettings() {
           UNUserNotificationCenter.current().getNotificationSettings { settings in
               print("Notification settings: \(settings)")
               guard settings.authorizationStatus == .authorized else { return }
               DispatchQueue.main.async {
                   UIApplication.shared.registerForRemoteNotifications()
               }
               
           }
       }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        print(">>>!!###!>")
        print(userInfo)
        print(">>>!!###!>")
        //푸시 받았을때
        completionHandler([.banner, .list, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //푸시 클릭시
        let messageID = response.notification.request.identifier
        print(">>>!!!>")
        print(messageID)
        print(">>>!!!>")
        let state = UIApplication.shared.applicationState
        
        if state == .background {
            print(">> background")
            
        } else if state == .inactive {
            print(">> inactive")
            // programIdx 29번인 뷰로 이동하는 코드 -> 백그라운드에서 눌렀을떄
        } else if state == .active {
            print(">> active")
            // programIdx 29번인 뷰로 이동하는 코드 ->
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(">>>>")
        print(userInfo)
        print(">>>>")
        
        print(userInfo["programType"])
        print(userInfo["notificationType"])
        print(userInfo["content"])
        print(userInfo["programIdx"])
        
        NotificationCenter.default.post(name: NSNotification.Name("ReloadMyEvent"), object: nil)
        print(">>>>")
        print("reload HomeVC")
        print(">>>>")
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String?] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
