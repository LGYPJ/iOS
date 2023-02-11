//
//  GameRoomListViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/10.
//

import Alamofire

struct GameRoomListViewModel {
	public static func getGameRoomList(programId: Int, completion: @escaping (([GameRoomListModel]) -> Void)) {
		let url = "https://garamgaebi.shop/game/\(programId)/rooms"
		let headers: HTTPHeaders = [
			"Authorization": "Bearer \(UserDefaults.standard.string(forKey: "BearerToken") ?? "")"
		]
		
		AF.request(url, method: .get, headers: headers)
			.validate()
			.responseDecodable(of: GameRoomListModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						guard let result = result.result else {return}
						completion(result)
					} else {
						// 통신은 정상적으로 됐으나(200), error발생
						print("실패(게임 룸 리스트): \(result.message)")
					}
				case .failure(let error):
					// 실제 HTTP에러 404
					print("실패(AF-게임 룸 리스트): \(error.localizedDescription)")
				}
			}
	}
	
}
