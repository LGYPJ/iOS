//
//  LoginViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/03.
//

import Alamofire

class LoginViewModel {
    
    var fcmToken = String()
    
    public static func postLoginKakao(accessToken: String, fcmToken: String, completion: @escaping ((Result<LoginModelResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/member/login/kakao"

        let body: [String: Any] = [
            "accessToken": accessToken,
            "fcmToken": fcmToken
        ]
        print(">>")
        print(">>")
        print(body)
        print(">>")
        print(">>")
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LoginModelResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        print("실패(카카오 로그인): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    completion(response.result)
                    print("실패(AF-카카오 로그인): \(error.localizedDescription)")
                }
            }
        
    }
    
    public static func postLoginAuto(refreshToken: String, completion: @escaping ((Result<LoginModelResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/member/login/auto"
        
        let body: [String: Any] = [
            "refreshToken": refreshToken,
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LoginModelResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        print("실패(자동 로그인): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    completion(response.result)
                    print("실패(AF-자동 로그인): \(error.localizedDescription)")
                }
            }
        
    }
}
