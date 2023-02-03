//
//  ViewAllNetworkingVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/17.
//

import UIKit

class ViewAllNetworkingVC: UIViewController {
    
    
    private let sections: [String] = ["이번 달 네트워킹", "예정된 네트워킹", "마감된 네트워킹"]
    private var dataList1: [NetworkingThisMonthInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var dataList2: [NetworkingNextMonthInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var dataList3: [NetworkingClosedInfo] = [] {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
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
    
    func fetchData(){
        // NetworkingThisMonthInfo의 data를 불러옴
        ViewAllViewModel.getNetworkingThisMonthInfo  { [weak self] result in
            self?.dataList1 = [result]
        }
        
        // NetworkingNextMonthInfo의 data를 불러옴
        ViewAllViewModel.getNetworkingNextMonthInfo  { [weak self] result in
            self?.dataList2 = [result]
        }
        
        // NetworkingClosedInfo의 data를 불러옴
        ViewAllViewModel.getNetworkingClosedInfo { [weak self] result in
            self?.dataList3 = result
        }
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
            if dataList1.count == 0 {
                return 1
            }
            return dataList1.count
        case 1:
            if dataList2.count == 0 {
                return 1
            }
            return dataList2.count
        case 2:
            if dataList3.count == 0 {
                return 1
            }
            return dataList3.count
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
            if dataList1.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 140.0
            }
        case 1:
            if dataList2.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 140.0
            }
        case 2:
            if dataList3.count == 0 {
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
            if dataList1.count == 0 {
                cell.configureZeroCell(caseString: "이번 달은")
            } else {
                cell.configureThisMonthInfo(dataList1[indexPath.row])
            }
        case 1:
            if dataList2.count == 0 {
                cell.configureZeroCell(caseString: "예정된")
            } else {
                cell.configureNextMonthInfo(dataList2[indexPath.row])
            }
        case 2:
            if dataList3.count == 0 {
                cell.configureZeroCell(caseString: "마감된")
            } else {
                cell.configureClosedInfo(dataList3[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var postObject: MyEventToDetailInfo = MyEventToDetailInfo(programIdx: 0, type: "")
        switch indexPath.section {
        case 0:
            postObject = MyEventToDetailInfo(programIdx: dataList1[indexPath.row].programIdx, type: dataList1[indexPath.row].type)
        case 1:
            postObject = MyEventToDetailInfo(programIdx: dataList2[indexPath.row].programIdx, type: dataList2[indexPath.row].type)
        case 2:
            postObject = MyEventToDetailInfo(programIdx: dataList3[indexPath.row].programIdx, type: dataList3[indexPath.row].type)
        default:
            print(">>> ERROR: ViewAllNetworkingVC didSelectRowAt dataList Error")
        }
        
        print(postObject)
        NotificationCenter.default.post(name: Notification.Name("pushEventDetailVC"), object: postObject)

    }
}

