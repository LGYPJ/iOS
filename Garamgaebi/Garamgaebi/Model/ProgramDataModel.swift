//
//  ProgramDataModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/06.
//

import Foundation

// MARK: 프로그램 상세 정보
struct ProgramDetailInfoResponse: Decodable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: ProgramDetailInfo?
}

struct ProgramDetailInfo: Decodable {
	let programIdx: Int
	let title: String
	let date: String
	let location: String
	let fee: Int
	let endDate: String
	let programStatus: String
	let userButtonStatus: String
}

// MARK: 프로그램 참석자 정보
struct ProgramAttentdantResponse: Decodable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: ProgramAttendantResult?
}

struct ProgramAttendantResult: Decodable {
	let participantList: [ProgramAttendant]?
	let isApply: Bool
}

struct ProgramAttendant: Decodable {
	let memberIdx: Int
	let nickname: String
	let profileImg: String?
}
