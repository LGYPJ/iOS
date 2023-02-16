//
//  ProfileServiceViewModel.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/02/16.
//

import Alamofire

class ProfileServiceViewModel {
    // MARK: - [POST] 고객센터 추가
    public static func postQna(memberIdx: Int, email: String, category: String, content: String, completion: @escaping ((Bool) -> Void)) {
        
        let url = "https://garamgaebi.shop/profile/qna"
        
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
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
            headers: header
        )
        .validate()
        .responseDecodable(of: ProfilePostResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    print("성공(고객센터): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(고객센터): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-고객센터): \(error.localizedDescription)")
            }
        }
    }
}