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
    
    var pushProgramIdx: Int?
    var pushProgramtype: String?
    init(pushProgramIdx: Int?, pushProgramtype: String?) {
        self.pushProgramIdx = pushProgramIdx
        self.pushProgramtype = pushProgramtype
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var homeSeminarInfo: [HomeSeminarInfo] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("presentHomeSeminarInfo"), object: homeSeminarInfo)
        }
    }
    
    public var homeNetworkingInfo: [HomeNetworkingInfo] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("presentHomeNetworkingInfo"), object: homeNetworkingInfo)
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
        }
    }
    
    public var myEventInfo: [MyEventInfoReady] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("presentMyEventInfo"), object: myEventInfo)
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
        print("################TOKEN")
        print("#")
        print("#")
        print(">>> HomeVC - accessToken: \(UserDefaults.standard.string(forKey: "BearerToken"))")
        print(">>> HomeVC - refreshToken: \(UserDefaults.standard.string(forKey: "refreshToken"))")
        print(">>> HomeVC - fcmToken: \(UserDefaults.standard.string(forKey: "fcmToken"))")
        print("#")
        print("#")
        print("################TOKEN")
        if self.pushProgramtype != nil,
           self.pushProgramIdx != nil {
            if pushProgramtype == "SEMINAR" {
				let vc = EventSeminarDetailVC(seminarId: pushProgramIdx!)
				vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if pushProgramtype == "NETWORKING" {
				let vc = EventNetworkingDetailVC(networkingId: pushProgramIdx!)
				vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        configureViews()
        configureTableView()
        addSubViews()
        configLayouts()
        configNotificationCenter()
        initRefresh()
        initSetDatas()
        LoadingView.shared.show()
        DispatchQueue.main.async {
            self.fetchData {
                if self.setSeminarData,
                    self.setNetworkingData,
                    self.setNotificationData,
                    self.setMyEventData,
                    self.setRecommendedUserData {
                    LoadingView.shared.hide()
                }
            }
        }
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
                    if let result = result.result {
                        self?.homeSeminarInfo = result
                    } else {
                        self?.homeSeminarInfo = []
                    }
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
                self?.refresh.endRefreshing()
                self?.presentErrorView()
            }
        }
        
        // 네트워킹 정보 API
        HomeViewModel.getHomeNetworkingInfo { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    if let result = result.result {
                        self?.homeNetworkingInfo = result
                    } else {
                        self?.homeNetworkingInfo = []
                    }
                    self?.setNetworkingData = true
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
                self?.refresh.endRefreshing()
                self?.presentErrorView()
            }
        }
        
        // 가람개비 유저 10명 추천 API
        HomeViewModel.getRecommendUsersInfo { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    if let result = result.result {
                        self?.recommendUsersInfo = result
                    } else {
                        self?.recommendUsersInfo = []
                    }
                    self?.setRecommendedUserData = true
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
                self?.refresh.endRefreshing()
                self?.presentErrorView()
            }
        }
        // 내 모임 정보 API
        HomeViewModel.getHomeMyEventInfo(memberId: self.memberIdx) { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    if let result = result.result {
                        self?.myEventInfo = result
                    } else {
                        self?.myEventInfo = []
                    }
                    self?.setMyEventData = true
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
                self?.refresh.endRefreshing()
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
                self?.refresh.endRefreshing()
                self?.presentErrorView()
            }
            
        }
        
    }
    
    func presentErrorView(){
        let errorView = ErrorPageView()
        errorView.modalPresentationStyle = .fullScreen
		errorView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(errorView, animated: false)
    }
    
    func configNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDatas), name: Notification.Name("HomeTableViewReload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushSeminarDetail(_:)), name: Notification.Name("pushSeminarDetailVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushNetworkingDetail(_:)), name: Notification.Name("pushNetworkingDetailVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postScrollDirection), name: Notification.Name("getScrollDirection"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postOtherProfileMemberIdx(_:)), name: Notification.Name("postOtherProfileMemberIdx"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushEventPopUpView(_:)), name: Notification.Name("pushEventPopUpView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshByNotification), name: Notification.Name("ReloadMyEvent"), object: nil)
    }

    @objc private func pushNextView(_ sender: UIButton) {
        switch sender {
        case notificationViewButton:
			let vc = HomeNotificationVC()
			vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("error")
        }
    }
    
    @objc func pushSeminarDetail(_ notification: NSNotification) {
        let detailInfo: MyEventToDetailInfo = notification.object as! MyEventToDetailInfo
		let vc = EventSeminarDetailVC(seminarId: detailInfo.programIdx)
		vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        print("seminarId: \(detailInfo.programIdx)")
    }
    
    @objc func pushNetworkingDetail(_ notification: NSNotification) {
        let detailInfo: MyEventToDetailInfo = notification.object as! MyEventToDetailInfo
		let vc = EventNetworkingDetailVC(networkingId: detailInfo.programIdx)
		vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func postOtherProfileMemberIdx(_ notification: NSNotification) {
        let otherMemberIdx: Int = notification.object as! Int
		let vc = OtherProfileVC(memberIdx: otherMemberIdx)
		vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
	
	@objc func refreshByNotification() {
		self.fetchData {}
		
	}
    
}

