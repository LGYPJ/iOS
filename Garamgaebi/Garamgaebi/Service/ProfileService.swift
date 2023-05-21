//
//  ProfileService.swift
//  Garamgaebi
//
//  Created by 서은수 on 2023/05/13.
//

import UIKit
import Combine

import Alamofire

protocol ProfileServiceType {
    func getMyProfile(memberIdx: Int) -> AnyPublisher<ProfileResponse, Error>
}

class ProfileService: ProfileServiceType {
    func getMyProfile(memberIdx: Int) -> AnyPublisher<ProfileResponse, Error> {
        // http 요청 주소 지정
        let url = "\(Constants.apiUrl)/profile/\(memberIdx)"
        
        return AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .publishDecodable(type: ProfileResponse.self) // 디코딩
            .value() // 값만 가져오기
            .mapError { (afError: AFError) in
                //.value를 거치면 AnyPublisher<Value, AFError> 상태이므로 AFError -> Error로 캐스팅
                return afError as Error
            }
            .eraseToAnyPublisher()
    }
}
