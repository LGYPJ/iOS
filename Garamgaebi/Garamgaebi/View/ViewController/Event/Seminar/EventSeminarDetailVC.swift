//
//  EventSeminarDetailVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class EventSeminarDetailVC: UIViewController {
	
    // MARK: - Subviews
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "세미나"
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
		// tableView.height < view.height 인 경우에 스크롤 안되게
		tableView.alwaysBounceVertical = false
		
		return tableView
	}()
	
	// MARK: Properties
	var memberId: Int
	var seminarId: Int
	var seminarInfo: SeminarDetailInfo = .init(programIdx: 0, title: "", date: "", location: "", fee: "", endDate: "", programStatus: "", userButtonStatus: "") {
		didSet {
			tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
		}
	}

    // MARK: - Life Cycle
	
	init(memberId: Int, seminarId: Int) {
		self.memberId = memberId
		self.seminarId = seminarId
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureTableView()
		configureViews()
		fetchSeminarInfo()
		
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
		
	}
    

    

}

extension EventSeminarDetailVC {
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(EventInfoTableViewCell.self, forCellReuseIdentifier: EventInfoTableViewCell.identifier)
		tableView.register(EventAttendantTableViewCell.self, forCellReuseIdentifier: EventAttendantTableViewCell.identifier)
		tableView.register(EventPreviewTableViewCell.self, forCellReuseIdentifier: EventPreviewTableViewCell.identifier)

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
            $0.top.equalTo(headerView.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.bottom.equalToSuperview()
		}
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc private func didTapRegisterButton() {
		navigationController?.pushViewController(EventApplyVC(), animated: true)
	}
	
	// MARK: fetch data
	private func fetchSeminarInfo() {
		SeminarDetailViewModel.requestSeminarDetailInfo(memberId: self.memberId, seminarId: self.seminarId, completion: {[weak self] result in
			self?.seminarInfo = result
		})
	}
	
	
	
	
}

extension EventSeminarDetailVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventInfoTableViewCell.identifier, for: indexPath) as? EventInfoTableViewCell else {return UITableViewCell()}
			cell.registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
			
			cell.eventNameLabel.text = self.seminarInfo.title
			cell.dateInfoLabel.text = self.seminarInfo.date
			cell.locationInfoLabel.text = self.seminarInfo.location
			cell.costInfoLabel.text = self.seminarInfo.fee
			cell.deadlineInfoLabel.text = self.seminarInfo.endDate
			cell.registerButton.setTitle(self.seminarInfo.userButtonStatus, for: .normal)
			
			return cell
		case 1:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventAttendantTableViewCell.identifier, for: indexPath) as? EventAttendantTableViewCell else {return UITableViewCell()}
			cell.programId = self.seminarId
			
			return cell
		case 2:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: EventPreviewTableViewCell.identifier, for: indexPath) as? EventPreviewTableViewCell else {return UITableViewCell()}
			cell.seminarId = self.seminarId
			
			return cell
		default:
			return UITableViewCell()
		}
	}
	
}

extension EventSeminarDetailVC: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return true
		}

}
