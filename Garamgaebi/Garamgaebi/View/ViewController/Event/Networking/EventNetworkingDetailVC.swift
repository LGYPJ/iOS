//
//  EventNetworkingDetailVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/12.
//

import UIKit
import SnapKit

class EventNetworkingDetailVC: UIViewController {
    
    // MARK: - Subviews
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워킹"
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor(hex: 0x000000,alpha: 0.8)
        button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        
        return button
    }()
    
	lazy var tableView: UITableView = {
		let tableView = UITableView()
//		tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		tableView.allowsSelection = false
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		
		return tableView
	}()
	
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
		configureViews()
		configureTableView()
		
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
	}
    

    
}

extension EventNetworkingDetailVC {
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(EventInfoTableViewCell.self, forCellReuseIdentifier: EventInfoTableViewCell.identifier)
		tableView.register(EventAttendantTableViewCell.self, forCellReuseIdentifier: EventAttendantTableViewCell.identifier)
		tableView.register(EventIceBreakingTableViewCell.self, forCellReuseIdentifier: EventIceBreakingTableViewCell.identifier)
	}
	
	private func configureViews() {
		view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(backButton)
		view.addSubview(tableView)
		
        
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
        
        // backButton
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // tableView
		tableView.snp.makeConstraints {
//			$0.edges.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(headerView.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.bottom.equalToSuperview()
		}
	}
	
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	// 네트워킹 신청 did tap
	@objc private func didTapRegisterButton() {
		navigationController?.pushViewController(EventApplyVC(), animated: true)
	}
	// 게임 참가하기 did tap
	@objc private func didTapEntranceButton() {
		self.navigationController?.pushViewController(IceBreakingRoomListVC(), animated: true)
	}


}

extension EventNetworkingDetailVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventInfoTableViewCell.identifier, for: indexPath) as? EventInfoTableViewCell else {return UITableViewCell()}
			cell.eventNameLabel.text = "3차 네트워킹"
			cell.registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
			
			return cell
		case 1:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventAttendantTableViewCell.identifier, for: indexPath) as? EventAttendantTableViewCell else {return UITableViewCell()}
			
			return cell
		case 2:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventIceBreakingTableViewCell.identifier, for: indexPath) as? EventIceBreakingTableViewCell else {return UITableViewCell()}
			cell.entranceButton.addTarget(self, action: #selector(didTapEntranceButton), for: .touchUpInside)
			
			return cell
		default:
			return UITableViewCell()
		}
		
	}
	
	
}

