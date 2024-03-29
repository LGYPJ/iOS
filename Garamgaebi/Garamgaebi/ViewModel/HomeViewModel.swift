//
//  HomeViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/24.
//

import Alamofire

// 홈 화면 ViewModel
class HomeViewModel {
    // MARK: Request [Seminar]
    public static func getHomeSeminarInfo(completion: @escaping ((Result<HomeSeminarInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/seminars/main"
		AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: HomeSeminarInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        completion(response.result)
                        print("실패(홈 화면 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 ex)404
                    completion(response.result)
                    print("실패(AF-홈 화면 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Request [Networking]
    public static func getHomeNetworkingInfo(completion: @escaping ((Result<HomeNetworkingInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/networkings/main"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: HomeNetworkingInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Request [가람개비 유저]
    public static func getRecommendUsersInfo(completion: @escaping ((Result<RecommendUsersInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/profile/profiles"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: RecommendUsersInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 RecommedUsers 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 RecommedUsers 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Request [내 모임]
    public static func getHomeMyEventInfo(memberId: Int, completion: @escaping ((Result<MyEventInfoReadyResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/programs/\(memberId)/ready"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: MyEventInfoReadyResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 MyEvent 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 MyEvent 조회): \(error.localizedDescription)")
                }
            }
    }
    
}
