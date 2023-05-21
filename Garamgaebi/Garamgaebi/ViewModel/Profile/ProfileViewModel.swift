//
//  ProfileViewModel.swift
//  Garamgaebi
//
//  Created by 서은수 on 2023/05/13.
//

import Combine

class ProfileViewModel {
    
    enum Input {
        case viewWillAppear(memberIdx: Int)
    }
    
    enum Output {
        // 내 프로필 정보 불러오는 데에 실패했을 때 내보내는 아웃풋
        case fetchMyProfileDidFail(error: Error)
        // 성공 시 내보내는 아웃풋
        case fetchMyProfileDidSucceed(profileRes: ProfileResponse)
    }
    
    private let profileServiceType: ProfileServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(profileServiceType: ProfileServiceType = ProfileService()) {
        self.profileServiceType = profileServiceType
    }
    
    // to transform an input to an output
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .viewWillAppear(let memberIdx):
                self.handleGetMyProfile(memberIdx)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func handleGetMyProfile(_ memberIdx: Int) {
        profileServiceType.getMyProfile(memberIdx: memberIdx).sink { completion in
            if case .failure(let error) = completion {
                self.output.send(.fetchMyProfileDidFail(error: error))
            }
        } receiveValue: { profileRes in
            self.output.send(.fetchMyProfileDidSucceed(profileRes: profileRes))
        }.store(in: &cancellables)
    }
}
