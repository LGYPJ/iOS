//
//  HomeUserDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

struct HomeUserDataModel {
//    var title: String
//    var subTitle: String
//
//    init(title: String, subTitle: String) {
//        self.title = title
//        self.subTitle = subTitle
//    }
    
    var image: UIImage
    init(image: UIImage) {
        self.image = image
    }
    
}

extension HomeUserDataModel {
    static let list = [
        HomeUserDataModel(image: UIImage(named: "PopUpIcon")!),
        HomeUserDataModel(image: UIImage(named: "PopUpIcon")!),
        HomeUserDataModel(image: UIImage(named: "PopUpIcon")!),
        HomeUserDataModel(image: UIImage(named: "PopUpIcon")!),
        HomeUserDataModel(image: UIImage(named: "PopUpIcon")!),
    ]
}
