//
//  HomeNotificationDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//


import UIKit

struct HomeNotificationDataModel {
//    var title: String
//    var subTitle: String
//
//    init(title: String, subTitle: String) {
//        self.title = title
//        self.subTitle = subTitle
//    }
    
    var image: UIImage
    var category: String
    var content: String
    
    init(image: UIImage, category: String, content: String) {
        self.image = image
        self.category = category
        self.content = content
    }
    
}

extension HomeNotificationDataModel {
    static let list = [
        HomeNotificationDataModel(image: UIImage(named: "supervisorAccountIcon")!, category: "모아보기", content: "새로운 네트워킹이 오픈되었어요"),
        HomeNotificationDataModel(image: UIImage(named: "alarmIcon")!, category: "마감임박", content: "2차 네트워킹 마감이 임박했어요"),
        HomeNotificationDataModel(image: UIImage(named: "supervisorAccountIcon")!, category: "모아보기", content: "새로운 세미나가 오픈되었어요"),
        HomeNotificationDataModel(image: UIImage(named: "supervisorAccountIcon")!, category: "모아보기", content: "새로운 네트워킹이 오픈되었어요"),
        HomeNotificationDataModel(image: UIImage(named: "checkCircleIcon")!, category: "신청완료", content: "2차 네트워킹 신청이 완료되었어요"),
        HomeNotificationDataModel(image: UIImage(named: "checkCircleIcon")!, category: "신청취소완료", content: "2차 네트워킹 신청이 완료되었어요"),
        HomeNotificationDataModel(image: UIImage(named: "supervisorAccountIcon")!, category: "모아보기", content: "새로운 네트워킹이 오픈되었어요"),
        HomeNotificationDataModel(image: UIImage(named: "supervisorAccountIcon")!, category: "모아보기", content: "새로운 네트워킹이 오픈되었어요"),
        
    ]
}
