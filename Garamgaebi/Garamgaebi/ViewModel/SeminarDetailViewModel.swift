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
	public static func requestSeminarDetailInfo(seminarId: Int, completion: @escaping ((SeminarDetailInfo) -> Void)) {
//		let url = ""
		let dummyData = SeminarDetailInfo(name: "16차 세미나", date: "2023-1-27 오후 8시", location: "AI공학관 302호", fee: "무료", endDate: "2023-1-20 오후 11시 59분", userButtonStatus: "신청 마감")
		completion(dummyData)
//		AF.request(url, method: .get)
//			.validate()
//			.responseDecodable(of: SeminarDetailInfoResponse.self) { response in
//				switch response.result {
//				case .success(let result):
//					if result.isSuccess {
//						guard let result = result.result else {return}
//						completion(result)
//					} else {
//						print("실패: \(result.message)")
//					}
//				case .failure(let error):
//					print(error.localizedDescription)
//				}
//			}
	}
	
	// 세미나 참가자 request
	public static func requestSeminarAttendant(seminarId: Int, completion: @escaping ([SeminarDetailAttendant]) -> Void) {
//		let url = ""
		let dummyData = [ SeminarDetailAttendant(profileImage: "person.circle", nickname: "연현"),
						  SeminarDetailAttendant(profileImage: "person", nickname: "연현2"),
						  SeminarDetailAttendant(profileImage: "person.fill", nickname: "연현3"),
						  SeminarDetailAttendant(profileImage: "person.circle", nickname: "연현4")
		
		]
		completion(dummyData)
//		AF.request(url, method: .get)
//			.validate()
//			.responseDecodable(of: SeminarDetailAttentdantResponse.self) { response in
//				switch response.result {
//				case .success(let result):
//					if result.isSuccess {
//						guard let result = result.result else {return}
//						completion(result)
//					} else {
//						print("실패: \(result.message)")
//					}
//				case .failure(let error):
//					print(error.localizedDescription)
//				}
//			}
	}
	
	// 세미나 발표미리보기 request
	public static func requestSeminarPreview(seminarId: Int, completion: @escaping ([SeminarDetailPreview]) -> Void) {
//		let url = ""
		let dummyData = [ SeminarDetailPreview(profileImage: "person", previewTitle: "mvvvm에 대해 알아보자", nickname: "연현", organization: "재학생"),
						  SeminarDetailPreview(profileImage: "person.circle", previewTitle: "Reactive에 대해 알아보자", nickname: "연현2", organization: "재학생2"),
						  SeminarDetailPreview(profileImage: "person.fill", previewTitle: "Reactor에 대해 알아보자", nickname: "연현3", organization: "재학생3")
		]
		completion(dummyData)
//		AF.request(url, method: .get)
//			.validate()
//			.responseDecodable(of: SeminarDetailPreviewResponse.self) { response in
//				switch response.result {
//				case .success(let result):
//					if result.isSuccess {
//						guard let result = result.result else {return}
//						completion(result)
//					} else {
//						print("실패: \(result.message)")
//					}
//				case .failure(let error):
//					print(error.localizedDescription)
//				}
//			}
	}
}
