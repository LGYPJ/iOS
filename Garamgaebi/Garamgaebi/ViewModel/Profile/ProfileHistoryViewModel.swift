//
//  ProfileHistoryViewModel.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/02/16.
//

import Alamofire

// 프로필 SNS, 경력, 교육 ViewModel
class ProfileHistoryViewModel {
    
    // SNS
    // MARK: - [POST] SNS 추가
    public static func postSNS(memberIdx: Int, type: String, address: String, completion: @escaping ((Bool) -> Void)) {
        
        let url = "https://garamgaebi.shop/profile/sns"
        
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "address": address,
            "type": type
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
                    print("성공(SNS추가): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(SNS추가): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-SNS추가): \(error.localizedDescription)")
            }
        }
    }
    // MARK: - [PATCH] SNS 수정
    public static func patchSNS(snsIdx: Int, type: String, address: String, completion: @escaping ((Bool) -> Void)) {
        
        let url = "https://garamgaebi.shop/profile/sns"
        
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        let bodyData: Parameters = [
            "snsIdx": snsIdx,
            "address": address,
            "type": type
        ]
        
        AF.request(
            url,
            method: .patch,
            parameters: bodyData,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: ProfilePostResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    print("성공(SNS수정): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(SNS수정): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-SNS수정): \(error.localizedDescription)")
            }
        }
    }
    // MARK: - [DELETE] SNS 삭제
    public static func deleteSNS(snsIdx: Int, completion: @escaping ((Bool) -> Void)) {
        
        let url = "https://garamgaebi.shop/profile/sns/\(snsIdx)"
        
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        
        AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: ProfilePostResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    print("성공(SNS삭제): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(SNS삭제): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-SNS삭제): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [POST] 경력 추가
    public static func postCareer(memberIdx: Int, company: String, position: String, isWorking: String, startDate: String, endDate: String, completion: @escaping ((Bool) -> Void)) {
        
        let url = "https://garamgaebi.shop/profile/career"
        
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "company": company,
            "position": position,
            "isWorking": isWorking,
            "startDate": startDate,
            "endDate": endDate
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
                    print("성공(Career추가): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(Career추가): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Career추가): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [POST] 교육 추가
    public static func postEducation(memberIdx: Int, institution: String, major: String, isLearning: String, startDate: String, endDate: String, completion: @escaping ((Bool) -> Void)) {
        
        let url = "https://garamgaebi.shop/profile/education"
        
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "institution": institution,
            "major": major,
            "isLearning": isLearning,
            "startDate": startDate,
            "endDate": endDate
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
                    print("성공(Education추가): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(Education추가): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Education추가): \(error.localizedDescription)")
            }
        }
    }
}
