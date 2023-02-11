//
//  NotificationViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/07.
//

import Foundation
import Alamofire

class NotificationViewModel {
    // MARK: Request [Notification]
    public static func getNotificationsByMemberIdx(memberIdx: Int, lastNotificationIdx: Int?, completion: @escaping ((NotificationInfo) -> Void)) {
        var lastNotiIdx = ""
        if lastNotificationIdx == nil {
            lastNotiIdx = ""
        } else { lastNotiIdx = String(describing: lastNotificationIdx!) }
        let url = "https://garamgaebi.shop/notification/\(memberIdx)?lastNotificationIdx=\(lastNotiIdx)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        
        // 모아보기        마감임박      신청완료          신청취소완료
        // COLLECTIONS, SOON_CLOSE, APPLY_COMPLETE, APPLY_CANCEL_COMPLETE
//        let dummy = [
//            NotificationInfo(notificationIdx: 1, notificationType: "COLLECTIONS", content: "[모아보기] 유로 세미나1, programIdx 8로 이동", resourceIdx: 8, resourceType: "SEMINAR", isRead: false),
//            NotificationInfo(notificationIdx: 2, notificationType: "SOON_CLOSE", content: "알림 내용2 - dummy", resourceIdx: 2, resourceType: "SEMINAR", isRead: true),
//            NotificationInfo(notificationIdx: 3, notificationType: "APPLY_COMPLETE", content: "알림 내용3 - dummy", resourceIdx: 3, resourceType: "NETWORKING", isRead: false),
//            NotificationInfo(notificationIdx: 4, notificationType: "APPLY_CANCEL_COMPLETE", content: "알림 내용4 - dummy", resourceIdx: 4, resourceType: "NETWORKING", isRead: false),
//            NotificationInfo(notificationIdx: 5, notificationType: "COLLECTIONS", content: "알림 내용5 - dummy", resourceIdx: 5, resourceType: "SEMINAR", isRead: false),
//            NotificationInfo(notificationIdx: 6, notificationType: "COLLECTIONS", content: "알림 내용6 - dummy", resourceIdx: 6, resourceType: "NETWORKING", isRead: false),
//        ]
//        completion(dummy)
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: NotificationInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(Notification 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-Notification 조회): \(error.localizedDescription)")
                }
            }
        
    }
   
    
    public static func getIsUnreadNotifications(memberIdx: Int, completion: @escaping ((NotificationUnreadInfo) -> Void)) {
        let url = "https://garamgaebi.shop/notification/unread/\(memberIdx)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: NotificationUnreadInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(Unread Notification 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-Unread Notification 조회): \(error.localizedDescription)")
                }
            }
        
    }
    
}
