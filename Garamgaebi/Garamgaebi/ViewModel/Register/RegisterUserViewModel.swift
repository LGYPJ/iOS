//
//  RegisterUserViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/06.
//

import Foundation
import Alamofire

// 가입화면에서 UserInfo post API
class RegisterUserViewModel {
    public static func requestRegisterUserKakao(parameter : RegisterUserInfo, completion: @escaping ((Result<RegisterUserInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/member/post/kakao"
        let body: [String: Any] = [
            "nickname": parameter.nickname,
            "profileEmail": parameter.profileEmail,
            "accessToken": parameter.accessToken,
            "uniEmail": parameter.uniEmail,
            "status": parameter.status,
        ]
        AF.request(url, method: .post,
                   parameters: body, encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: RegisterUserInfoResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("DEBUG: 가입 성공(카카오)", result.message)
                    completion(response.result)
                } else {
                    print("DEBUG: 가입 실패(카카오)", result.message)
                    completion(response.result)
                }
            case .failure(let error):
                print("DEBUG: 가입 RegisterUserInfo 전송 실패(카카오)", error.localizedDescription)
                completion(response.result)
            }
        }
    }
    
    public static func requestRegisterUserApple(parameter : RegisterUserInfo, completion: @escaping ((Result<RegisterUserInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/member/post/apple"
        let body: [String: Any] = [
            "nickname": parameter.nickname,
            "profileEmail": parameter.profileEmail,
            "idToken": parameter.accessToken,
            "uniEmail": parameter.uniEmail,
            "status": parameter.status,
        ]
        AF.request(url, method: .post,
                   parameters: body, encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: RegisterUserInfoResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("DEBUG: 가입 성공(애플)", result.message)
                    completion(response.result)
                } else {
                    print("DEBUG: 가입 실패(애플)", result)
                    completion(response.result)
                }
            case .failure(let error):
                print("DEBUG: 가입 RegisterUserInfo 전송 실패(애플)", error.localizedDescription)
                completion(response.result)
            }
        }
    }
}

