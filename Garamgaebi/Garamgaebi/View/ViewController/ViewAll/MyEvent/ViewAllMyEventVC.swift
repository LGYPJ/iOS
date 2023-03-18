//
//  ViewAllMyEventVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/17.
//

import UIKit

class ViewAllMyEventVC: UIViewController {

    private let sections: [String] = ["예정된 모임", "지난 모임"]
    
    // UIRefreshControl
    let refresh = UIRefreshControl()
    
    var setMyEventInfoReadyData = false
    var setMyEventInfoCloseData = false

    
    private var readyInfoList: [MyEventInfoReady] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var closeInfoList: [MyEventInfoClose] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Subviews
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.allowsSelection = false
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
            if self.setMyEventInfoReadyData,
               self.setMyEventInfoCloseData {
//                LoadingView.shared.hide()
            }
        }
		
		NotificationCenter.default.addObserver(self, selector: #selector(refreshByNotification), name: Notification.Name("ReloadMyEvent"), object: nil)
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
        // MyEventReadyInfo의 data를 불러옴
        ViewAllViewModel.getViewAllMyEventReadyInfo(memberId: UserDefaults.standard.integer(forKey: "memberIdx")) { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    if let result = result.result {
                        self?.readyInfoList = result
                    } else {
                        self?.readyInfoList = []
                    }
                    self?.setMyEventInfoReadyData = true
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-모아보기 MyEventReadyInfo 조회): \(error.localizedDescription)")
//                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        
        // MyEventReadyInfo의 data를 불러옴
        ViewAllViewModel.getViewAllMyEventCloseInfo(memberId: UserDefaults.standard.integer(forKey: "memberIdx")) { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    if let result = result.result {
                        self?.closeInfoList = result
                    } else {
                        self?.closeInfoList = []
                    }
                    self?.setMyEventInfoCloseData = true
                    completion()
                } else {
                    // TODO: 뭐든 에러가 있을거임
                    //애니메이션 끄고 에러핸들링
                    //LoadingView.shared.hide()
                }
            case .failure(let error):
                // 네트워킹 문제일 시 errorView로 이동, LodingView hiding
                print("실패(AF-모아보기 MyEventCloseInfo 조회): \(error.localizedDescription)")
//                LoadingView.shared.hide()
                self?.presentErrorView()
            }
        }
        
    }
    
    func initSetDatas(){
        self.setMyEventInfoReadyData = false
        self.setMyEventInfoCloseData = false
    }
    
    func presentErrorView(){
        let errorView = ErrorPageView()
        errorView.modalPresentationStyle = .fullScreen
        self.present(errorView, animated: false)
    }

}



extension ViewAllMyEventVC {
    
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ViewAllMyEventTableViewCell.self, forCellReuseIdentifier: ViewAllMyEventTableViewCell.identifier)
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifier)
        
    }
    
}

extension ViewAllMyEventVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if readyInfoList.count == 0 {
                return 1
            }
            return readyInfoList.count
        case 1:
            if closeInfoList.count == 0 {
                return 1
            }
            return closeInfoList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let edgeInset = 8.0
        var baseHeight = 80.0
        
        switch indexPath.section {
        case 0:
            if readyInfoList.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 80.0
            }
        case 1:
            if closeInfoList.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 80.0
            }
        default:
            return baseHeight + edgeInset
        }
        
        return baseHeight + edgeInset
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewAllMyEventTableViewCell.identifier, for: indexPath) as? ViewAllMyEventTableViewCell else {return UITableViewCell()}
        
        switch indexPath.section {
        case 0:
            if readyInfoList.count == 0 {
                cell.configureZeroCell(caseString: "예정된 내")
            } else {
                cell.configureReady(readyInfoList[indexPath.row])
            }
        case 1:
            if closeInfoList.count == 0 {
                cell.configureZeroCell(caseString: "지난")
            } else {
                cell.configureClose(closeInfoList[indexPath.row])
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
    
}

extension ViewAllMyEventVC {
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        self.tableView.refreshControl = refresh
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        
        initSetDatas()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchData {
                if self.setMyEventInfoReadyData,
                   self.setMyEventInfoCloseData {
                    refresh.endRefreshing()
                }
            }
        }
        
    }
	
	@objc func refreshByNotification() {
		self.fetchData {}
	}
    
}
