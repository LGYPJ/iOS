//
//  EventApplyService.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/02.
//

import Foundation
import Combine
import Alamofire

protocol EventApplyServiceType {
	func postApplyProgram(memberId: Int, programId: Int, name: String, nickname: String, phone: String) -> AnyPublisher<EventApplyModel, Error>
}

class EventApplyService: EventApplyServiceType {
	func postApplyProgram(memberId: Int, programId: Int, name: String, nickname: String, phone: String) -> AnyPublisher<EventApplyModel, Error> {
		let url = URL(string: "\(Constants.apiUrl)/applies/programs/enroll")!
		let body: [String: Any] = [
			"memberIdx": memberId,
			"programIdx": programId,
			"name": name,
			"nickname": nickname,
			"phone": phone
		]
		
		return AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, interceptor: MyRequestInterceptor())
			.validate()
			.publishDecodable(type: EventApplyModel.self)
			.value()
			.mapError { afError in
				return afError as Error
			}
			.eraseToAnyPublisher()
	}
}


