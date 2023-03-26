//
//  RegisterCareerViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/04.
//

import Foundation
import Alamofire

// 가입화면에서 경력 추가 API
class RegisterCareerViewModel {
    
    public static func requestInputCareer(_ parameter : RegisterCareerInfo, completion: @escaping (Bool) -> ()) {
        let url = "\(Constants.apiUrl)/profile/career"
        let body: [String: Any] = [
            "memberIdx": parameter.memberIdx,
            "company": parameter.company,
            "position": parameter.position,
            "isWorking": parameter.isWorking,
            "startDate": parameter.startDate,
            "endDate": parameter.endDate
        ]
        AF.request(url, method: .post,
                   parameters: body, encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: RegisterCareerResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("DEBUG: 경력 추가 성공", result.message)
                    completion(result.result)
                } else {
                    print("DEBUG: 경력 추가 실패", result.message)
                }
                
            case .failure(let error):
                print("DEBUG: 경력 추가 실패", error.localizedDescription)
            }
        }
    }
}
