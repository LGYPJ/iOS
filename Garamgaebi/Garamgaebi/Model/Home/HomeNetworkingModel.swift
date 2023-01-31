//
//  HomeNetworkingModel.swift
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

struct HomeNetworkingThisMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: HomeNetworkingThisMonthInfo?
}

struct HomeNetworkingNextMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: HomeNetworkingNextMonthInfo?
}

struct HomeNetworkingClosedInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeNetworkingClosedInfo]?
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

struct HomeNetworkingThisMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct HomeNetworkingNextMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct HomeNetworkingClosedInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}
