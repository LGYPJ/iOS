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
    let result: Bool?
}

struct UniEmailAuthModel: Codable {
    let email: String
}

struct UniEmailAuthNumberModelResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UniEmailAuthNumberModelResult?
}

struct UniEmailAuthNumberModel: Codable {
    let email: String
    let key: String
}

struct UniEmailAuthNumberModelResult: Codable {
    let message: String
}
