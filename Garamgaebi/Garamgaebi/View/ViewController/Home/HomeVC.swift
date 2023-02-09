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
    
    public var homeSeminarInfo: [HomeSeminarInfo] = [] {
        didSet {
            // notification -> Cell
            NotificationCenter.default.post(name: Notification.Name("presentHomeSeminarInfo"), object: homeSeminarInfo)
            self.tableView.reloadData()
        }
    }
    
    public var homeNetworkingInfo: [HomeNetworkingInfo] = [] {
        didSet {
            // notification -> Cell
            NotificationCenter.default.post(name: Notification.Name("presentHomeNetworkingInfo"), object: homeNetworkingInfo)
            self.tableView.reloadData()
        }
    }
    
    public var recommendUsersInfo: [RecommendUsersInfo] = [] {
        didSet {
            // notification -> Cell
            NotificationCenter.default.post(name: Notification.Name("presentRecommendUsersInfo"), object: recommendUsersInfo)
            self.tableView.reloadData()
        }
    }
    
    public var myEventInfo: [MyEventInfoReady] = [] {
        didSet {
            // notification -> Cell
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        fetchData()
    }
    
    
    
    // MARK: - Functions
    
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
    private func fetchData() {
        
        // 세미나 정보 API
        HomeViewModel.getHomeSeminarInfo { [weak self] result in
            self?.homeSeminarInfo = result
        }
        // 네트워킹 정보 API
        HomeViewModel.getHomeNetworkingInfo { [weak self] result in
            self?.homeNetworkingInfo = result
        }
        // 가람개비 유저 10명 추천 API
        HomeViewModel.getRecommendUsersInfo { [weak self] result in
            self?.recommendUsersInfo = result
        }
        // 내 모임 정보 API
        HomeViewModel.getHomeMyEventInfo(memberId: memberIdx) { [weak self] result in
            self?.myEventInfo = result
        }
        // 읽지 않은 알림 여부 API
        NotificationViewModel.getIsUnreadNotifications(memberIdx: memberIdx) { [weak self] result in
            if result.isUnreadExist {
                self?.notificationViewButton.setImage(UIImage(named: "NotificationUnreadIcon"), for: .normal)
            } else {
                self?.notificationViewButton.setImage(UIImage(named: "NotificationIcon"), for: .normal)
            }
        }
    }
    
    func configNotificationCenter() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDatas), name: Notification.Name("HomeTableViewReload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushSeminarDetail(_:)), name: Notification.Name("pushSeminarDetailVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushNetworkingDetail(_:)), name: Notification.Name("pushNetworkingDetailVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postScrollDirection), name: Notification.Name("getScrollDirection"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postOtherProfileMemberIdx(_:)), name: Notification.Name("postOtherProfileMemberIdx"), object: nil)
        
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
    
    
}


extension HomeVC {
    
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
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
            return HomeEventInfoTableViewCell.cellHeight + 16.0
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

