//
//  HomeMyEventDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

struct HomeMyEventDataModel {
    
    var title: String
    var date: Date
    var location: String
    var fee: Int
    var endDate: String
    var state: String
    var programType: String
    
    init(title: String, date: Date, location: String, fee: Int, endDate: String, state: String, programType: String) {
        self.title = title
        self.date = date
        self.location = location
        self.fee = fee
        self.endDate = endDate
        self.state = state
        self.programType = programType
    }
}

extension HomeMyEventDataModel {
    static let list = [
        HomeMyEventDataModel(title: "2차 세미나는 어디까지 길이가 나올까요", date: Date(), location: "가천대학교 비전타워 B201가천대학교 비전타워 B201가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈", programType: "세미나"),
        HomeMyEventDataModel(title: "1차 네트워킹", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈예정", programType: "네트워킹"),
        HomeMyEventDataModel(title: "2차 네트워킹", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감", programType: "네트워킹"),
        HomeMyEventDataModel(title: "3차 네트워킹", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감", programType: "네트워킹"),
    ]
}
