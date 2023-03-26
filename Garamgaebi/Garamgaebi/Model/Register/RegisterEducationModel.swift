//
//  RegisterEducationModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/04.
//

import Foundation

struct RegisterEducationResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Bool
    
}
struct RegisterEducationInfo: Codable {
    let memberIdx: Int
    let institution: String
    let major: String
    let isLearning: String
    let startDate: String
    let endDate: String
}
