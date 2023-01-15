//
//  EventDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

struct EventDataModel {
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

extension EventDataModel {
    static let list = [
        EventDataModel(image: UIImage(named: "PopUpIcon")!),
        EventDataModel(image: UIImage(named: "PopUpIcon")!),
        EventDataModel(image: UIImage(named: "PopUpIcon")!),
        EventDataModel(image: UIImage(named: "PopUpIcon")!),
        EventDataModel(image: UIImage(named: "PopUpIcon")!),
    ]
}
