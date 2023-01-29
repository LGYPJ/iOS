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
		let url = "https://garamgaebi.shop/networkings/info"
		let params = [
			"memberIdx": memberId,
			"programIdx": networkingId
		]
		AF.request(url, method: .get, parameters: params)
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
	public static func requestNetworkingAttendant(networkingId: Int, completion: @escaping ([SeminarDetailAttendant]) -> Void) {
		let url = "https://garamgaebi.shop/seminars/\(networkingId)/participants"
		AF.request(url, method: .get)
			.validate()
			.responseDecodable(of: SeminarDetailAttentdantResponse.self) { response in
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
