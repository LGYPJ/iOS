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
    let result: ProfileResult
}
struct ProfileResult: Decodable {
    let memberIdx: Int
    let nickName: String
    let profileEmail: String
    let belong: String
    let content: String?
    let profileUrl: String?
}

// MARK: - ProfileEdit
struct ProfilePostResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Bool
}
