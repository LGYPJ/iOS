//
//  ViewAllMyEventDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/17.
//

import UIKit

struct ViewAllMyEventDataModel {
    
    var title: String
    var date: Date
    var location: String
    var fee: Int
    var endDate: String
    var state: String
    

    init(title: String, date: Date, location: String, fee: Int, endDate: String, state: String) {
        self.title = title
        self.date = date
        self.location = location
        self.fee = fee
        self.endDate = endDate
        self.state = state
    }
    
}

extension ViewAllMyEventDataModel {
    static let list = [
        
        ViewAllMyEventDataModel(title: "2차 세미나", date: Date(), location: "가천대학교 비전타워 B201가천대학교 비전타워 B201가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈"),
        ViewAllMyEventDataModel(title: "3차 세미나", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈예정"),
        ViewAllMyEventDataModel(title: "3차 세미나", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감"),
        ViewAllMyEventDataModel(title: "3차 세미나", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감"),
        ViewAllMyEventDataModel(title: "3차 세미나", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감"),
        ViewAllMyEventDataModel(title: "3차 세미나", date: Date(), location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감"),
        
        
    ]
}
