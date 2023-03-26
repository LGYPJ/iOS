//
//  ProfileServiceViewModel.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/02/16.
//

import Alamofire

class ProfileServiceViewModel {
    // MARK: - [POST] 고객센터 추가
    public static func postQna(memberIdx: Int, email: String, category: String, content: String, completion: @escaping ((Result<ProfileDefaultResponse, AFError>) -> Void)) {
        
        let url = "\(Constants.apiUrl)/profile/qna"

        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "email": email,
            "category": category,
            "content": content
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: bodyData,
            encoding: JSONEncoding.default,
            interceptor: MyRequestInterceptor()
        )
        .validate()
        .responseDecodable(of: ProfileDefaultResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(고객센터): \(result.message)")
                    completion(response.result)
                } else {
                    print("실패(고객센터): \(result.message)")
                    completion(response.result)
                }
            case .failure(let error):
                print("실패(AF-고객센터): \(error.localizedDescription)")
                completion(response.result)
            }
        }
    }
    
    // MARK: - [POST] 회원탈퇴 추가
    public static func postWithdrawl(memberIdx: Int, content: String?, category: String, completion: @escaping ((Result<WithdrawalResponse, AFError>) -> Void)) {
        
        let url = "\(Constants.apiUrl)/member/member-inactived"

        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "category": category,
            "content": content
        ]
//        print(bodyData)
        AF.request(
            url,
            method: .post,
            parameters: bodyData,
            encoding: JSONEncoding.default,
            interceptor: MyRequestInterceptor()
        )
        .validate()
        .responseDecodable(of: WithdrawalResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(회원탈퇴): \(result.message)")
                    completion(response.result)
                } else {
                    print("실패(회원탈퇴): \(result.message)")
                    completion(response.result)
                }
            case .failure(let error):
                print("실패(AF-회원탈퇴): \(error.localizedDescription)")
                completion(response.result)
            }
        }
    }
}
