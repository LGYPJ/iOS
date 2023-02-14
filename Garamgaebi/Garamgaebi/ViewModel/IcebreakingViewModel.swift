//
//  IcebreakingViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/14.
//

import Alamofire

struct IceBreakingChangeUserModelResposne: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: IceBreakingChangeUserModel?
}

struct IceBreakingChangeUserModel: Codable {
	let message: String
}

struct IcebreakingViewModel {
	public static func postGameUser(roomId: String, memberId: Int, completion: @escaping ((IceBreakingChangeUserModel) -> Void)) {
		let url = "https://garamgaebi.shop/game/member"
		let headers: HTTPHeaders = [
			"Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
		]
		let body: [String: Any] = [
			"roomId": roomId,
			"memberIdx": memberId
		]
		
		AF.request(url, method: .post,parameters: body, headers: headers)
			.validate()
			.responseDecodable(of: IceBreakingChangeUserModelResposne.self) { response in
				
			}
	}
	
	public static func getCurrentGameUser() {
		
	}
	
	public static func deleteGameUser() {
		
	}
}
