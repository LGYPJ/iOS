//
//  IcebreakingViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/14.
//

import Alamofire

struct IcebreakingViewModel {
	// 게임방 입장
	public static func postGameUser(roomId: String, memberId: Int, completion: @escaping ((IceBreakingChangeUserModel) -> Void)) {
		let url = "https://garamgaebi.shop/game/member"
		let body: [String: Any] = [
			"roomId": roomId
		]
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: IceBreakingChangeUserModelResposne.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						guard let result = result.result else {return}
						print("성공(게임 방 유저 추가): roomId: \(roomId)")
						completion(result)
						
					} else {
						print("실패(게임 방 유저 추가): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 방 유저 추가): \(error.localizedDescription)")
				}
			}
	}
	
	// 게임방 유저 불러오기
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
	
	// 게임방 유저 삭제
	public static func deleteGameUser(roomId: String, nextMemberIdx: Int, completion: @escaping (() -> Void)) {
		let url = "https://garamgaebi.shop/game/member"
		let body: [String: Any] = [
			"roomId": roomId,
			"nextMemberIdx": nextMemberIdx
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
	
	// 게임 이미지 불러오기
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
	
	// 인덱스 플러스
	public static func patchCurrentIndex(roomId: String, nextMemberIdx: Int, completion: @escaping (() -> Void)) {
		let url = "https://garamgaebi.shop/game/current-idx"
		let body: [String: Any] = [
			"roomId": roomId,
			"nextMemberIdx": nextMemberIdx
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
	
	// 진행중인 게임인지 확인
	public static func getGameIsStartedWithPost(roomId: String, completion: @escaping ((Bool) -> Void)) {
		let url = "https://garamgaebi.shop/game/isStarted"
		let body: [String: String] = [
			"roomId": roomId
		]
		
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: IceBreakingIsStartedModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(result.result ?? false)
					} else {
						print("실패(게임 성공여부 조회): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 성공여부 조회): \(error.localizedDescription)")
				}
			}
	}
	
	// 게임 시작 시 진행중인 게임으로 변경
	public static func patchGameStart(roomId: String, completion: @escaping (() -> Void)) {
		let url = "https://garamgaebi.shop/game/startGame"
		let body: [String: String] = [
			"roomId": roomId
		]
		
		AF.request(url, method: .patch, parameters: body, encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: IceBreakingPatchGameStartModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion()
					} else {
						print("실패(게임 시작하기): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-게임 시작하기): \(error.localizedDescription)")
				}
			}
	}
    
}
