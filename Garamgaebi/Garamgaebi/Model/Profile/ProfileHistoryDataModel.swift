//
//  ProfileHistoryDataModel.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/02/02.
//

import Foundation

// MARK: - SNS
struct ProfileSnsDataModel {
    var sns: String
    
    init(sns: String) {
        self.sns = sns
    }
}

extension ProfileSnsDataModel {
    static let data = [
        ProfileSnsDataModel(sns: "neoninstagram.com")
    ]
}


// MARK: - Career
struct ProfileCareerDataModel {
    var company: String
    var position: String
    var startDate: String
    var endDate: String
    
    init(company: String, position: String, startDate: String, endDate: String) {
        self.company = company
        self.position = position
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension ProfileCareerDataModel {
    static let list = [
        ProfileCareerDataModel(company: "우아한 형제들", position: "프론트엔드 프로그래머", startDate: "2020.04", endDate: "현재"),
        ProfileCareerDataModel(company: "우아한 형제들", position: "프론트엔드 프로그래머", startDate: "2020.04", endDate: "2021.09"),
        ProfileCareerDataModel(company: "우아한 형제들", position: "프론트엔드 프로그래머", startDate: "2020.04", endDate: "2021.09")
    ]
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