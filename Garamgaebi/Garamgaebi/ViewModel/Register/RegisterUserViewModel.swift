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
    // nickname, -> UserDefault
    // profileEmail, -> UserDefault
    // identifier, -> ?
    // uniEmail, -> ? (UserDefault로 해야되나 ???)
    // status(enum[ "ACTIVE", "INACTIVE" ]), -> ACTIVE로 넘기면 됨
    // password -> 추후 제거 예정
    
    // response로 memberIdx 받아옴
    public static func requestRegisterUser(parameter : RegisterUserInfo, completion: @escaping (RegisterMemberIdx) -> ()) {
        let url = "https://garamgaebi.shop/member/post"
        let body: [String: Any] = [
            "nickname": parameter.nickname,
            "profileEmail": parameter.profileEmail,
            "identifier": parameter.identifier,
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
                    print("DEBUG: 가입 성공", result.message)
                    completion(result.result!)
                } else {
                    print("DEBUG: 가입 실패", result.message)
                }
                
            case .failure(let error):
                print(error)
                print("DEBUG: 가입 RegisterUserInfo 전송 실패", error.localizedDescription)
            }
        }
    }
}

