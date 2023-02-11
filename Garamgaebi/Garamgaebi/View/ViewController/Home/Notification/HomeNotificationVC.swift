//
//  HomeNotificationVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit
import SnapKit

class HomeNotificationVC: UIViewController {

    let memberIdx = UserDefaults.standard.integer(forKey: "memberIdx")
    var lastNotificationIdx: Int? = nil
    var hasNext = true
    var currentPage = 0
    
    public var notificationList: [NotificationDetailInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // UIRefreshControl
    let refresh = UIRefreshControl()
    
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
        
        initRefresh()
        configureViews()
        configureTableView()
        addSubViews()
        configLayouts()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        fetchData(lastNotiIdx: self.lastNotificationIdx, hasNext: self.hasNext)
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
 
    private func fetchData(lastNotiIdx: Int?, hasNext: Bool?) {
        // NotificationInfoResponse를 불러옴
        if hasNext != false {
            NotificationViewModel.getNotificationsByMemberIdx(memberIdx: memberIdx, lastNotificationIdx: lastNotiIdx) { [weak self] result in
                if lastNotiIdx == nil {
                    self?.notificationList = result.result!
                } else {
                    self?.notificationList.append(contentsOf: result.result!)
                }
                
                let notiCounts = self?.notificationList.count
                if notiCounts == 0 {
                    self?.lastNotificationIdx = nil
                } else {
                    self?.lastNotificationIdx = self?.notificationList[(notiCounts!) - 1].notificationIdx
                }
                
                self?.hasNext = result.hasNext
            }
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
extension HomeNotificationVC {
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        self.tableView.refreshControl = refresh
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        print(">>>upRefresh")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.notificationList.removeAll()
            self?.fetchData(lastNotiIdx: nil, hasNext: true)
            self?.tableView.reloadData()
            refresh.endRefreshing()
        }
        
    }
    
    //MARK: - UIRefreshControl of ScrollView
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let currentOffset = scrollView.contentOffset.y  // frame영역의 origin에 비교했을때의 content view의 현재 origin 위치
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height // 화면에는 frame만큼 가득 찰 수 있기때문에 frame의 height를 빼준 것
        
        // 스크롤 할 수 있는 영역보다 더 스크롤된 경우 (하단에서 스크롤이 더 된 경우)
        if maximumOffset < currentOffset {
            print(">>>DownRefresh")
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                self?.fetchData(lastNotiIdx: self?.lastNotificationIdx, hasNext: self?.hasNext)
                self?.tableView.reloadData()
            }
        }
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
        cell.prepareForReuse()
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

