//
//  EventApplyCancelViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/30.
//

import Alamofire
import Combine

class EventApplyCancelViewModel {
	enum Input {
		case viewDidLoad(type: ProgramType, programId: Int)
		case applyCancelButtondidTap(bank: String, account: String)
	}
	
	enum Output {
		case getProgramDataDidSucceed(data: ProgramDetailInfoResponse)
		case getProgramDataDidFail(error: Error)
		case getUserApplyDataDidSucceed(data: EventUserApplyModelResponse)
		case getUserApplyDataDidFail(error: Error)
		case postProgramApplyCancelDidSucceed(result: EventApplyModel)
		case postProgramApplyCancelDidFail(error: Error)
	}
	
	// DI
	private let eventApplyCancelServiceType: EventApplyCancelServiceType
	private let programDetailServiceType: ProgramDetailServiceType
	private let output = PassthroughSubject<Output, Never>()
	private var cancelBag = Set<AnyCancellable>()
	
	private let memberId: Int
	private var programId: Int = -1
	
	init(
		eventApplyCancelServiceType: EventApplyCancelServiceType = EventApplyCancelService(),
		programDetailServiceType: ProgramDetailServiceType =  ProgramDetailService()
	) {
		self.eventApplyCancelServiceType = eventApplyCancelServiceType
		self.programDetailServiceType = programDetailServiceType
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
	}
	
	deinit {
		cancelBag.forEach {$0.cancel()}
		cancelBag.removeAll()
	}
	
	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { event in
			switch event {
			case .viewDidLoad(let type, let programId):
				self.programId = programId
				self.getProgramData(type: type, programId: programId)
				self.getUserData(programId: programId)
				
			case .applyCancelButtondidTap(let bank, let account):
				self.postApplyCancel(bank: bank, account: account)
			}
		}
		.store(in: &cancelBag)
		
		return output.eraseToAnyPublisher()
	}
	
	private func getProgramData(type: ProgramType, programId: Int) {
		programDetailServiceType.getProgramDetailInfo(type: type, memberId: self.memberId, programId: programId)
			.sink(receiveCompletion: { completion in
				if case .failure(let error) = completion {
					self.output.send(.getProgramDataDidFail(error: error))
				}
			}, receiveValue: { result in
				self.output.send(.getProgramDataDidSucceed(data: result))
			})
			.store(in: &cancelBag)
	}
	
	private func getUserData(programId: Int) {
		eventApplyCancelServiceType.getUserApplyData(memberId: self.memberId, programId: programId)
			.sink(receiveCompletion: { completion in
				if case .failure(let error) = completion {
					self.output.send(.getUserApplyDataDidFail(error: error))
				}
			}, receiveValue: { result in
				self.output.send(.getUserApplyDataDidSucceed(data: result))
			})
			.store(in: &cancelBag)
	}
	
	private func postApplyCancel(bank: String, account: String) {
		eventApplyCancelServiceType.postApplyCancelProgram(memberId: self.memberId, programId: self.programId, bank: bank, account: account)
			.sink { completion in
				if case .failure(let error) = completion {
					self.output.send(.postProgramApplyCancelDidFail(error: error))
				}
			} receiveValue: { result in
				self.output.send(.postProgramApplyCancelDidSucceed(result: result))
			}
			.store(in: &cancelBag)
	}
}
