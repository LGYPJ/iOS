//
//  HomeSeminarModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/30.
//

import Foundation

struct HomeSeminarInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeSeminarInfo]?
}

struct HomeSeminarThisMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: HomeSeminarThisMonthInfo?
}

struct HomeSeminarNextMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: HomeSeminarNextMonthInfo?
}

struct HomeSeminarClosedInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeSeminarClosedInfo]?
}

struct HomeSeminarInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct HomeSeminarThisMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct HomeSeminarNextMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct HomeSeminarClosedInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}
