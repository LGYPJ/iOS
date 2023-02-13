//
//  ProfileHistoryDataModel.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/02/02.
//

import Foundation

// MARK: - SNS
struct SnsResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [SnsResult]
}
struct SnsResult: Decodable {
    let snsIdx: Int
    let address: String
    let type: String?
}

class SnsData {
    static let shared = SnsData()
    
    var snsDataModel: [SnsResult] = []
}


// MARK: - Career
struct CareerResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [CareerResult]
}
struct CareerResult: Decodable {
    let careerIdx: Int
    let company: String
    let position: String
    let isWorking: String
    let startDate: String // 2023-02-04T01:04:23.436Z
    let endDate: String
}

class CareerData {
    static let shared = CareerData()
    
    var careerDataModel: [CareerResult] = []
}


// MARK: - Education
struct EducationResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [EducationResult]
}
struct EducationResult: Decodable {
    let educationIdx: Int
    let institution: String
    let major: String
    let isLearning: String
    let startDate: String
    let endDate: String
}

class EducationData {
    static let shared = EducationData()
    
    var educationDataModel: [EducationResult] = []
}
