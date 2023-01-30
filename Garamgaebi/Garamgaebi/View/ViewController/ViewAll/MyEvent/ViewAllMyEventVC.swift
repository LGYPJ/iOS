//
//  ViewAllMyEventVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/17.
//

import UIKit

class ViewAllMyEventVC: UIViewController {

    private let dataList = ViewAllMyEventDataModel.list
    private let sections: [String] = ["예정된 모임", "지난 모임"]
    private var dataList1: [ViewAllMyEventDataModel] = []
    private var dataList2: [ViewAllMyEventDataModel] = []
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataDistribute()
        // Data가 없을 때 시연용
//        dataList1 = []
//        dataList2 = []
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
    
    func dataDistribute(){
        dataList.compactMap { item in
            if item.state != "마감" {
                dataList1.append(item)
            } else {
                dataList2.append(item)
            }
        }
    }
    
    @objc private func pushNextView(_ sender: UIButton) {
        switch sender {
            //        case notificationViewButton:
            //            self.navigationController?.pushViewController(HomeNotificationVC(), animated: true)
            //
        default:
            print("error")
        }
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
            if dataList1.count == 0 {
                return 1
            }
            return dataList1.count
        case 1:
            if dataList2.count == 0 {
                return 1
            }
            return dataList2.count
        default:
            print(fatalError())
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let edgeInset = 8.0
        var baseHeight = 80.0
        
        switch indexPath.section {
        case 0:
            if dataList1.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 80.0
            }
        case 1:
            if dataList2.count == 0 {
                baseHeight = 100.0
            } else {
                baseHeight = 80.0
            }
        default:
            return baseHeight + edgeInset
        }
        
        return baseHeight + edgeInset
    }
    
    func pushNextView(_ target: UIViewController) {
        present(target, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewAllMyEventTableViewCell.identifier, for: indexPath) as? ViewAllMyEventTableViewCell else {return UITableViewCell()}
        
        switch indexPath.section {
        case 0:
            if dataList1.count == 0 {
                cell.configureZeroCell(caseString: "예정된 내")
            } else {
                cell.configure(dataList1[indexPath.row])
            }
        case 1:
            if dataList2.count == 0 {
                cell.configureZeroCell(caseString: "지난")
            } else {
                cell.configure(dataList2[indexPath.row])
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

