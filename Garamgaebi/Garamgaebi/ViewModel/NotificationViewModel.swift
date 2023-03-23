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
        let url = "\(Constants.apiUrl)/notification/\(memberIdx)?lastNotificationIdx=\(lastNotiIdx)"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
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
   
    
    public static func getIsUnreadNotifications(memberIdx: Int, completion: @escaping ((Result<NotificationUnreadInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/notification/unread/\(memberIdx)"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: NotificationUnreadInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
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
