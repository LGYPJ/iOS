//
//  GameRoomListModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/10.
//

import Foundation

struct GameRoomListModelResponse: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: [GameRoomListModel]?
}

struct GameRoomListModel: Codable {
	let gameRoomIdx: Int
	let programIdx: Int
	let roomId: String
}
