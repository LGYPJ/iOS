//
//  ProfileDataModel.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/19.
//

import Foundation

// MARK: - Profile
struct ProfileResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ProfileResult?
}
struct ProfileResult: Decodable {
    let memberIdx: Int
    let nickName: String
    let profileEmail: String
    let belong: String?
    let content: String?
    let profileUrl: String?
    let uniEmail: String
}

// MARK: - ProfileEdit
struct ProfileEditResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ProfileEditResult
}
struct ProfileEditResult: Decodable {
    let memberIdx: Int
}

struct ProfileDefaultResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Bool
}

// MARK: - ProfileWithdrawal
struct WithdrawalResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: WithdrawalResult
}
struct WithdrawalResult: Decodable {
    let inactive_success: Bool
}
