//
//  HomeMyEventDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

struct HomeMyEventDataModel {
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

extension HomeMyEventDataModel {
    static let list = [
        HomeMyEventDataModel(image: UIImage(named: "PopUpIcon")!),
        HomeMyEventDataModel(image: UIImage(named: "PopUpIcon")!),
        HomeMyEventDataModel(image: UIImage(named: "PopUpIcon")!),
        HomeMyEventDataModel(image: UIImage(named: "PopUpIcon")!),
     
    ]
}
