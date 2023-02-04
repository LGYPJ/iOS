//
//  EventApplyCancelViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/30.
//

import Alamofire

class EventApplyCancelViewModel {
	// MARK: requestData
	// post 은행 계좌
	public static func postBankAccount(memberId: Int, programId: Int, bank: String, account: String, completion: @escaping ((EventApplyModel) -> Void)) {
		let url = "https://garamgaebi.shop/applies/programs/leave"
		
		let body: [String: Any] = [
			"memberIdx": memberId,
			"programIdx": programId,
			"bank": bank,
			"account": account
		]
		
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
			.validate()
			.responseDecodable(of: EventApplyModel.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(result)
					} else {
						completion(result)
						print("실패(프로그램 신청): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-프로그램 신청): \(error.localizedDescription)")
				}
			}
		
	}
}
