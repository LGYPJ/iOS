//
//  NetworkingDetailModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/29.
//

import Foundation

// MARK: 네트워킹 상세 정보
struct NetworkingDetailInfoResponse: Decodable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: NetworkingDetailInfo?
}

struct NetworkingDetailInfo: Decodable {
	let programIdx: Int
	let title: String
	let date: String
	let location: String
	let fee: Int
	let endDate: String
	let programStatus: String
	let userButtonStatus: String
}

// MARK: 네트워킹 참석자 정보
struct NetworkingDetailAttentdantResponse: Decodable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: [NetworkingDetailAttendant]?
}

struct NetworkingDetailAttendant: Decodable {
	let memberIdx: Int
	let nickname: String
	let profileImg: String
}
