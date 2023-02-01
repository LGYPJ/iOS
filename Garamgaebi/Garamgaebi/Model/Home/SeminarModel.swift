//
//  SeminarModel.swift
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

struct SeminarThisMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SeminarThisMonthInfo?
}

struct SeminarNextMonthInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SeminarNextMonthInfo?
}

struct SeminarClosedInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [SeminarClosedInfo]?
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

struct SeminarThisMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct SeminarNextMonthInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}

struct SeminarClosedInfo: Decodable {
    let programIdx: Int
    let title: String
    let date: String
    let location: String
    let type: String
    let payment: String
    let status: String
    let isOpen: String
}
