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
//		let dummyData = NetworkingDetailInfo(programIdx: 0,title: "2차 네트워킹", date: "2023-1-27 오후 8시", location: "AI공학관 302호", fee: "무료", endDate: "2023-1-20 오후 11시 59분", programStatus: "open", userButtonStatus: "신청하기")
//		completion(dummyData)
		let url = "https://garamgaebi.shop/networkings/info"
		
		// TODO: body데이터 수정예정
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
	public static func requestNetworkingAttendant(networkingId: Int, completion: @escaping ([NetworkingDetailAttendant]) -> Void) {
//		let dummyData = [ NetworkingDetailAttendant(memberIdx: 0, nickname: "연현", profileImg: "person.circle"),
//						  NetworkingDetailAttendant(memberIdx: 1, nickname: "연현2", profileImg: "person"),
//						  NetworkingDetailAttendant(memberIdx: 2,nickname: "연현3", profileImg: "person.fill"),
//						  NetworkingDetailAttendant(memberIdx: 3, nickname: "연현4", profileImg: "person.circle")
//
//		]
//		completion(dummyData)
		let url = "https://garamgaebi.shop/seminars/\(networkingId)/participants"
		AF.request(url, method: .get)
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
