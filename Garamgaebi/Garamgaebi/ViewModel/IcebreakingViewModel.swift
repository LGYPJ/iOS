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

struct IceBrakingCurrentUserModelResponse: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: [IceBrakingCurrentUserModel]?
}

struct IceBrakingCurrentUserModel: Codable {
	let memberIdx: Int
	let nickname: String
	let profileUrl: String?
}

struct IcebreakingViewModel {
	public static func postGameUser(roomId: String, memberId: Int, completion: @escaping (() -> Void)) {
		let url = "https://garamgaebi.shop/game/member"
		let headers: HTTPHeaders = [
			"Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
		]
		let body: [String: Any] = [
			"roomId": roomId,
			"memberIdx": memberId
		]
		
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
			.validate()
			.responseDecodable(of: IceBreakingChangeUserModelResposne.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						print("성공(게임 방 유저 추가): roomId: \(roomId)")
						completion()
					} else {
						print("실패(게임 방 유저 추가): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 방 유저 추가): \(error.localizedDescription)")
				}
			}
	}
	
	public static func getCurrentGameUserWithPost(roomId: String, completion: @escaping (([IceBrakingCurrentUserModel]) -> Void)) {
		let url = "https://garamgaebi.shop/game/members"
		let headers: HTTPHeaders = [
			"Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
		]
		let body: [String: String] = [
			"roomId": roomId
		]
		
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
			.validate()
			.responseDecodable(of: IceBrakingCurrentUserModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(result.result ?? [])
					} else {
						print("실패(게임 유저 조회): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 유저 조회): \(error.localizedDescription)")
				}
			}
	}
	
	public static func deleteGameUser(roomId: String, memberId: Int, completion: @escaping (() -> Void)) {
		let url = "https://garamgaebi.shop/game/member"
		let headers: HTTPHeaders = [
			"Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
		]
		let body: [String: Any] = [
			"roomId": roomId,
			"memberIdx": memberId
		]
		
		AF.request(url, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: headers)
			.validate()
			.responseDecodable(of: IceBreakingChangeUserModelResposne.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						print("성공(게임 방 유저 삭제): roomId: \(roomId)")
						completion()
					} else {
						print("실패(게임 방 유저 삭제): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 방 유저 삭제): \(error.localizedDescription)")
				}
			}
	}
}
