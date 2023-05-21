//
//  ProgramDetailService.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/06.
//

import Foundation
import Combine
import Alamofire

enum ProgramType {
	case SEMINAR
	case NETWORKING
}

protocol ProgramDetailServiceType {
	func getProgramDetailInfo(type: ProgramType, memberId: Int, programId: Int) -> AnyPublisher<ProgramDetailInfoResponse, Error>
}

class ProgramDetailService: ProgramDetailServiceType {
	func getProgramDetailInfo(type: ProgramType, memberId: Int, programId: Int) -> AnyPublisher<ProgramDetailInfoResponse, Error> {
		switch type {
		case .SEMINAR:
			let url = URL(string: "\(Constants.apiUrl)/seminars/\(programId)/info?member-idx=\(memberId)")!
			
			return AF.request(url, method: .get, interceptor: MyRequestInterceptor())
				.validate()
			 .publishDecodable(type: ProgramDetailInfoResponse.self)
			 .value()
			 .mapError { afError in
				 return afError as Error
			 }
			 .eraseToAnyPublisher()
			
		case .NETWORKING:
			let url = URL(string: "\(Constants.apiUrl)/networkings/\(programId)/info?member-idx=\(memberId)")!
			
			return AF.request(url, method: .get, interceptor: MyRequestInterceptor())
				.validate()
			 .publishDecodable(type: ProgramDetailInfoResponse.self)
			 .value()
			 .mapError { afError in
				 return afError as Error
			 }
			 .eraseToAnyPublisher()
		}
	}
}
