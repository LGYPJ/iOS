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
	public static func requestSeminarDetailInfo(memberId: Int, seminarId: Int, completion: @escaping ((Result<ProgramDetailInfoResponse, AFError>) -> Void)) {
//		let dummyData = SeminarDetailInfo(programIdx: seminarId	,title: "무료 세미나1", date: "2023-01-15T18:00:00", location: "가천관", fee: 0, endDate: "2023-01-08T18:00:00", programStatus: "CLOSED_CONFIRM", userButtonStatus: "APPLY")
//		completion(dummyData)
		let url = "\(Constants.apiUrl)/seminars/\(seminarId)/info"
		let params: Parameters = [
			"member-idx": memberId
		]

		AF.request(url, method: .get, parameters: params, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: ProgramDetailInfoResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
						completion(response.result)
					} else {
						// 통신은 정상적으로 됐으나(200), error발생
						completion(response.result)
						print("실패(세미나 상세정보): \(result.message)")
					}
				case .failure(let error):
					// 실제 HTTP에러 404
					completion(response.result)
					print("실패(AF-세미나 상세정보): \(error.localizedDescription)")
				}
			}
	}
	
	// 세미나 참가자 request
	public static func requestSeminarAttendant(seminarId: Int, completion: @escaping (ProgramAttendantResult) -> Void) {
//		let dummyData = [ SeminarDetailAttendant(memberIdx: 0, nickname: "연현", profileImg: "ExProfileImage"),
//						  SeminarDetailAttendant(memberIdx: 1, nickname: "연현2", profileImg: "ExProfileImage"),
//						  SeminarDetailAttendant(memberIdx: 2,nickname: "연현3", profileImg: "ExProfileImage"),
//						  SeminarDetailAttendant(memberIdx: 3, nickname: "연현4", profileImg: "ExProfileImage")
//
//		]
//		completion(dummyData)
		let url = "\(Constants.apiUrl)/seminars/\(seminarId)/participants"
		let params: Parameters = [
			"member-idx": UserDefaults.standard.integer(forKey: "memberIdx")
		]
		AF.request(url, method: .get, parameters: params, interceptor: MyRequestInterceptor())
			.validate()
			.responseDecodable(of: ProgramAttentdantResponse.self) { response in
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
//		let dummyData = [ SeminarDetailPreview(presentationIdx: 0, title: "mvvvm에 대해 알아보자", nickname: "연현", profileImgUrl: "https://garamgaebi-bucket.s3.ap-northeast-2.amazonaws.com/profile/Member2_Profile.png", organization: "재학생", content: "mvvm은 model, view, viewmodel로 이루어져있습니다.", presentationUrl: nil),
//						  SeminarDetailPreview(presentationIdx: 0, title: "swift에 대해 알아보자", nickname: "팀 쿡", profileImgUrl: "ExProfileImage", organization: "apple", content: "swift는 apple에서 개발한 언어로 아주 좋습니다.", presentationUrl: nil),
//						  SeminarDetailPreview(presentationIdx: 0, title: "가천대학교에 대해 알아보자", nickname: "이길여", profileImgUrl: "ExProfileImage", organization: "가천대학교", content: "가천대학교는 경기도 성남시에 위치한 명문대입니다.", presentationUrl: nil)
//		]
//		completion(dummyData)
		let url = "\(Constants.apiUrl)/seminars/\(seminarId)/presentations"
		AF.request(url, method: .get , interceptor: MyRequestInterceptor())
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
