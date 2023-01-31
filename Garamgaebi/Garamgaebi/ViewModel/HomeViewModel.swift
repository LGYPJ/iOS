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
    
    // 홈 화면 Seminar 조회 request
    public static func getHomeSeminarInfo(completion: @escaping (([HomeSeminarInfo]) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/main"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeSeminarInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 홈 화면 이번 달 Seminar 조회 request
    public static func getHomeThisMonthSeminarInfo(completion: @escaping ((HomeSeminarThisMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/this-month"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeSeminarThisMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 이번 달 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 이번 달 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 홈 화면 예정된 Seminar 조회 request
    public static func getHomeSeminarNextMonthInfo(completion: @escaping ((HomeSeminarNextMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/next-month"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeSeminarNextMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 예정된 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 예정된 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 홈 화면 마감된 Seminar 조회 request
    public static func getHomeSeminarClosedInfo(completion: @escaping (([HomeSeminarClosedInfo]) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/closed"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeSeminarClosedInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 마감된 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 마감된 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Request [Networking]
    
    // 홈 화면 Networking 조회 request
    public static func getHomeNetworkingInfo(completion: @escaping (([HomeNetworkingInfo]) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/main"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeNetworkingInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
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
    
    // 홈 화면 이번 달 Networking 조회 request
    public static func getHomeThisMonthNetworkingInfo(completion: @escaping ((HomeNetworkingThisMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/networking/this-month"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeNetworkingThisMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 이번 달 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 이번 달 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 홈 화면 예정된 Networking 조회 request
    public static func getHomeNetworkingNextMonthInfo(completion: @escaping ((HomeNetworkingNextMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/next-month"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeNetworkingNextMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 예정된 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 예정된 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 홈 화면 마감된 Networking 조회 request
    public static func getHomeNetworkingClosedInfo(completion: @escaping (([HomeNetworkingClosedInfo]) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/closed"
 
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: HomeNetworkingClosedInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 마감된 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 마감된 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
   
}
