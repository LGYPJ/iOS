//
//  EventApplyViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/31.
//

import Alamofire

class EventApplyViewModel {
	public static func postApplyProgram(memberId: Int, programId: Int, name: String, nickname: String, phone: String, completion: @escaping ((EventApplyModel) -> Void)) {
		let url = "https://garamgaebi.shop/applies/programs/0/enroll"
		
//		let body = EventApplyPostModel(memberIdx: memberId, programIdx: programId, name: name, nickname: nickname, phone: phone)
		
		let body: [String: Any] = [
			"memberIdx": memberId,
			"programIdx": programId,
			"name": name,
			"nickname": nickname,
			"phone": phone
		]
		
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
			.validate()
			.responseDecodable(of: EventApplyModel.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(result)
					} else {
						print("실패(프로그램 신청): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-프로그램 신청): \(error.localizedDescription)")
				}
			}
		
	}
}
