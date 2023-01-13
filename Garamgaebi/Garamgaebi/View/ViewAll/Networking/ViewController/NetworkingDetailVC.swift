//
//  NetworkingDetailViewController.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/12.
//

import UIKit
import SnapKit

class NetworkingDetailVC: UIViewController {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		tableView.allowsSelection = false
		
		return tableView
	}()
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavigationBar()
		configureNavigationBarShadow()
		configureViews()
		configureTableView()
		
		
    }
    

    
}

extension NetworkingDetailVC {
	// navigation bar 구성
	private func configureNavigationBar() {
		self.navigationItem.title = "네트워킹"
		let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
		self.navigationItem.leftBarButtonItem = backBarButtonItem
		self.navigationItem.leftBarButtonItem?.action  = #selector(didTapBackBarButton)
		backBarButtonItem.tintColor = .black
	}
	
	// navigation bar shadow 설정
	private func configureNavigationBarShadow() {
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithOpaqueBackground()

		navigationItem.scrollEdgeAppearance = navigationBarAppearance
		navigationItem.standardAppearance = navigationBarAppearance
		navigationItem.compactAppearance = navigationBarAppearance
		navigationController?.setNeedsStatusBarAppearanceUpdate()
	}
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(EventInfoTableViewCell.self, forCellReuseIdentifier: EventInfoTableViewCell.identifier)
		tableView.register(EventAttendantTableViewCell.self, forCellReuseIdentifier: EventAttendantTableViewCell.identifier)
		tableView.register(EventIceBreakingTableViewCell.self, forCellReuseIdentifier: EventIceBreakingTableViewCell.identifier)
	}
	
	private func configureViews() {
		view.addSubview(tableView)
		
		tableView.snp.makeConstraints {
			$0.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	// 신청하기 버튼 did tap
	@objc private func didTapRegisterButton() {
		self.navigationController?.pushViewController(SeminarRegisterVC(), animated: true)
	}


}

extension NetworkingDetailVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventInfoTableViewCell.identifier, for: indexPath) as? EventInfoTableViewCell else {return UITableViewCell()}
			
			return cell
		case 1:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventAttendantTableViewCell.identifier, for: indexPath) as? EventAttendantTableViewCell else {return UITableViewCell()}
			
			return cell
		case 2:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventIceBreakingTableViewCell.identifier, for: indexPath) as? EventIceBreakingTableViewCell else {return UITableViewCell()}
			
			return cell
		default:
			return UITableViewCell()
		}
		
	}
	
	
}

