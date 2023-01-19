//
//  ViewAllSeminarDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/16.
//

import UIKit

struct ViewAllSeminarDataModel {
    
    var title: String
    var date: String
    var location: String
    var fee: Int
    var endDate: String
    var state: String
    
    init(title: String, date: String, location: String, fee: Int, endDate: String, state: String) {
        self.title = title
        self.date = date
        self.location = location
        self.fee = fee
        self.endDate = endDate
        self.state = state
    }
    
}

extension ViewAllSeminarDataModel {
    static let list = [
        
        ViewAllSeminarDataModel(title: "2차 세미나", date: "2023-02-10", location: "가천대학교 비전타워 B201가천대학교 비전타워 B201가천대학교 비전타워 B201가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈"),
        ViewAllSeminarDataModel(title: "3차 세미나", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "오픈예정"),
        ViewAllSeminarDataModel(title: "3차 세미나", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감"),
        ViewAllSeminarDataModel(title: "3차 세미나", date: "2023-02-10", location: "가천대학교 비전타워 B201", fee: 10000, endDate: "2023-01-10", state: "마감"),
        
    ]
}
