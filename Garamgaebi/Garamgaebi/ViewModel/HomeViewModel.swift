//
//  HomeViewModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/24.
//

import Alamofire
import Combine
// 홈 화면 ViewModel
class HomeViewModel {
    
    public var recommendUsersData: [RecommendUsersInfo] = [RecommendUsersInfo(memberIdx: 0, nickName: "", profileUrl: "", belong: "")]
    public var homeMyEventData: [MyEventInfoReady] = [MyEventInfoReady(programIdx: 0, title: "", date: "", location: "", type: "", payment: "", status: "", isOpen: "")]
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case setRecommendUsersInfo
        case failedRecommendUsersInfo
        case setHomeMyEventInfo
        case failHomeMyEventInfo
    }
    
    let output = PassthroughSubject<Output,Never>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                print(">>> Transform viewdidload")
                self?.fetchRecommendUsersInfo()
                self?.fetchHomeMyEventInfo()
                // 세미나
                // 네트워킹
                // 알림 조회
                // 총 5개
            }
        }
        .store(in: &subscriptions)
        return output.eraseToAnyPublisher()
        
    }
    
    // Data => Output
    
    // User Action => Input
//    func fetchNotificationData() {
//        let response = NotificationViewModel.getIsUnreadNotifications(memberIdx: self.memberIdx)
//            .sink { [weak self] response in
//                switch response {
//                case .success(let result):
//                    if result.isSuccess {
//                        guard let result = result.result else { return }
//                        self?.setNotificationData.value = true
//                        if result.isUnreadExist {
//                            // TODO: 버튼 UI 변경 연동해야함
//                            //self?.notificationViewButton.setImage(UIImage(named: "NotificationUnreadIcon"), for: .normal)
//                        } else {
//                            //self?.notificationViewButton.setImage(UIImage(named: "NotificationIcon"), for: .normal)
//                        }
//
//                    } else {
//                        // TODO: 뭐든 에러가 있을거임
//                        //애니메이션 끄고 에러핸들링
//                        //LoadingView.shared.hide()
//                    }
//                case .failure(let error):
//                    // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
//                    print("실패(AF-Unread Notification 조회): \(error.localizedDescription)")
//                    LoadingView.shared.hide()
//                    //self?.refresh.endRefreshing()
//                    //self?.presentErrorView()
//                }
//            }
//            .store(in: &subscriptions)
//    }
    
    func fetchRecommendUsersInfo() {
        HomeViewModel.getRecommendUsersInfo()
            .sink { [weak self] result in
                switch result {
                case .success(let result):
                    if result.isSuccess {
                        if let result = result.result {
                            self?.recommendUsersData = result
                            self?.shuffleRecommendUsersInfo()
                            self?.output.send(.setRecommendUsersInfo)
                        } else {
                            self?.recommendUsersData = []
                            self?.output.send(.failedRecommendUsersInfo)
                        }
                        //self?.setRecommendedUserData = true
                    } else {
                        // TODO: 뭐든 에러가 있을거임
                        //애니메이션 끄고 에러핸들링
                        //LoadingView.shared.hide()
                    }
                case .failure(let error):
                    // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                    print("실패(AF-홈 화면 RecommedUsers 조회): \(error.localizedDescription)")
                    LoadingView.shared.hide()
                    //self?.refresh.endRefreshing()
                    //self?.presentErrorView()
                }
            }
            .store(in: &subscriptions)
    }
    
    func fetchHomeMyEventInfo() {
        HomeViewModel.getHomeMyEventInfo(memberId: memberIdx)
            .sink { [weak self] result in
                switch result {
                case .success(let result):
                    if result.isSuccess {
                        if let result = result.result {
                            self?.homeMyEventData = result
                            self?.output.send(.setHomeMyEventInfo)
                        } else {
                            self?.homeMyEventData = []
                            self?.output.send(.failHomeMyEventInfo)
                        }
                    } else {
                        // TODO: 뭐든 에러가 있을거임
                        //애니메이션 끄고 에러핸들링
                        //LoadingView.shared.hide()
                    }
                case .failure(let error):
                    // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                    print("실패(AF-홈 화면 MyEvent 조회): \(error.localizedDescription)")
                    LoadingView.shared.hide()
                    //self?.refresh.endRefreshing()
                    //self?.presentErrorView()
                }
            }
            .store(in: &subscriptions)
    }
    
    
    // Properties
    
    // Input
        // SeminarData
        // NetworkingData
        // MyEventData
        // RecommendedUserData => DataList => 이거만 트라이 해보자
        // NotificationData => 있는지 없는지 여부만 => Bool
    var setNotificationData = CurrentValueSubject<Bool, Never>(false)
    var recommendUsersInfo = PassthroughSubject<Output, Never>()
    private let memberIdx = UserDefaults.standard.integer(forKey: "memberIdx")
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Request [Seminar]
    public static func getHomeSeminarInfo(completion: @escaping ((Result<HomeSeminarInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/seminars/main"
		AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: HomeSeminarInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        completion(response.result)
                        print("실패(홈 화면 Seminar 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 ex)404
                    completion(response.result)
                    print("실패(AF-홈 화면 Seminar 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Request [Networking]
    public static func getHomeNetworkingInfo(completion: @escaping ((Result<HomeNetworkingInfoResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/networkings/main"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: HomeNetworkingInfoResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 Networking 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 Networking 조회): \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Request [가람개비 유저]
//    public static func getRecommendUsersInfo(completion: @escaping ((Result<RecommendUsersInfoResponse, AFError>) -> Void)) {
//        let url = "\(Constants.apiUrl)/profile/profiles"
//        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
//            .validate()
//            .responseDecodable(of: RecommendUsersInfoResponse.self) { response in
//                switch response.result {
//                case .success(let result):
//                    if result.isSuccess {
//                        completion(response.result)
//                    } else {
//                        // 통신은 정상적으로 됐으나(200), error발생
//                        print("실패(홈 화면 RecommedUsers 조회): \(result.message)")
//                    }
//                case .failure(let error):
//                    // 실제 HTTP에러 404
//                    print("실패(AF-홈 화면 RecommedUsers 조회): \(error.localizedDescription)")
//                }
//            }
//    }
    
    // Service
    public static func getRecommendUsersInfo() -> AnyPublisher<Result<RecommendUsersInfoResponse, AFError>, Never> {
        let url = "\(Constants.apiUrl)/profile/profiles"
        return AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .publishDecodable(type: RecommendUsersInfoResponse.self)
            .result()
            .eraseToAnyPublisher()
    }
    
    
    public static func getHomeMyEventInfo(memberId: Int) -> AnyPublisher<Result<MyEventInfoReadyResponse, AFError>, Never> {
        let url = "\(Constants.apiUrl)/programs/\(memberId)/ready"
        return AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .publishDecodable(type: MyEventInfoReadyResponse.self)
            .result()
            .eraseToAnyPublisher()
    }
    
    // MARK: Request [내 모임]
    public static func getHomeMyEventInfo(memberId: Int, completion: @escaping ((Result<MyEventInfoReadyResponse, AFError>) -> Void)) {
        let url = "\(Constants.apiUrl)/programs/\(memberId)/ready"
        AF.request(url, method: .get, interceptor: MyRequestInterceptor())
            .validate()
            .responseDecodable(of: MyEventInfoReadyResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        completion(response.result)
                    } else {
                        // 통신은 정상적으로 됐으나(200), error발생
                        print("실패(홈 화면 MyEvent 조회): \(result.message)")
                    }
                case .failure(let error):
                    // 실제 HTTP에러 404
                    print("실패(AF-홈 화면 MyEvent 조회): \(error.localizedDescription)")
                }
            }
    }
    
    private func shuffleRecommendUsersInfo() {
        var usersInfo = recommendUsersData.filter{$0.memberIdx != memberIdx}
        // 11명이면 1명 제외
        if usersInfo.count == 11 {
            usersInfo.remove(at: 0)
        }
        recommendUsersData = usersInfo
    }
}
