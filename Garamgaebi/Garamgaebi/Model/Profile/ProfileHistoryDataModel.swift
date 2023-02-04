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
struct ProfileEducationDataModel {
    var organization: String
    var position: String
    var startDate: String
    var endDate: String
    
    init(organization: String, position: String, startDate: String, endDate: String) {
        self.organization = organization
        self.position = position
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension ProfileEducationDataModel {
    static let list = [
        ProfileEducationDataModel(organization: "우아한 형제들", position: "프론트엔드 프로그래머", startDate: "2020.04", endDate: "현재"),
        ProfileEducationDataModel(organization: "우아한 형제들", position: "프론트엔드 프로그래머", startDate: "2020.04", endDate: "2021.09")
    ]
}
