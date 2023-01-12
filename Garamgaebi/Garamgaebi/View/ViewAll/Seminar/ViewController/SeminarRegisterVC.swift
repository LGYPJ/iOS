//
//  SeminarRegisterVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/11.
//

import UIKit
import SnapKit

class SeminarRegisterVC: UIViewController {
	
	lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
//		scrollView.isDirectionalLockEnabled = true
		scrollView.isScrollEnabled = true
		return scrollView
	}()
	
	lazy var contentView: UIView = {
		let view = SeminarRegisterContentView()
		
		return view
	}()


	lazy var registerButton: UIButton = {
		let button = UIButton()
		button.setTitle("신청하기", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 18)
		button.backgroundColor = UIColor.mainBlue
		button.layer.cornerRadius = 10
		return button
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavigationBar()
		configureNavigationBarShadow()
		configureViews()
    }

}

extension SeminarRegisterVC {
	// navigation bar 구성
	private func configureNavigationBar() {
		self.navigationItem.title = "세미나"
		let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
		self.navigationItem.leftBarButtonItem = backBarButtonItem
		self.navigationItem.leftBarButtonItem?.action  = #selector(didTapBackBarButton)
		backBarButtonItem.tintColor = .black
	}
	
	// navigation bar shadow 설정
	private func configureNavigationBarShadow() {
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithOpaqueBackground()

		navigationController?.navigationBar.tintColor = .clear

		navigationItem.scrollEdgeAppearance = navigationBarAppearance
		navigationItem.standardAppearance = navigationBarAppearance
		navigationItem.compactAppearance = navigationBarAppearance
		navigationController?.setNeedsStatusBarAppearanceUpdate()
	}
	
	private func configureViews() {
		//  view background color
		view.backgroundColor = .white
		
		// addSubview
		[scrollView, registerButton]
			.forEach {view.addSubview($0)}
		scrollView.addSubview(contentView)
		
		// layout
		scrollView.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(registerButton.snp.top).offset(-15)
		}
		
		contentView.snp.makeConstraints {
			$0.width.equalToSuperview()
			$0.edges.equalToSuperview()
		}
		
		registerButton.snp.makeConstraints {
			$0.bottom.equalTo(view.safeAreaLayoutGuide).offset(14)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
	}

	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
}

