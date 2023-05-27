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
	let headerView = HeaderView(title: "네트워킹")
	
	let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false

		return scrollView
	}()

	let contentView = UIView()

	lazy var programInfoView: ProgramInfoView = {
		let view = ProgramInfoView(showRegisterButton: true)
		view.registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
		
		return view
	}()
	
	let programAttendantView = ProgramAttendantView(attendantData: ProgramAttendantResult(participantList: [], isApply: false))
	
	lazy var networkingIcebreakingEntranceView: NetworkingIcebreakingEntranceView = {
		let view = NetworkingIcebreakingEntranceView()
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapEntranceButton))
		view.entranceContainerView.addGestureRecognizer(tapGestureRecognizer)
		view.entranceContainerView.isUserInteractionEnabled = true
		
		return view
	}()
	
	// MARK: Properties
	var memberId: Int
	var networkingId: Int
	
	let refreshControl = UIRefreshControl()

    // MARK: - Life Cycle
	init(networkingId: Int) {
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
		self.networkingId = networkingId
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
		configureViews()
		configureNotification()
		configureRefreshControl()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchData()
		
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
}

extension EventNetworkingDetailVC {
	
	private func configureViews() {
		view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
			$0.left.right.equalToSuperview()
			$0.height.equalTo(71)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
		
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		scrollView.snp.makeConstraints {
			$0.top.equalTo(headerView.snp.bottom)
			$0.left.right.bottom.equalToSuperview()
		}
		
		contentView.snp.makeConstraints {
			$0.width.equalToSuperview()
			$0.edges.equalToSuperview()
		}
		
		[programInfoView, programAttendantView, networkingIcebreakingEntranceView]
			.forEach {contentView.addSubview($0)}
		
		programInfoView.snp.makeConstraints {
			$0.top.left.right.equalToSuperview().inset(16)
		}
		
		programAttendantView.snp.makeConstraints {
			$0.top.equalTo(programInfoView.snp.bottom).offset(16)
			$0.left.right.equalToSuperview().inset(16)
		}
		
		networkingIcebreakingEntranceView.snp.makeConstraints {
			$0.top.equalTo(programAttendantView.snp.bottom).offset(16)
			$0.left.right.equalToSuperview().inset(16)
			$0.bottom.equalToSuperview().inset(16)
		}
	}
	
	private func fetchData() {
		fetchNetworkingInfo()
		fetchNetworkingAttendant()
	}
	
	private func fetchNetworkingInfo() {
		NetworkingDetailViewModel.requestNetworkingDetailInfo(memberId: self.memberId, networkingId: self.networkingId, completion: {[weak self] result in
			switch result {
			case .success(let result):
				guard let result = result.result else {return}
				self?.programInfoView.programInfo = result
				self?.networkingIcebreakingEntranceView.programStartTime = result.date
				self?.networkingIcebreakingEntranceView.updateUI()
			case .failure(_):
				self?.refreshControl.endRefreshing()
				self?.presentErrorView()
			}
		})
	}
	
	private func fetchNetworkingAttendant() {
		NetworkingDetailViewModel.requestNetworkingAttendant(networkingId: self.networkingId, completion: { [weak self] result in
			self?.programAttendantView.attendantData = result
			self?.networkingIcebreakingEntranceView.isUserApplyProgram = result.isApply
			self?.networkingIcebreakingEntranceView.updateUI()
		})
	}
	
	private func presentErrorView() {
		let errorView = ErrorPageView()
		errorView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(errorView, animated: false)
	}
	
	private func configureNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(pushOtherProfileInProgramDetail(_:)), name: Notification.Name("pushOtherProfileInProgramDetail"), object: nil)
	}
	
	private func configureRefreshControl() {
		refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
		scrollView.refreshControl = refreshControl
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	// 네트워킹 신청 did tap
	@objc private func didTapRegisterButton() {
		navigationController?.pushViewController(EventApplyVC(type: .NETWORKING,programId: self.networkingId), animated: true)
	}
	// 게임 참가하기 did tap
	@objc private func didTapEntranceButton() {
		self.navigationController?.pushViewController(IceBreakingRoomListVC(programId: self.networkingId), animated: true)
	}
	
	@objc func pushOtherProfileInProgramDetail(_ notification: NSNotification) {
		let otherMemberIdx: Int = notification.object as! Int
		self.navigationController?.pushViewController(OtherProfileVC(memberIdx: otherMemberIdx), animated: true)
	}
	
	@objc func refreshTable(refresh: UIRefreshControl) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			self?.fetchData()
			refresh.endRefreshing()
	   }
	}
}

extension EventNetworkingDetailVC: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return true
		}

}


