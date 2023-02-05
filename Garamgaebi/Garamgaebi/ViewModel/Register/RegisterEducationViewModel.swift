//
//  RegisterEducationViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/04.
//

import Foundation
import Alamofire

// 가입화면에서 교육 추가 API
class RegisterEducationViewModel {
    
    public static func requestInputEducation(_ parameter : RegisterEducationInfo, completion: @escaping (Bool) -> ()) {
        let url = "https://garamgaebi.shop/profile/education"
        let body: [String: Any] = [
            "memberIdx": parameter.memberIdx,
            "institution": parameter.institution,
            "major": parameter.major,
            "isLearning": parameter.isLearning,
            "startDate": parameter.startDate,
            "endDate": parameter.endDate
        ]
        AF.request(url, method: .post,
                   parameters: body, encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: RegisterEducationResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("DEBUG: 교육 추가 성공", result.message)
                    completion(result.result)
                } else {
                    print("DEBUG: 교육 추가 실패", result.message)
                }
                
            case .failure(let error):
                print("DEBUG: 이메일 전송 실패", error.localizedDescription)
            }
        }
    }
}
