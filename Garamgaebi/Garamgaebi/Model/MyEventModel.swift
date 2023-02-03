//
//  MyEventModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/02.
//

import Foundation

// MARK: 내 모임

struct MyEventInfoReadyResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [MyEventInfoReady]?
}

struct MyEventInfoReady: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct MyEventInfoCloseResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [MyEventInfoClose]?
}

struct MyEventInfoClose: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct MyEventToDetailInfo {
    let programIdx: Int
    let type: String
}
