//
//  RegisterCareerModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/04.
//

import Foundation

struct RegisterCareerResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Bool
    
}
struct RegisterCareerInfo: Codable {
    let memberIdx: Int
    let company: String
    let position: String
    let isWorking: String
    let startDate: String
    let endDate: String
}
