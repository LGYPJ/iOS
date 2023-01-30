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
		let dummyData = SeminarDetailInfo(programIdx: 0,title: "2차 세미나", date: "2023-1-27 오후 8시", location: "AI공학관 302호", fee: "무료", endDate: "2023-1-20 오후 11시 59분", programStatus: "open", userButtonStatus: "신청하기")
		completion(dummyData)
//		let url = "https://garamgaebi.shop/seminars/info"
//		let params = [
//			"memberIdx": memberId,
//			"programIdx": seminarId
//		]
//		AF.request(url, method: .get, parameters: params)
//			.validate()
//			.responseDecodable(of: SeminarDetailInfoResponse.self) { response in
//				switch response.result {
//				case .success(let result):
//					if result.isSuccess {
//						guard let result = result.result else {return}
//						completion(result)
//					} else {
//						// 통신은 정상적으로 됐으나(200), error발생
//						print("실패(세미나 상세정보): \(result.message)")
//					}
//				case .failure(let error):
//					// 실제 HTTP에러 404
//					print("실패(AF-세미나 상세정보): \(error.localizedDescription)")
//				}
//			}
	}
	
	// 세미나 참가자 request
	public static func requestSeminarAttendant(seminarId: Int, completion: @escaping ([SeminarDetailAttendant]) -> Void) {
		let dummyData = [ SeminarDetailAttendant(memberIdx: 0, nickname: "연현", profileImg: "person.circle"),
						  SeminarDetailAttendant(memberIdx: 1, nickname: "연현2", profileImg: "person"),
						  SeminarDetailAttendant(memberIdx: 2,nickname: "연현3", profileImg: "person.fill"),
						  SeminarDetailAttendant(memberIdx: 3, nickname: "연현4", profileImg: "person.circle")

		]
		completion(dummyData)
//		let url = "https://garamgaebi.shop/seminars/\(seminarId)/participants"
//		AF.request(url, method: .get)
//			.validate()
//			.responseDecodable(of: SeminarDetailAttentdantResponse.self) { response in
//				switch response.result {
//				case .success(let result):
//					if result.isSuccess {
//						guard let result = result.result else {return}
//						completion(result)
//					} else {
//						print("실패(세미나 참석자): \(result.message)")
//					}
//				case .failure(let error):
//					print("실패(AF-세미나 참석자): \(error.localizedDescription)")
//				}
//			}
	}
	
	// 세미나 발표미리보기 request
	public static func requestSeminarPreview(seminarId: Int, completion: @escaping ([SeminarDetailPreview]) -> Void) {
		let dummyData = [ SeminarDetailPreview(presentationIdx: 0, title: "mvvvm에 대해 알아보자", nickname: "연현", profileImgUrl: "person", organization: "재학생", content: "mvvm은 model, view, viewmodel로 이루어져있습니다.", presentationUrl: nil),
						  SeminarDetailPreview(presentationIdx: 0, title: "swift에 대해 알아보자", nickname: "팀 쿡", profileImgUrl: "person", organization: "apple", content: "swift는 apple에서 개발한 언어로 아주 좋습니다.", presentationUrl: nil),
						  SeminarDetailPreview(presentationIdx: 0, title: "가천대학교에 대해 알아보자", nickname: "이길여", profileImgUrl: "person", organization: "가천대학교", content: "가천대학교는 경기도 성남시에 위치한 명문대입니다.", presentationUrl: nil)
		]
		completion(dummyData)
//		let url = "https://garamgaebi.shop/seminars/\(seminarId)/presentations"
//		AF.request(url, method: .get)
//			.validate()
//			.responseDecodable(of: SeminarDetailPreviewResponse.self) { response in
//				switch response.result {
//				case .success(let result):
//					if result.isSuccess {
//						guard let result = result.result else {return}
//						completion(result)
//					} else {
//						print("실패(세미나 미리보기): \(result.message)")
//					}
//				case .failure(let error):
//					print("실패(AF-세미나 미리보기): \(error.localizedDescription)")
//				}
//			}
	}
}