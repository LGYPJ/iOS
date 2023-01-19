//
//  HomeUserDataModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

struct HomeUserDataModel {

    // 이미지 뭘로 받을지 모름
    //var profileImage: UIImage
    var nickName: String
    var company: String
    var postion: String
    
    init(nickName: String, company: String, postion: String) {
        self.nickName = nickName
        self.company = company
        self.postion = postion
    }
    
}

extension HomeUserDataModel {
    static let list = [
        HomeUserDataModel(nickName: "네온", company: "가천대학교", postion: "산업디자인학과"),
        HomeUserDataModel(nickName: "네온", company: "데브시스터즈", postion: "프론트엔드 개발자"),
        HomeUserDataModel(nickName: "네온", company: "데브시스터즈", postion: "프론트엔드 개발자"),
        HomeUserDataModel(nickName: "네온", company: "데브시스터즈", postion: "프론트엔드 개발자"),
    ]
}
