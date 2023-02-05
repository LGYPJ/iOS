//
//  LoginModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/03.
//

import Foundation

struct LoginModelResponse: Codable {
	let isSuccess: Bool
	let code: Int
	let message: String
	let result: LoginModel
}

struct LoginModel: Codable {
	let grantType: String
    let memberIdx: Int
	let accessToken: String
	let refreshToken: String
	let refreshTokenExpirationTime: Int
	let memberIdx: Int
}
