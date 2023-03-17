//
//  LogoutModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/03/16.
//

import Foundation

struct LogoutModelResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: LogoutModel?
}

struct LogoutModel: Codable {
    let memberInfo: String?
}
