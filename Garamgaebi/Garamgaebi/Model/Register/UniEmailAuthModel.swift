//
//  UniEmailAuthModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/04.
//

import Foundation

struct UniEmailAuthModelResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UniEmailAuthNumber
}

struct UniEmailAuthModel: Codable {
    let email: String
}

struct UniEmailAuthNumber: Codable {
    let key: String
}
