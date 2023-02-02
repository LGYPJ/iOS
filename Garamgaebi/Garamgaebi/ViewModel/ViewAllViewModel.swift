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
    public static func getSeminarThisMonthInfo(completion: @escaping ((SeminarThisMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/this-month"
 
//        let dummy = SeminarThisMonthInfo(programIdx: 1, title: "세미나", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "THIS_MONTH", isOpen: "OPEN")
//        completion(dummy)

        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: SeminarThisMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 이번 달 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 이번 달 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 예정된 Seminar 조회 request
    public static func getSeminarNextMonthInfo(completion: @escaping ((SeminarNextMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/next-month"
 
//        let dummy = SeminarNextMonthInfo(programIdx: 1, title: "세미나", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "THIS_MONTH", isOpen: "OPEN")
//        completion(dummy)

        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: SeminarNextMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 예정된 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 예정된 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 마감된 Seminar 조회 request
    public static func getSeminarClosedInfo(completion: @escaping (([SeminarClosedInfo]) -> Void)) {
        let url = "https://garamgaebi.shop/seminars/closed"
//        let dummy = [SeminarClosedInfo(programIdx: 1, title: "세미나", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "THIS_MONTH", isOpen: "OPEN")]
//        completion(dummy)

        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: SeminarClosedInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 마감된 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 마감된 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Request [Networking]
    // 이번 달 Networking 조회 request
    public static func getNetworkingThisMonthInfo(completion: @escaping ((NetworkingThisMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/this-month"
 
//        let dummy = NetworkingThisMonthInfo(programIdx: 1, title: "네트워킹1", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "THIS_MONTH", isOpen: "OPEN")
//        completion(dummy)
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: NetworkingThisMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 이번 달 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 이번 달 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 예정된 Networking 조회 request
    public static func getNetworkingNextMonthInfo(completion: @escaping ((NetworkingNextMonthInfo) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/next-month"
 
//        let dummy = NetworkingNextMonthInfo(programIdx: 1, title: "네트워킹2", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "NEXT_MONTH", isOpen: "OPEN")
//        completion(dummy)
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: NetworkingNextMonthInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 예정된 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 예정된 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // 마감된 Networking 조회 request
    public static func getNetworkingClosedInfo(completion: @escaping (([NetworkingClosedInfo]) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/closed"
 
//        let dummy = [NetworkingClosedInfo(programIdx: 1, title: "네트워킹33", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "CLOSED", isOpen: "OPEN")]
//        completion(dummy)
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: NetworkingClosedInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        guard let result = result.result else {return}
                        completion(result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(모아보기 화면 마감된 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-모아보기 화면 마감된 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
}
