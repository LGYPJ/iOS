//
//  IceBreakingModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/26.
//

import Foundation

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
	let currentMemberIdx: Int
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
