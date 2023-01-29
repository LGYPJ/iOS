//
//  SeminarDetailViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/27.
//

import Alamofire

// 세미나 상세보기 ViewModel
class SeminarDetailViewModel {
	// MARK: requestData
	// 세미나 정보 request
	public static func requestSeminarDetailInfo(memberId: Int, seminarId: Int, completion: @escaping ((SeminarDetailInfo) -> Void)) {
//		let dummyData = SeminarDetailInfo(title: "16차 세미나", date: "2023-1-27 오후 8시", location: "AI공학관 302호", fee: "무료", endDate: "2023-1-20 오후 11시 59분", userButtonStatus: "신청 마감")
//		completion(dummyData)
		let url = "https://garamgaebi.shop/seminars/info"
		let params = [
			"memberIdx": memberId,
			"programIdx": seminarId
		]
		AF.request(url, method: .get, parameters: params)
			.validate()
			.responseDecodable(of: SeminarDetailInfoResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						guard let result = result.result else {return}
						completion(result)
					} else {
						// 통신은 정상적으로 됐으나(200), error발생
						print("실패(세미나 상세정보): \(result.message)")
					}
				case .failure(let error):
					// 실제 HTTP에러 404
					print("실패(AF-세미나 상세정보): \(error.localizedDescription)")
				}
			}
	}
	
	// 세미나 참가자 request
	public static func requestSeminarAttendant(seminarId: Int, completion: @escaping ([SeminarDetailAttendant]) -> Void) {
//		let url = ""
//		let dummyData = [ SeminarDetailAttendant(profileImg: "person.circle", nickname: "연현"),
//						  SeminarDetailAttendant(profileImg: "person", nickname: "연현2"),
//						  SeminarDetailAttendant(profileImg: "person.fill", nickname: "연현3"),
//						  SeminarDetailAttendant(profileImg: "person.circle", nickname: "연현4")
//
//		]
//		completion(dummyData)
		let url = "https://garamgaebi.shop/seminars/\(seminarId)/participants"
		AF.request(url, method: .get)
			.validate()
			.responseDecodable(of: SeminarDetailAttentdantResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						guard let result = result.result else {return}
						completion(result)
					} else {
						print("실패(세미나 참석자): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-세미나 참석자): \(error.localizedDescription)")
				}
			}
	}
	
	// 세미나 발표미리보기 request
	public static func requestSeminarPreview(seminarId: Int, completion: @escaping ([SeminarDetailPreview]) -> Void) {
//		let url = ""
//		let dummyData = [ SeminarDetailPreview(profileImage: "person", previewTitle: "mvvvm에 대해 알아보자", nickname: "연현", organization: "재학생"),
//						  SeminarDetailPreview(profileImage: "person.circle", previewTitle: "Reactive에 대해 알아보자", nickname: "연현2", organization: "재학생2"),
//						  SeminarDetailPreview(profileImage: "person.fill", previewTitle: "Reactor에 대해 알아보자", nickname: "연현3", organization: "재학생3")
//		]
//		completion(dummyData)
		let url = "https://garamgaebi.shop/seminars/\(seminarId)/presentations"
		AF.request(url, method: .get)
			.validate()
			.responseDecodable(of: SeminarDetailPreviewResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						guard let result = result.result else {return}
						completion(result)
					} else {
						print("실패(세미나 미리보기): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-세미나 미리보기): \(error.localizedDescription)")
				}
			}
	}
}
