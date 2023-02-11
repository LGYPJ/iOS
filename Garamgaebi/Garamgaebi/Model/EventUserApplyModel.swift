//
//  EventUserApplyModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/11.
//

import Foundation

// 신청 취소 뷰 유저 정보 모델
struct EventUserApplyModelResponse: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: EventUserApplyModel
}

struct EventUserApplyModel: Codable {
	let name: String
	let nickname: String
	let phone: String
}
