//
//  UniEmailAuthViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/04.
//

import Foundation
import Alamofire

// 이메일로 인증번호 전송하는 API 연동
class UniEmailAuthViewModel {
    
    public static func requestSendEmail(_ parameter : UniEmailAuthModel, completion: @escaping (Bool) -> ()) {
        let url = "https://garamgaebi.shop/email/sendEmail"
        let body: [String: String] = [
            "email": parameter.email
        ]
        AF.request(url, method: .post,
                   parameters: body, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: UniEmailAuthModelResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("DEBUG: 이메일 전송 성공", result.message)
                    completion(true)
                } else {
                    print("DEBUG: 이메일 전송 실패", result.message)
                    completion(false)
                }
                
            case .failure(let error):
                print("AF-DEBUG: 이메일 전송 실패", error.localizedDescription)
            }
        }
    }
    
    public static func requestVerifyAuthNumber(_ parameter : UniEmailAuthNumberModel, completion: @escaping (Bool) -> ()) {
        let url = "https://garamgaebi.shop/email/verify"
        let body: [String: String] = [
            "email": parameter.email,
            "key": parameter.key
        ]
        AF.request(url, method: .post,
                   parameters: body, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: UniEmailAuthNumberModelResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("DEBUG: 이메일 전송 성공", result.message)
                    completion(true)
                } else {
                    print("DEBUG: 이메일 전송 실패", result.message)
                    completion(false)
                }
            case .failure(let error):
                print("AF-DEBUG: 이메일 전송 실패", error.localizedDescription)
            }
        }
    }
    
}
