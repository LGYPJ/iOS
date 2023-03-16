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
        
        print(">>>푸시받음")
        print(userInfo)
        print(">>>푸시받음")
        //푸시 받았을때
        completionHandler([.banner, .list, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //푸시 클릭시
        let messageID = response.notification.request.identifier
        print(">>>푸시 클릭")
        print(messageID)
        print(">>>푸시 클릭")
        let state = UIApplication.shared.applicationState
        // TODO: 푸시알림 탭하면 해당 (세미나/네트워킹)으로 이동
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let programIdx = Int(userInfo["programIdx"] as! String)!
        let programType = userInfo["programType"] as! String
        if state == .background {
            print(">> background")
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            
            sceneDelegate.window?.rootViewController = SplashVC(pushProgramIdx: programIdx, pushProgramtype: programType)
            sceneDelegate.window?.makeKeyAndVisible()
            
            
        } else if state == .inactive {
            print(">> inactive")
            
            NotificationCenter.default.post(name: NSNotification.Name("ReloadMyEvent"), object: nil)
            
            switch programType as! String {
            case "SEMINAR" :
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                let programIdx = Int(userInfo["programIdx"] as! String)!
                let programType = userInfo["programType"] as! String
                print("123")
                print(programIdx)
                print("123")
                sceneDelegate.window?.rootViewController = TabBarController(pushProgramIdx: programIdx, pushProgramtype: programType)
                sceneDelegate.window?.makeKeyAndVisible()
                
            case "NETWORKING":
                NotificationCenter.default.post(name: Notification.Name("pushNetworkingDetailVC"), object: MyEventToDetailInfo(programIdx: Int(userInfo["programIdx"] as! String)! , type: userInfo["programType"] as! String))
            default:
                print(">>> ERROR Push Notification PROGRAMTYPE ERROR")
            }
            
            //            if seminarList[indexPath.row].isOpen == "OPEN" {
            //                NotificationCenter.default.post(name: Notification.Name("pushSeminarDetailVC"), object: MyEventToDetailInfo(programIdx: seminarList[indexPath.row].programIdx, type: seminarList[indexPath.row].type))
            //            }
        } else if state == .active {
            print(">> active")
            
            NotificationCenter.default.post(name: NSNotification.Name("ReloadMyEvent"), object: nil)
            
            
            switch programType as! String{
            case "SEMINAR":
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                let programIdx = Int(userInfo["programIdx"] as! String)!
                let programType = userInfo["programType"] as! String
                sceneDelegate.window?.rootViewController = TabBarController(pushProgramIdx: programIdx, pushProgramtype: programType)
                sceneDelegate.window?.makeKeyAndVisible()
            case "NETWORKING":
                NotificationCenter.default.post(name: Notification.Name("pushNetworkingDetailVC"), object: MyEventToDetailInfo(programIdx: Int(userInfo["programIdx"] as! String)! , type: userInfo["programType"] as! String))
            default:
                print(">>> ERROR Push Notification PROGRAMTYPE ERROR")
            }
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // 여기는 그냥 받는부분
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(">>>> didReceiveRemoteNotification")
        print(userInfo)
        print(">>>> didReceiveRemoteNotification")
        
        NotificationCenter.default.post(name: NSNotification.Name("ReloadMyEvent"), object: nil)
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
