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
    
    public static func requestSendEmail(_ parameter : UniEmailAuthModel, completion: @escaping (UniEmailAuthNumber) -> ()) {
        AF.request("https://garamgaebi.shop/email/emailconfirm", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: UniEmailAuthModelResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("DEBUG: 이메일 전송 성공", result.message)
                    completion(result.result)
                } else {
                    print("DEBUG: 이메일 전송 실패", result.message)
                }
                
            case .failure(let error):
                print("DEBUG: 이메일 전송 실패", error.localizedDescription)
            }
        }
    }
}
