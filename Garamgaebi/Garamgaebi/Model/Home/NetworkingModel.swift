//
//  NetworkingModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/30.
//

import Foundation

struct HomeNetworkingInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeNetworkingInfo]?
}

struct NetworkingThisMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: NetworkingThisMonthInfo?
}

struct NetworkingNextMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: NetworkingNextMonthInfo?
}

struct NetworkingClosedInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [NetworkingClosedInfo]?
}

struct HomeNetworkingInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct NetworkingThisMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct NetworkingNextMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct NetworkingClosedInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}
