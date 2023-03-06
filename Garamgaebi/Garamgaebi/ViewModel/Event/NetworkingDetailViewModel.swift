//
//  NetworkingDetailViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/29.
//

import Alamofire

class NetworkingDetailViewModel {
	// MARK: requestData
	// 세미나 정보 request
	public static func requestNetworkingDetailInfo(memberId: Int, networkingId: Int, completion: @escaping ((NetworkingDetailInfo) -> Void)) {
//		let dummyData = NetworkingDetailInfo(programIdx: networkingId,title: "유료 네트워킹1", date: "2023-04-15T18:00:00", location: "가천관", fee: 10000, endDate: "2023-04-08T18:00:00", programStatus: "OPEN", userButtonStatus: "CANCEL")
//		completion(dummyData)
		let url = "https://garamgaebi.shop/networkings/\(networkingId)/info"
		let params: Parameters = [
			"member-idx": memberId
		]

		AF.request(url, method: .get, parameters: params, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: NetworkingDetailInfoResponse.self) { resposne in
				switch resposne.result {
				case .success(let result):
					if result.isSuccess {
						guard let result = result.result else {return}
						completion(result)
					} else {
						// 통신은 정상적으로 됐으나(200), error발생
						print("실패(네트워킹 상세정보): \(result.message)")
					}
				case .failure(let error):
					// 실제 HTTP에러 404
					print("실패(AF-네트워킹 상세정보): \(error.localizedDescription)")
				}
			}
	}
	
	// 네트워킹 참가자 request
	public static func requestNetworkingAttendant(networkingId: Int, completion: @escaping (NetworkingAttendantResult) -> Void) {
//		let dummyData = [ NetworkingDetailAttendant(memberIdx: 0, nickname: "연현", profileImg: "person.circle"),
//						  NetworkingDetailAttendant(memberIdx: 1, nickname: "연현2", profileImg: "person"),
//						  NetworkingDetailAttendant(memberIdx: 2,nickname: "연현3", profileImg: "person.fill"),
//						  NetworkingDetailAttendant(memberIdx: 3, nickname: "연현4", profileImg: "person.circle")
//
//		]
//		completion(dummyData)
		let url = "https://garamgaebi.shop/networkings/\(networkingId)/participants"
		let params: Parameters = [
			"member-idx": UserDefaults.standard.integer(forKey: "memberIdx")
		]
		AF.request(url, method: .get, parameters: params, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: NetworkingDetailAttentdantResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						guard let result = result.result else {return}
						completion(result)
					} else {
						print("실패(네트워킹 참석자): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-네트워킹 참석자): \(error.localizedDescription)")
				}
			}
	}
}
