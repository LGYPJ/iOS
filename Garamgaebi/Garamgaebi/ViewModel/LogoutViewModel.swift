//
//  LogoutViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/03/16.
//

import Foundation
import Alamofire

class LogoutViewModel {
    
    var fcmToken = String()
    
    public static func postLogout(accessToken: String, refreshToken: String, fcmToken: String, completion: @escaping ((Result<LogoutModelResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/member/logout"

        let body: [String: Any] = [
            "accessToken": accessToken,
            "refreshToken": refreshToken,
            "fcmToken": fcmToken
        ]
        
        print(body)

        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LogoutModelResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        print("성공(로그아웃): \(result.message)")
                        completion(response.result)
                    } else {
                        print("실패(로그아웃): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    completion(response.result)
                    print("실패(AF-로그아웃): \(error.localizedDescription)")
                }
            }
        
    }
    
    
}
