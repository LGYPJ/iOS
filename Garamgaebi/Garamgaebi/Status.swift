//
//  Status.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/03.
//

import Foundation

enum ProgramUserButtonStatus: String, Decodable {
	case APPLY  //신청 하기
	case CANCEL // 신청 취소 하기
	case BEFORE_APPLY_CONFIRM // 신청 확인 중
	case APPLY_COMPLETE // 신청완료
	case CLOSED // 마감
	case ERROR
	
}

//enum ProgramStatus: String, Decodable {
//	case OPEN  // 오픈
//	case READY_TO_OPEN  // 오픈 예정
//	case CLOSED // 마감
//	case CLOSED_CONFIRM // 마감 확인(환불 처리 완료)
//}
