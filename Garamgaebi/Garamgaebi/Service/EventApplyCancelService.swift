//
//  EventApplyCancelService.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/11.
//

import Foundation
import Combine
import Alamofire

protocol EventApplyCancelServiceType {
	func getUserApplyData(memberId: Int, programId: Int) -> AnyPublisher<EventUserApplyModelResponse, Error>
	func postApplyCancelProgram(memberId: Int, programId: Int, bank: String, account: String) -> AnyPublisher<EventApplyModel, Error>
}

class EventApplyCancelService: EventApplyCancelServiceType {
	func getUserApplyData(memberId: Int, programId: Int) -> AnyPublisher<EventUserApplyModelResponse, Error> {
		let url = "\(Constants.apiUrl)/applies/\(memberId)/\(programId)/info"
		
		return AF.request(url, method: .get, interceptor: MyRequestInterceptor())
			.validate()
			.publishDecodable(type: EventUserApplyModelResponse.self)
			.value()
			.mapError { afError in
				return afError as Error
			}
			.eraseToAnyPublisher()
	}
	
	func postApplyCancelProgram(memberId: Int, programId: Int, bank: String, account: String) -> AnyPublisher<EventApplyModel, Error> {
		let url = "\(Constants.apiUrl)/applies/programs/leave"
		let body: [String: Any] = [
			"memberIdx": memberId,
			"programIdx": programId,
			"bank": bank,
			"account": account
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
