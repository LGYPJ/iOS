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
    var sectionHeader = ["1 section header", "2 section header"]
    var sectionFooter = ["1 section footer", "2 section footer"]
    var cellDataSource = ["1 cell", "2 cell", "3 cell"]
    
    
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
        view.allowsSelection = true
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        //view.register(HomeEventInfoTableViewCell.self, forCellReuseIdentifier: HomeEventInfoTableViewCell.identifier)
        //view.register(HomeUserColectionViewCell.self, forCellReuseIdentifier: HomeUserColectionViewCell.identifier)
        //view.register(MyTableViewCellTwo.self, forCellReuseIdentifier: MyTableViewCellTwo.id)
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
    
    @objc private func pushNextView(_ sender: UIButton) {
        switch sender {
        case notificationViewButton:
            self.navigationController?.pushViewController(HomeNotificationVC(), animated: true)
            
        default:
            print("error")
        }
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
            case 1:
                // Change the background color to blue.
                self.view.backgroundColor = .blue
            case 2:
                // Change the background color to red.
                self.view.backgroundColor = .red
            default:
                print("error")
            }
        }
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
        tableView.register(HomeUserInfoTableViewCell.self, forCellReuseIdentifier: HomeUserInfoTableViewCell.identifier)
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
            return HomeEventInfoTableViewCell.cellHeight
        case 1:
            return HomeUserInfoTableViewCell.cellHeight
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
            cell.backgroundColor = .mainLightGray
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserInfoTableViewCell.identifier, for: indexPath) as? HomeUserInfoTableViewCell else {return UITableViewCell()}
            cell.backgroundColor = .mainLightBlue
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMyEventInfoTableViewCell.identifier, for: indexPath) as? HomeMyEventInfoTableViewCell else {return UITableViewCell()}
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    
    
    
}

