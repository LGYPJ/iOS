//
//  SeminarDetailModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/27.
//

import Foundation

// MARK: 세미나 상세 정보
struct SeminarDetailInfoResponse: Decodable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: SeminarDetailInfo?
}

struct SeminarDetailInfo: Decodable {
	let name: String
	let date: String
	let location: String
	let fee: String
	let endDate: String
	let userButtonStatus: String
}

// MARK: 세미나 참석자 정보
struct SeminarDetailAttentdantResponse: Decodable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: [SeminarDetailAttendant]?
}

struct SeminarDetailAttendant: Decodable {
	let profileImage: String
	let nickname: String
}

// MARK: 세미나 발표 미리보기 정보
struct SeminarDetailPreviewResponse: Decodable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: [SeminarDetailPreview]?
}

struct SeminarDetailPreview: Decodable {
	let profileImage: String
	let previewTitle: String
	let nickname: String
	let organization: String
}
