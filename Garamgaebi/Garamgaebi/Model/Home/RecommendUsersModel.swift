//
//  RecommendUsersModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/02.
//

import Foundation

struct RecommendUsersInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [RecommendUsersInfo]?
}

struct RecommendUsersInfo: Decodable {
    let memberIdx: Int
    let nickName: String
    let profileUrl: String?
    let belong: String?
    let group: String
    let detail: String
}
