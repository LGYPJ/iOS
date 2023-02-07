//
//  HomeNotificationVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit
import SnapKit

class HomeNotificationVC: UIViewController {

    let dataList = HomeNotificationDataModel.list
    let memberIdx = Int(UserDefaults.standard.string(forKey: "memberIdx")!)!
    public var notificationList: [NotificationInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Subviews
    
    // tableView cell 선택 시 gray컬러로 변하지 않게 설정
    lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var notificationViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor(hex: 0x000000,alpha: 0.8)
        button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .systemBackground
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
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // notificationViewButton
        notificationViewButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
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
        
        // NotificationInfoResponse를 불러옴
        NotificationViewModel.getNotificationsByMemberIdx(memberIdx: memberIdx) { [weak self] result in
            self?.notificationList = result.filter{!$0.isRead}
        }
    }
    
}


extension HomeNotificationVC {
    
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeNotificationTableViewCell.self, forCellReuseIdentifier: HomeNotificationTableViewCell.identifier)
    }
    
}

extension HomeNotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeNotificationTableViewCell.identifier, for: indexPath) as? HomeNotificationTableViewCell else {return UITableViewCell()}
        cell.selectedBackgroundView = background
        cell.configure(notificationList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 읽음처리
        // notificationList[indexPath.row]에서 isRead만 true로 post 해줘야함
        
        /// log
        print("content: \(notificationList[indexPath.row].content)")
        print("resourceIdx: \(notificationList[indexPath.row].resourceIdx)")
        
        let resourceIdx = notificationList[indexPath.row].resourceIdx
        let resourceType = notificationList[indexPath.row].resourceType
        
        // 홈으로 pop후
        self.navigationController?.popViewController(animated: true)
        // 해당 되는 view로 push
        switch resourceType {
        case "SEMINAR":
            self.navigationController?.pushViewController(EventSeminarDetailVC(seminarId: resourceIdx), animated: true)
        case "NETWORKING":
            self.navigationController?.pushViewController(EventNetworkingDetailVC(networkingId: resourceIdx), animated: true)
        default:
            print(">>>ERROR: HomeNotificationVC didselectRowAt resourceType")
        }

    }
}

