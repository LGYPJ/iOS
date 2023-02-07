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
    public static func getNotificationsByMemberIdx(memberIdx: Int,completion: @escaping (([NotificationInfo]) -> Void)) {
        let pageValue = 0
        let sizeValue = 0
        let sortValue = "" // "string"
        
        let url = "https://garamgaebi.shop/notification/\(memberIdx)?page=\(pageValue)&size=\(sizeValue)&sort=\(sortValue)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        
        // 모아보기        마감임박      신청완료          신청취소완료
        // COLLECTIONS, SOON_CLOSE, APPLY_COMPLETE, APPLY_CANCEL_COMPLETE
        let dummy = [
            NotificationInfo(notificationIdx: 1, notificationType: "COLLECTIONS", content: "알림 내용1", resourceIdx: 1, resourceType: "SEMINAR", isRead: false),
            NotificationInfo(notificationIdx: 2, notificationType: "SOON_CLOSE", content: "알림 내용2", resourceIdx: 2, resourceType: "SEMINAR", isRead: false),
            NotificationInfo(notificationIdx: 3, notificationType: "APPLY_COMPLETE", content: "알림 내용3", resourceIdx: 3, resourceType: "NETWORKING", isRead: false),
            NotificationInfo(notificationIdx: 4, notificationType: "APPLY_CANCEL_COMPLETE", content: "알림 내용4", resourceIdx: 4, resourceType: "NETWORKING", isRead: false),
            NotificationInfo(notificationIdx: 5, notificationType: "COLLECTIONS", content: "알림 내용5", resourceIdx: 5, resourceType: "SEMINAR", isRead: false),
            NotificationInfo(notificationIdx: 6, notificationType: "COLLECTIONS", content: "알림 내용6", resourceIdx: 6, resourceType: "NETWORKING", isRead: false),
        ]
        completion(dummy)
        
//        AF.request(url, method: .get, headers: headers)
//            .validate()
//            .responseDecodable(of: NotificationInfoResponse.self) { response in
//                switch response.result {
//                case .success(let result):
//                    if result.isSuccess {
//                        guard let result = result.result else {return}
//                        completion(result)
//                    } else {
//                        // 통신은 정상적으로 됐으나(200), error발생
//                        print("실패(Notification 조회): \(result.message)")
//                    }
//                case .failure(let error):
//                    // 실제 HTTP에러 404
//                    print("실패(AF-Notification 조회): \(error.localizedDescription)")
//                }
//            }
        
    }
    
    
}
