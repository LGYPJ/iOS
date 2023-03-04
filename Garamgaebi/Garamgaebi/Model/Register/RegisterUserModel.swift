//
//  RegisterUserModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/06.
//

import Foundation

struct RegisterUserInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: RegisterMemberIdx?
    
}

struct RegisterUserInfo: Codable {
    let nickname: String
    let profileEmail: String
    let identifier: String
    let uniEmail: String
    let status: String
}

struct RegisterMemberIdx: Codable {
    // TODO: snake_case -> camelCase로 추후 변경?
    let memberIdx: Int
}
