//
//  SeminarDetailService.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/03.
//

import Foundation
import Combine

protocol SeminarDetailServiceType {
	func getSeminarDetailInfo(memberId: Int, seminarId: Int) -> AnyPublisher<SeminarDetailInfoResponse, Error>
	// TODO: 나머지 추가
}

class SeminarDetailService: SeminarDetailServiceType {
	func getSeminarDetailInfo(memberId: Int, seminarId: Int) -> AnyPublisher<SeminarDetailInfoResponse, Error> {
		let url = URL(string: "\(Constants.apiUrl)/seminars/\(seminarId)/info?member-idx=\(memberId)")!
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.catch { error in
				return Fail(error: error).eraseToAnyPublisher()
			}
			.map {$0.data}
			.decode(type: SeminarDetailInfoResponse.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
		
	}
}
