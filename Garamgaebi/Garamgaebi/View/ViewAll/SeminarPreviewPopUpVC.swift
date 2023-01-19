//
//  SeminarPreviewPopUpVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/16.
//

import UIKit
import SnapKit

class SeminarPreviewPopUpVC: UIViewController {
	
	lazy var containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 12
		view.clipsToBounds = true
		view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
		return view
	}()
	
	
	lazy var profileBackgroundImageView: UIImageView = {
		let imageView = UIImageView()
		
		return imageView
	}()
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 3
		imageView.layer.borderColor = UIColor.white.cgColor
		
		return imageView
	}()
	
	lazy var userNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
		label.textColor = .black
		
		return label
	}()
	
	lazy var belongLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		label.textColor = .black
		
		return label
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		textView.textColor = .black
		textView.isEditable = false
		textView.isScrollEnabled = false
		// textView와 text사이의 좌우 여백 제거
		textView.textContainer.lineFragmentPadding = 0
		// 이건 상하 여백 제거
		textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

		
		return textView
	}()
	
	lazy var pptLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		label.text = "발표자료"
		
		return label
	}()
	
	lazy var linkLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .link
		
		return label
	}()
	
	lazy var closeImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "xmark")
		imageView.tintColor = .black
		imageView.contentMode = .scaleAspectFit
		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationController?.navigationBar.isHidden = true
		configureViews()
		configureDummyData()
		addGesture()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// curveEaseOut: 천천히 -> 빠르게
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) { [weak self] in
			self?.containerView.transform = .identity
			self?.containerView.isHidden = false
		}
	}
	
	// TODO: dummy
	func configureDummyData() {
		profileBackgroundImageView.backgroundColor = UIColor(hex: 0xEBF0FF)
		profileImageView.image = UIImage(named: "ExProfileImage")
		userNameLabel.text = "연현"
		belongLabel.text = "재학생"
		titleLabel.text = "docker에 대해 알아보자"
		descriptionTextView.text = "함수형의 '함' 자도 몰랐던 저는 함수형 프로그래밍과 ReScript를 처음 접했을 때 어렵게만 느껴졌습니다. 어떤 부분이 생소했는지, 달랐는지, ReScript의 안전하고 명료한 코드 작성의 매력에 어쩌다 빠지게 되었는지 얘기해 보려 합니다."
		linkLabel.text = "www.google.com"
	}
    
}

extension SeminarPreviewPopUpVC {
	private func configureViews() {
		view.backgroundColor = .black.withAlphaComponent(0.2)
		view.addSubview(containerView)
		
		containerView.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(24)
//			$0.height.equalTo(340)
		}
		
		[profileBackgroundImageView, profileImageView, userNameLabel, belongLabel, titleLabel, descriptionTextView, pptLabel, linkLabel, closeImageView]
			.forEach {containerView.addSubview($0)}
		
		profileBackgroundImageView.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview()
			$0.height.equalTo(80)
		}
		
		profileImageView.snp.makeConstraints {
			$0.width.equalTo(80)
			$0.height.equalTo(80)
			$0.leading.equalToSuperview().inset(16)

			$0.centerY.equalTo(profileBackgroundImageView.snp.bottom)
		}
		profileImageView.layer.cornerRadius = 80/2
		
		userNameLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(profileImageView.snp.bottom).offset(16)
		}
		
		belongLabel.snp.makeConstraints {
			$0.centerY.equalTo(userNameLabel)
			$0.leading.equalTo(userNameLabel.snp.trailing).offset(4)
		}
		
		titleLabel.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(userNameLabel.snp.bottom).offset(16)
		}
		
		descriptionTextView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview().inset(16)
//			$0.height.equalTo(80)
		}
		
		pptLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(descriptionTextView.snp.bottom).offset(16)
		}
		
		linkLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(pptLabel.snp.bottom).offset(4)
			$0.bottom.equalToSuperview().inset(20)
		}
		
		closeImageView.snp.makeConstraints {
			$0.width.height.equalTo(20)
			$0.top.equalToSuperview().inset(8)
			$0.trailing.equalToSuperview().inset(8)
		}
	}
	
	private func addGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCloseImageView))
		closeImageView.addGestureRecognizer(tapGesture)
//		.addGestureRecognizer(tapGesture)
	}
	
	@objc private func didTapCloseImageView() {
		// curveEaseOut: 빠르게 -> 천천히
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {[weak self] in
			self?.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
		}) {[weak self] _ in
			self?.containerView.isHidden = true
			self?.dismiss(animated: false)
		}
		
	}
}
