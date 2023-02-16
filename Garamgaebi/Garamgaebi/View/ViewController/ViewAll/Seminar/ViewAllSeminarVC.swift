//
//  ViewAllSeminarVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/16.
//

import UIKit

class ViewAllSeminarVC: UIViewController {
    
    
    private let sections: [String] = ["이번 달 세미나", "예정된 세미나", "마감된 세미나"]
    private var dataList1: [SeminarThisMonthInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var dataList2: [SeminarReadyInfo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var dataList3: [SeminarClosedInfo] = [] {
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
        // SeminarThisMonthInfo의 data를 불러옴
        ViewAllViewModel.getSeminarThisMonthInfo  { [weak self] result in
            self?.dataList1 = [result]
        }
        
        // SeminarNextMonthInfo의 data를 불러옴
        ViewAllViewModel.getSeminarNextMonthInfo  { [weak self] result in
            self?.dataList2 = [result]
        }
        
        // SeminarClosedInfo의 data를 불러옴
        ViewAllViewModel.getSeminarClosedInfo { [weak self] result in
            self?.dataList3 = result
        }
    }
    
}

extension ViewAllSeminarVC {
    
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ViewAllSeminarTableViewCell.self, forCellReuseIdentifier: ViewAllSeminarTableViewCell.identifier)
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifier)
    }
    
}

extension ViewAllSeminarVC: UITableViewDataSource, UITableViewDelegate {
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
            print(">>> ERROR: ViewAllSeminarVC dataList count")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewAllSeminarTableViewCell.identifier, for: indexPath) as? ViewAllSeminarTableViewCell else {return UITableViewCell()}
        
        cell.selectedBackgroundView = background
        
        switch indexPath.section {
        case 0:
            if dataList1.count == 0 {
                cell.configureZeroCell(caseString: "이번 달은")
                cell.isUserInteractionEnabled = false
            } else {
                cell.configureThisMonthInfo(dataList1[indexPath.row])
                cell.isUserInteractionEnabled = true
            }
        case 1:
            if dataList2.count == 0 {
                cell.configureZeroCell(caseString: "예정된")
                cell.isUserInteractionEnabled = false
            } else {
                cell.configureReadyInfo(dataList2[indexPath.row])
                cell.isUserInteractionEnabled = true
            }
        case 2:
            if dataList3.count == 0 {
                cell.configureZeroCell(caseString: "마감된")
                cell.isUserInteractionEnabled = false
            } else {
                cell.configureClosedInfo(dataList3[indexPath.row])
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
           dataList2[indexPath.row].isOpen == "BEFORE_OPEN" {
            return nil
        }
        return indexPath
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
            print(">>> ERROR: ViewAllSeminarVC didSelectRowAt dataList Error")
        }
        
        print(postObject)
        NotificationCenter.default.post(name: Notification.Name("pushEventDetailVC"), object: postObject)
        
    }
}

