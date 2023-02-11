//
//  EventApplyCancelViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/30.
//

import Alamofire

class EventApplyCancelViewModel {
	// MARK: requestData
	// get 유저 데이터
	public static func getUserApplyData(memberId: Int, programId: Int, completion: @escaping ((EventUserApplyModel) -> Void)) {
		let url = "https://garamgaebi.shop/applies/\(memberId)/\(programId)/info"
		let headers: HTTPHeaders = [
			"Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
		]
		AF.request(url, method: .get, headers: headers)
			.validate()
			.responseDecodable(of: EventUserApplyModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(result.result)
					} else {
						print("실패(프로그램 취소/유저 정보): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-프로그램 취소/유저 정보): \(error.localizedDescription)")
				}
			}
	}
	
	// post 은행 계좌
	public static func postBankAccount(memberId: Int, programId: Int, bank: String, account: String, completion: @escaping ((EventApplyModel) -> Void)) {
		let url = "https://garamgaebi.shop/applies/programs/leave"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
        ]
		let body: [String: Any] = [
			"memberIdx": memberId,
			"programIdx": programId,
			"bank": bank,
			"account": account
		]
		
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
			.validate()
			.responseDecodable(of: EventApplyModel.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(result)
					} else {
						completion(result)
						print("실패(프로그램 취소): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-프로그램 취소): \(error.localizedDescription)")
				}
			}
		
	}
}
