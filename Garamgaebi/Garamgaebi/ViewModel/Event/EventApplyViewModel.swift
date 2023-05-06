//
//  EventApplyViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/31.
//

import Alamofire
import Combine

class EventApplyViewModel {
	enum Input {
		case viewDidLoad(type: ProgramType, programId: Int)
		case backButtonDidTap
		// 각 텍스트필드 클릭 시 수행할 내용 추가?
		case applyButtonDidTap(name: String, nickname: String, number: String)
	}
	
	enum Output {
		case getProgramDataDidSucceed(data: ProgramDetailInfoResponse)
		case getProgramDataDidFail(error: Error)
		case postProgramApplyDidSucceed(result: EventApplyModel)
		case postProgramApplyDidFail(error: Error)
		case popVC
	}
	
	// DI
	private let eventApplyServiceType: EventApplyServiceType
	private let programDetailServiceType: ProgramDetailServiceType
	private let output = PassthroughSubject<Output, Never>()
	private var cancelBag = Set<AnyCancellable>()
	
	private let memberId: Int
	private var programId: Int = -1
	
	init(eventApplyServiceType: EventApplyServiceType = EventApplyService(), programDetailServiceType: ProgramDetailServiceType = ProgramDetailService()) {
		self.eventApplyServiceType = eventApplyServiceType
		self.programDetailServiceType = programDetailServiceType
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
	}
	
	// input -> output 변환
	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .viewDidLoad(let type, let programId):
				self?.programId = programId
				self?.getProgramData(type: type, programId: programId)
				
			case .backButtonDidTap:
				self?.output.send(.popVC)
				
			case .applyButtonDidTap(let name, let nickname, let number):
				self?.postApply(name: name, nickname: nickname, phone: number)
			}
		}
		.store(in: &cancelBag)
		
		
		return output.eraseToAnyPublisher()
	}
	
	private func getProgramData(type: ProgramType, programId: Int) {
		programDetailServiceType.getProgramDetailInfo(type: type, memberId: self.memberId, programId: self.programId)
			.sink(receiveCompletion: { [weak self] completion in
				if case .failure(let error) = completion {
					self?.output.send(.getProgramDataDidFail(error: error))
				}
			}, receiveValue: {[weak self] result in
				self?.output.send(.getProgramDataDidSucceed(data: result))
			})
			.store(in: &cancelBag)
	}
	
	private func postApply(name: String, nickname: String, phone: String) {
		eventApplyServiceType.postApplyProgram(memberId: self.memberId, programId: self.programId, name: name, nickname: nickname, phone: phone)
			.sink { [weak self] completion in
				if case .failure(let error) = completion {
					self?.output.send(.postProgramApplyDidFail(error: error))
				}
			} receiveValue: {[weak self] result in
				self?.output.send(.postProgramApplyDidSucceed(result: result))
			}
			.store(in: &cancelBag)
	}
}
