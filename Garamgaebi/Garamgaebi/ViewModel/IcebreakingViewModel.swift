//
//  IcebreakingViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/14.
//

import Alamofire

// 유저 추가
struct IceBreakingChangeUserModelResposne: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: IceBreakingChangeUserModel?
}

struct IceBreakingChangeUserModel: Codable {
	let message: String
	let currentImgIdx: Int
}

// 현재 유저 조회
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

// 유저 삭제
struct IceBreakingDeleteUserModelResponse: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: String?
}

// 이미지 불러오기
struct IceBreakingImageModelResponse: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: [String]?
}

// 인덱스 PATCH
struct IceBreakingPatchIndexModelResponse: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: String?
}

struct IcebreakingViewModel {
	public static func postGameUser(roomId: String, memberId: Int, completion: @escaping ((Int) -> Void)) {
		let url = "https://garamgaebi.shop/game/member"
		let body: [String: Any] = [
			"roomId": roomId,
			"memberIdx": memberId
		]
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: IceBreakingChangeUserModelResposne.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						print("성공(게임 방 유저 추가): roomId: \(roomId)")
						completion(result.result?.currentImgIdx ?? 0)
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
		let body: [String: String] = [
			"roomId": roomId
		]
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
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
		let body: [String: Any] = [
			"roomId": roomId,
			"memberIdx": memberId
		]
		AF.request(url, method: .delete, parameters: body, encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: IceBreakingDeleteUserModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						print("성공(게임 방 유저 삭제): roomId: \(roomId)")
						completion()
					} else {
						print("실패(게임 방 유저 삭제): \(result.message)")
						completion()
					}
				case .failure(let error):
					print(response.result)
					print("실패(AF-게임 방 유저 삭제): \(error.localizedDescription)")
				}
			}
	}
	
	public static func getGameImage(programId: Int, completion: @escaping (([String]) -> Void)) {
		let url = "https://garamgaebi.shop/game/\(programId)/images"
		AF.request(url, method: .get, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: IceBreakingImageModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(result.result ?? [])
					} else {
						print("실패(게임 이미지 GET): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 이미지 GET): \(error.localizedDescription)")
				}
			}
	}
	
	public static func patchCurrentIndex(roomId: String, completion: @escaping (() -> Void)) {
		let url = "https://garamgaebi.shop/game/current-idx"
		let body: [String: String] = [
			"roomId": roomId
		]
		AF.request(url, method: .patch, parameters: body,encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: IceBreakingPatchIndexModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion()
					} else {
						print("실패(게임 인덱스 PATCH): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 인덱스 PATCH): \(error.localizedDescription)")
				}
			}
	}
    
}
