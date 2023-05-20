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
	let headerView = HeaderView(title: "세미나")
	
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
	
	let seminarPreviewView = SeminarPreviewView(previews: [])
	
	// MARK: Properties
	var memberId: Int
	var seminarId: Int
	
	let refreshControl = UIRefreshControl()

    // MARK: - Life Cycle
	
	init(seminarId: Int) {
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
		self.seminarId = seminarId
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureViews()
		configureRefreshControl()
		
		NotificationCenter.default.addObserver(self, selector: #selector(presentPopupVC(_:)), name: Notification.Name("pushSeminarPreviewPopup"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(pushOtherProfileInProgramDetail(_:)), name: Notification.Name("pushOtherProfileInProgramDetail"), object: nil)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchData()
		
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
}

extension EventSeminarDetailVC {
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
		
		[programInfoView, programAttendantView, seminarPreviewView]
			.forEach {contentView.addSubview($0)}
		
		programInfoView.snp.makeConstraints {
			$0.top.left.right.equalToSuperview().inset(16)
		}
		
		programAttendantView.snp.makeConstraints {
			$0.top.equalTo(programInfoView.snp.bottom).offset(16)
			$0.left.right.equalToSuperview().inset(16)
		}
		
		seminarPreviewView.snp.makeConstraints {
			$0.top.equalTo(programAttendantView.snp.bottom).offset(16)
			$0.left.right.equalToSuperview().inset(16)
			$0.bottom.equalToSuperview().inset(16)
		}
		

	}

	
	private func configureRefreshControl() {
		refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
		scrollView.refreshControl = refreshControl
	}
	
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc private func didTapRegisterButton() {
		navigationController?.pushViewController(EventApplyVC(type: .SEMINAR ,programId: self.seminarId), animated: true)
	}
	
	@objc private func presentPopupVC(_ notification: NSNotification) {
		let data: SeminarDetailPreview = notification.object as! SeminarDetailPreview
		let vc = SeminarPreviewPopUpVC(previewInfo: data)
		vc.modalPresentationStyle = .overFullScreen
		
		self.present(vc, animated: false)
	}
	
	@objc func refreshTable(refresh: UIRefreshControl) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
			self?.fetchData()
			refresh.endRefreshing()
	   }
	}
	
	@objc func pushOtherProfileInProgramDetail(_ notification: NSNotification) {
		let otherMemberIdx: Int = notification.object as! Int
		self.navigationController?.pushViewController(OtherProfileVC(memberIdx: otherMemberIdx), animated: true)
		print("push other profile")
	}
	
	// MARK: fetch data
	private func fetchData() {
		fetchSeminarInfo()
		fetchSeminarAttendant()
		fetchPreview()
	}
	
	private func fetchSeminarInfo() {
		SeminarDetailViewModel.requestSeminarDetailInfo(memberId: self.memberId, seminarId: self.seminarId, completion: {[weak self] result in
			switch result {
			case .success(let result):
				guard let result = result.result else {return}
				self?.programInfoView.programInfo = result
			case .failure(_):
				self?.refreshControl.endRefreshing()
				self?.presentErrorView()
			}
		})
	}
	
	private func fetchSeminarAttendant() {
		SeminarDetailViewModel.requestSeminarAttendant(seminarId: self.seminarId, completion: {[weak self] result in
			self?.programAttendantView.attendantData = result
		})
	}
	
	private func fetchPreview() {
		SeminarDetailViewModel.requestSeminarPreview(seminarId: self.seminarId, completion: { [weak self] result in
			self?.seminarPreviewView.previews = result
		})
	}
	
	private func presentErrorView() {
		let errorView = ErrorPageView()
		errorView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(errorView, animated: false)
	}

}

extension EventSeminarDetailVC: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			return true
		}

}
