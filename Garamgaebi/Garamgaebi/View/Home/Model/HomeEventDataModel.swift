//
//  HomeEventDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

struct HomeEventDataModel {
    
    var title: String
    var date: String
    var location: String
    var fee: Int
    var endDate: String
    var state: String
    var programType: String
    
    init(title: String, date: String, location: String, fee: Int, endDate: String, state: String, programType: String) {
        self.title = title
        self.date = date
        self.location = location
        self.fee = fee
        self.endDate = endDate
        self.state = state
        self.programType = programType
    }
    
}

extension HomeEventDataModel {
    static let list = [
        
        HomeEventDataModel(title: "무료 오픈 세미나 1", date: "2023-02-10", location: "가천대학교 비전타워 B201가천대학교 비전타워 B201가천대학교 비전타워 B201가천대학교 비전타워 B201", fee: 0, endDate: "2023-01-10", state: "오픈", programType: "세미나"),
        HomeEventDataModel(title: "유료 오픈 세미나 1", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈", programType: "세미나"),
        HomeEventDataModel(title: "유료 오픈 세미나 2", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈", programType: "세미나"),
        HomeEventDataModel(title: "무료 예정 세미나 1", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 0, endDate: "2023-01-10", state: "오픈예정", programType: "세미나"),
        
        HomeEventDataModel(title: "무료 마감 세미나", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 0, endDate: "2023-01-10", state: "마감", programType: "세미나"),
        HomeEventDataModel(title: "무료 마감 세미나", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 0, endDate: "2023-01-10", state: "마감", programType: "세미나"),
        
        
        
        HomeEventDataModel(title: "유료 오픈 네트워킹 1", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈", programType: "네트워킹"),
        HomeEventDataModel(title: "무료 예정 네트워킹 1", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 0, endDate: "2023-01-10", state: "오픈예정", programType: "네트워킹"),
        HomeEventDataModel(title: "유료 예정 네트워킹 1", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈예정", programType: "네트워킹"),
        HomeEventDataModel(title: "유료 예정 네트워킹 2", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈예정", programType: "네트워킹"),

        
    ]
}
