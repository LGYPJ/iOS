//
//  ViewAllNetworkingVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/17.
//

import UIKit

class ViewAllNetworkingVC: UIViewController {
    
    // UIRefreshControl
    let refresh = UIRefreshControl()
    
    var setThisMonthData = false
    var setNextMonthData = false
    var setCloseData = false
    
    private let sections: [String] = ["이번 달 네트워킹", "예정된 네트워킹", "마감된 네트워킹"]
    private var thisMonthInfoList: [NetworkingThisMonthInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var nextMonthInfoList: [NetworkingReadyInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var closeInfoList: [NetworkingClosedInfo] = [] {
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
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.separatorStyle = .none
        view.bounces = true
        view.clipsToBounds = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureTableView()
        addSubViews()
        configLayouts()
        initRefresh()
        initSetDatas()
//        LoadingView.shared.show()
        fetchData {
            if self.setThisMonthData,
               self.setNextMonthData,
               self.setCloseData {
//                LoadingView.shared.hide()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Functions
    
    func addSubViews() {
        view.addSubview(tableView)
    }
    
    func configLayouts() {
        // tableView
        tableView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
    }
    
    func fetchData(completion: @escaping (() -> Void)){
        // SeminarThisMonthInfo의 data를 불러옴
        ViewAllViewModel.getNetworkingThisMonthInfo  { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.thisMonthInfoList = [result]
                    self?.setThisMonthData = true
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-모아보기 화면 이번 달 Networking 조회): \(error.localizedDescription)")
//                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        
        // SeminarNextMonthInfo의 data를 불러옴
        ViewAllViewModel.getNetworkingNextMonthInfo  { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.nextMonthInfoList = [result]
                    self?.setNextMonthData = true
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-모아보기 화면 예정된 Networking 조회): \(error.localizedDescription)")
//                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        
        // SeminarClosedInfo의 data를 불러옴
        ViewAllViewModel.getNetworkingClosedInfo { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    guard let result = result.result else { return }
                    self?.closeInfoList = result
                    self?.setCloseData = true
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-모아보기 화면 마감된 Networking 조회): \(error.localizedDescription)")
//                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
    }
    
    func initSetDatas(){
        self.setThisMonthData = false
        self.setNextMonthData = false
        self.setCloseData = false
    }
    
    func presentErrorView(){
        let errorView = ErrorPageView()
        errorView.modalPresentationStyle = .fullScreen
        self.present(errorView, animated: false)
    }
    
}

extension ViewAllNetworkingVC {
    
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ViewAllNetworkingTableViewCell.self, forCellReuseIdentifier: ViewAllNetworkingTableViewCell.identifier)
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifier)
    }
    
}

extension ViewAllNetworkingVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if thisMonthInfoList.count == 0 {
                return 1
            }
            return thisMonthInfoList.count
        case 1:
            if nextMonthInfoList.count == 0 {
                return 1
            }
            return nextMonthInfoList.count
        case 2:
            if closeInfoList.count == 0 {
                return 1
            }
            return closeInfoList.count
        default:
            print(">>> ERROR: ViewAllNetworkingVC dataList count")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let edgeInset = 8.0
        var baseHeight = 140.0
        
        switch indexPath.section {
        case 0:
            if thisMonthInfoList.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 140.0
            }
        case 1:
            if nextMonthInfoList.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 140.0
            }
        case 2:
            if closeInfoList.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 140.0
            }
        default:
            return baseHeight + edgeInset
        }
        
        return baseHeight + edgeInset
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewAllNetworkingTableViewCell.identifier, for: indexPath) as? ViewAllNetworkingTableViewCell else {return UITableViewCell()}
        
        cell.selectedBackgroundView = background
        
        switch indexPath.section {
        case 0:
            if thisMonthInfoList.count == 0 {
                cell.configureZeroCell(caseString: "이번 달은")
                cell.isUserInteractionEnabled = false
            } else {
                cell.configureThisMonthInfo(thisMonthInfoList[indexPath.row])
                cell.isUserInteractionEnabled = true
            }
        case 1:
            if nextMonthInfoList.count == 0 {
                cell.configureZeroCell(caseString: "예정된")
                cell.isUserInteractionEnabled = false
            } else {
                cell.configureReadyInfo(nextMonthInfoList[indexPath.row])
                cell.isUserInteractionEnabled = true
            }
        case 2:
            if closeInfoList.count == 0 {
                cell.configureZeroCell(caseString: "마감된")
                cell.isUserInteractionEnabled = false
            } else {
                cell.configureClosedInfo(closeInfoList[indexPath.row])
                cell.isUserInteractionEnabled = true
            }
        default:
            print("dataList Count Error")
        }
        
        return cell
        
    }
    
    // section header custom
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.identifier) as? CustomHeaderView else { return UIView() }
        header.title.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        header.title.text = sections[section]
        header.title.textColor = UIColor(hex: 0x000000, alpha: 0.8)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1,
           nextMonthInfoList[indexPath.row].isOpen == "BEFORE_OPEN" {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var postObject: MyEventToDetailInfo = MyEventToDetailInfo(programIdx: 0, type: "")
        switch indexPath.section {
        case 0:
            postObject = MyEventToDetailInfo(programIdx: thisMonthInfoList[indexPath.row].programIdx, type: thisMonthInfoList[indexPath.row].type)
        case 1:
            postObject = MyEventToDetailInfo(programIdx: nextMonthInfoList[indexPath.row].programIdx, type: nextMonthInfoList[indexPath.row].type)
        case 2:
            postObject = MyEventToDetailInfo(programIdx: closeInfoList[indexPath.row].programIdx, type: closeInfoList[indexPath.row].type)
        default:
            print(">>> ERROR: ViewAllNetworkingVC didSelectRowAt dataList Error")
        }
        
        print(postObject)
        NotificationCenter.default.post(name: Notification.Name("pushEventDetailVC"), object: postObject)

    }
}

extension ViewAllNetworkingVC {
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        self.tableView.refreshControl = refresh
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        
        initSetDatas()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchData {
                if self.setThisMonthData,
                   self.setNextMonthData,
                   self.setCloseData {
                    refresh.endRefreshing()
                }
            }
        }
        
    }
    
}
