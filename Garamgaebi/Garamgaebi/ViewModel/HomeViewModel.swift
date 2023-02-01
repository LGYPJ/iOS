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
        let dummy = [HomeSeminarInfo(programIdx: 1, title: "세미나", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "THIS_MONTH", isOpen: "OPEN")]
        completion(dummy)
        
//        AF.request(url, method: .get)
//            .validate()
//            .responseDecodable(of: HomeSeminarInfoResponse.self) { response in
//                switch response.result {
//                case .success(let result):
//                    if result.isSuccess {
//                        guard let result = result.result else {return}
//                        completion(result)
//                    } else {
//                        // 통신은 정상적으로 됐으나(200), error발생
//                        print("실패(홈 화면 Seminar 조회): \(result.message)")
//                    }
//                case .failure(let error):
//                    // 실제 HTTP에러 404
//                    print("실패(AF-홈 화면 Seminar 조회): \(error.localizedDescription)")
//                }
//            }
    }
 
    
    // MARK: Request [Networking]
    
    // 홈 화면 Networking 조회 request
    public static func getHomeNetworkingInfo(completion: @escaping (([HomeNetworkingInfo]) -> Void)) {
        let url = "https://garamgaebi.shop/networkings/main"
        let dummy = [HomeNetworkingInfo(programIdx: 1, title: "세미나", date: "2023-02-25T18:00:00", location: "가천관", type: "SEMINAR", payment: "FREE", status: "THIS_MONTH", isOpen: "OPEN")]
        completion(dummy)
//        AF.request(url, method: .get)
//            .validate()
//            .responseDecodable(of: HomeNetworkingInfoResponse.self) { response in
//                switch response.result {
//                case .success(let result):
//                    if result.isSuccess {
//                        guard let result = result.result else {return}
//                        completion(result)
//                    } else {
//                        // 통신은 정상적으로 됐으나(200), error발생
//                        print("실패(홈 화면 Networking 조회): \(result.message)")
//                    }
//                case .failure(let error):
//                    // 실제 HTTP에러 404
//                    print("실패(AF-홈 화면 Networking 조회): \(error.localizedDescription)")
//                }
//            }
    }
    
   
   
}
