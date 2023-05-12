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
		case nameTextFieldEditingChanged(name: String)
		case nicknameTextFieldEditingChanged(nickname: String)
		case numberTextFieldEditingChanged(number: String)
		case applyButtonDidTap(name: String, nickname: String, number: String)
	}
	
	enum Output {
		case getProgramDataDidSucceed(data: ProgramDetailInfoResponse)
		case getProgramDataDidFail(error: Error)
		case isValidName(result: Bool)
		case isValidNickname(result: Bool)
		case isValidNumber(result: Bool)
		case postProgramApplyDidSucceed(result: EventApplyModel)
		case postProgramApplyDidFail(error: Error)
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
	
	deinit {
		cancelBag.forEach {$0.cancel()}
		cancelBag.removeAll()
	}
	
	// input -> output 변환
	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { event in
			switch event {
			case .viewDidLoad(let type, let programId):
				self.programId = programId
				self.getProgramData(type: type, programId: programId)
				
			case .nameTextFieldEditingChanged(let name):
				let result = self.isValidName(name: name)
				self.output.send(.isValidName(result: result))
				
			case .nicknameTextFieldEditingChanged(let nickname):
				let result = self.isValidNickname(nickname: nickname)
				self.output.send(.isValidNickname(result: result))
				
			case .numberTextFieldEditingChanged(let number):
				let result = self.isValidNumber(number: number)
				self.output.send(.isValidNumber(result: result))
				
			case .applyButtonDidTap(let name, let nickname, let number):
				self.postApply(name: name, nickname: nickname, phone: number)
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
	
	private func isValidName(name: String) -> Bool {
		let nameRegEx =  "[가-힣A-Za-z]{1,20}"
		let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
		let result = nameTest.evaluate(with: name)
		
		return result
	}
	
	private func isValidNickname(nickname: String) -> Bool {
		return nickname == UserDefaults.standard.string(forKey: "nickname")
	}
	
	private func isValidNumber(number: String) -> Bool {
		let numberRegEx = "[0-9]{11}"
		let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
		let result = numberTest.evaluate(with: number)
		
		return result
	}
}
