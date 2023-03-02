//
//  HomeVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit
import Then
import SnapKit

class HomeVC: UIViewController {
    
    // MARK: - Variable
    let memberIdx = UserDefaults.standard.integer(forKey: "memberIdx")
    
    // UIRefreshControl
    let refresh = UIRefreshControl()
    
    var setSeminarData = false
    var setNetworkingData = false
    var setRecommendedUserData = false
    var setMyEventData = false
    var setNotificationData = false
    
    public var homeSeminarInfo: [HomeSeminarInfo] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("presentHomeSeminarInfo"), object: homeSeminarInfo)
            self.tableView.reloadData()
        }
    }
    
    public var homeNetworkingInfo: [HomeNetworkingInfo] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("presentHomeNetworkingInfo"), object: homeNetworkingInfo)
            self.tableView.reloadData()
        }
    }
    
    public var recommendUsersInfo: [RecommendUsersInfo] = [] {
        didSet {
            // 본인 필터링
            var usersInfo = recommendUsersInfo.filter{$0.memberIdx != memberIdx}
            // 11명이면 1명 제외
            if usersInfo.count == 11 {
                usersInfo.remove(at: 0)
            }
            // 셔플해서 전달
            NotificationCenter.default.post(name: Notification.Name("presentRecommendUsersInfo"), object: usersInfo.shuffled())
            self.tableView.reloadData()
        }
    }
    
    public var myEventInfo: [MyEventInfoReady] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("presentMyEventInfo"), object: myEventInfo)
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Subviews
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 24)
        return label
    }()
    
    lazy var notificationViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NotificationIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(pushNextView), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        return view
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureTableView()
        addSubViews()
        configLayouts()
        configNotificationCenter()
        initRefresh()
        initSetDatas()
        LoadingView.shared.show()
        fetchData {
            if self.setSeminarData,
                self.setNetworkingData,
                self.setNotificationData,
                self.setMyEventData,
                self.setRecommendedUserData {
                LoadingView.shared.hide()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Functions
    
    func initSetDatas(){
        self.setSeminarData = false
        self.setNetworkingData = false
        self.setNotificationData = false
        self.setMyEventData = false
        self.setRecommendedUserData = false
    }
    
    func addSubViews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(notificationViewButton)
        view.addSubview(tableView)
    }
    
    func configLayouts() {
        //headerView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // notificationViewButton
        notificationViewButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
            
        // tableView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    private func fetchData(completion: @escaping (() -> Void)) {
        // 세미나 정보 API
        HomeViewModel.getHomeSeminarInfo { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.homeSeminarInfo = result
                    self?.setSeminarData = true
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-홈 화면 Seminar 조회): \(error.localizedDescription)")
                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        
        // 네트워킹 정보 API
        HomeViewModel.getHomeNetworkingInfo { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.setNetworkingData = true
                    self?.homeNetworkingInfo = result
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-홈 화면 Networking 조회): \(error.localizedDescription)")
                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        
        // 가람개비 유저 10명 추천 API
        HomeViewModel.getRecommendUsersInfo { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.setRecommendedUserData = true
                    self?.recommendUsersInfo = result
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-홈 화면 RecommedUsers 조회): \(error.localizedDescription)")
                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        // 내 모임 정보 API
        HomeViewModel.getHomeMyEventInfo(memberId: self.memberIdx) { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.setMyEventData = true
                    self?.myEventInfo = result
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-홈 화면 MyEvent 조회): \(error.localizedDescription)")
                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        // 읽지 않은 알림 여부 API
        NotificationViewModel.getIsUnreadNotifications(memberIdx: self.memberIdx) { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.setNotificationData = true
                    if result.isUnreadExist {
                        self?.notificationViewButton.setImage(UIImage(named: "NotificationUnreadIcon"), for: .normal)
                    } else {
                        self?.notificationViewButton.setImage(UIImage(named: "NotificationIcon"), for: .normal)
                    }
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-Unread Notification 조회): \(error.localizedDescription)")
                LoadingView.shared.hide()
                self?.presentErrorView()
            }
            
        }
        
    }
    
    func presentErrorView(){
        let errorView = ErrorPageView()
        errorView.modalPresentationStyle = .fullScreen
        self.present(errorView, animated: false)
    }
    
    func configNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDatas), name: Notification.Name("HomeTableViewReload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushSeminarDetail(_:)), name: Notification.Name("pushSeminarDetailVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushNetworkingDetail(_:)), name: Notification.Name("pushNetworkingDetailVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postScrollDirection), name: Notification.Name("getScrollDirection"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postOtherProfileMemberIdx(_:)), name: Notification.Name("postOtherProfileMemberIdx"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushEventPopUpView(_:)), name: Notification.Name("pushEventPopUpView"), object: nil)
    }

    @objc private func pushNextView(_ sender: UIButton) {
        switch sender {
        case notificationViewButton:
            self.navigationController?.pushViewController(HomeNotificationVC(), animated: true)
        default:
            print("error")
        }
    }
    
    @objc func pushSeminarDetail(_ notification: NSNotification) {
        let detailInfo: MyEventToDetailInfo = notification.object as! MyEventToDetailInfo
        self.navigationController?.pushViewController(EventSeminarDetailVC(seminarId: detailInfo.programIdx), animated: true)
        print("seminarId: \(detailInfo.programIdx)")
    }
    
    @objc func pushNetworkingDetail(_ notification: NSNotification) {
        let detailInfo: MyEventToDetailInfo = notification.object as! MyEventToDetailInfo
        self.navigationController?.pushViewController(EventNetworkingDetailVC(networkingId: detailInfo.programIdx), animated: true)
    }
    
    @objc func postOtherProfileMemberIdx(_ notification: NSNotification) {
        let otherMemberIdx: Int = notification.object as! Int
        self.navigationController?.pushViewController(OtherProfileVC(memberIdx: otherMemberIdx), animated: true)
    }
    
    @objc func reloadDatas() {
        tableView.reloadData()
    }
    
    @objc private func postScrollDirection() {
        NotificationCenter.default.post(name: Notification.Name("postScrollDirection"), object: tableView.contentOffset.y)
    }
    
    @objc func pushEventPopUpView(_ notification: NSNotification) {
        let popUpVC: UIViewController = notification.object as! UIViewController
        popUpVC.modalPresentationStyle = .overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        present(popUpVC, animated: true)
    }
}


extension HomeVC {
    
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeEventInfoTableViewCell.self, forCellReuseIdentifier: HomeEventInfoTableViewCell.identifier)
        tableView.register(RecommendUsersInfoTableViewCell.self, forCellReuseIdentifier: RecommendUsersInfoTableViewCell.identifier)
        tableView.register(HomeMyEventInfoTableViewCell.self, forCellReuseIdentifier: HomeMyEventInfoTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return HomeEventInfoTableViewCell.cellHeight + 8.0
        case 1:
            return RecommendUsersInfoTableViewCell.cellHeight + 8.0
        case 2:
            return HomeMyEventInfoTableViewCell.cellHeight
        default:
            return view.frame.height
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeEventInfoTableViewCell.identifier, for: indexPath) as? HomeEventInfoTableViewCell else {return UITableViewCell()}
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendUsersInfoTableViewCell.identifier, for: indexPath) as? RecommendUsersInfoTableViewCell else {return UITableViewCell()}
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMyEventInfoTableViewCell.identifier, for: indexPath) as? HomeMyEventInfoTableViewCell else {return UITableViewCell()}
            return cell
        default:
            return UITableViewCell()
            
        }
    }
}

extension HomeVC {
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        self.tableView.refreshControl = refresh
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        
        initSetDatas()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchData {
                if self.setSeminarData,
                    self.setNetworkingData,
                    self.setNotificationData,
                    self.setMyEventData,
                    self.setRecommendedUserData {
                    refresh.endRefreshing()
                }
            }
        }
        
    }
    
}

