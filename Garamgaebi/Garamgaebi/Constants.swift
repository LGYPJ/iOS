//
//  Constants.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/03/21.
//

import Foundation

struct Constants {
	// !!!: 반드시 prod서버(true)인 상태로 배포해야함!!
	static let isProd: Bool = true  // true면 prod서버, false면 test서버
	static let apiUrl = isProd ? "https://garamgaebi.shop" : "https://dev.garamgaebi.shop"
}
