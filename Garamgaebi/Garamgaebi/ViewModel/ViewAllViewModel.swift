//
//  ViewAllViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/01.
//

import Alamofire

// 홈 화면 ViewModel
class ViewAllViewModel {
    // MARK: Request [Seminar]
    
    // 이번 달 Seminar 조회 request
    public static func getSeminarThisMonthInfo(completion: @escaping ((Result<SeminarThisMonthInfoResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/this-month"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: SeminarThisMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 이번 달 Seminar 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 이번 달 Seminar 조회): \(error.localizedDescription)")
                    completion(response.result)
                }
            }
    }
    
    // 예정된 Seminar 조회 request
    public static func getSeminarNextMonthInfo(completion: @escaping ((Result<SeminarNextMonthInfoResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/next-month"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: SeminarNextMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 예정된 Seminar 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    completion(response.result)
                    print("실패(AF-모아보기 화면 예정된 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 마감된 Seminar 조회 request
    public static func getSeminarClosedInfo(completion: @escaping ((Result<SeminarClosedInfoResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/closed"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: SeminarClosedInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 마감된 Seminar 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 마감된 Seminar 조회): \(error.localizedDescription)")
                    completion(response.result)
                }
            }
    }
    
    // MARK: Request [Networking]
    // 이번 달 Networking 조회 request
    public static func getNetworkingThisMonthInfo(completion: @escaping ((Result<NetworkingThisMonthInfoResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/this-month"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: NetworkingThisMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 이번 달 Networking 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 이번 달 Networking 조회): \(error.localizedDescription)")
                    completion(response.result)
                }
            }
    }
    
    // 예정된 Networking 조회 request
    public static func getNetworkingNextMonthInfo(completion: @escaping ((Result<NetworkingNextMonthInfoResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/next-month"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: NetworkingNextMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 예정된 Networking 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 예정된 Networking 조회): \(error.localizedDescription)")
                    completion(response.result)
                }
            }
    }
    
    // 마감된 Networking 조회 request
    public static func getNetworkingClosedInfo(completion: @escaping ((Result<NetworkingClosedInfoResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/closed"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: NetworkingClosedInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 마감된 Networking 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 마감된 Networking 조회): \(error.localizedDescription)")
                    completion(response.result)
                }
            }
    }
    
    
    // MARK: Request [내 모임]
    
    // 모아보기 예정된 모임 조회 request
    public static func getViewAllMyEventReadyInfo(memberId: Int, completion: @escaping ((Result<MyEventInfoReadyResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/programs/\(memberId)/ready"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: MyEventInfoReadyResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 MyEventReadyInfo 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 MyEventReadyInfo 조회): \(error.localizedDescription)")
                    completion(response.result)
                }
            }
    }
    
    // 모아보기 마감된 모임 조회 request
    public static func getViewAllMyEventCloseInfo(memberId: Int, completion: @escaping ((Result<MyEventInfoCloseResponse, AFError>) -> Void)) {
        let url = "https://garamgaebi.shop/programs/\(memberId)/close"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: MyEventInfoCloseResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 MyEventCloseInfo 조회): \(result.message)")
                        completion(response.result)
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 MyEventCloseInfo 조회): \(error.localizedDescription)")
                    completion(response.result)
                }
            }
    }
    
}
