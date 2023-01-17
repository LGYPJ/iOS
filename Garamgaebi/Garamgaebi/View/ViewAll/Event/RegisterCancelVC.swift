//
//  RegisterCancelVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/12.
//

import UIKit
import SnapKit

class RegisterCancelVC: UIViewController {
	
	lazy var seminarInfoView: UIView = {
		let view = UIView()
		view.backgroundColor = .mainLightBlue
		view.layer.cornerRadius = 12
		
		return view
	}()

	lazy var seminarNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var dateTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "일시"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var dateInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var locationTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "장소"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var locationInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var costTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "참가비"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var costInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var deadlineTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "신청 마감"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var deadlineInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var dateStackView: UIStackView = {
		let stackView = UIStackView()
		[dateTitleLabel, dateInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()
	
	lazy var locationStackView: UIStackView = {
		let stackView = UIStackView()
		[locationTitleLabel, locationInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()

	lazy var costStackView: UIStackView = {
		let stackView = UIStackView()
		[costTitleLabel, costInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()

	lazy var deadlineStackView: UIStackView = {
		let stackView = UIStackView()
		[deadlineTitleLabel, deadlineInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()

	lazy var seminarInfoStackView: UIStackView = {
		let stackView = UIStackView()
		[dateStackView, locationStackView, costStackView, deadlineStackView]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .vertical
		stackView.alignment = .leading
		return stackView
	}()
	
	lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "이름을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "정현우", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)

		return textField
	}()
	
	lazy var nicknameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "닉네임을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "연현", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)
		
		return textField
	}()
	
	lazy var numberTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "전화번호를 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "010-1234-5678", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)
		
		return textField
	}()
	
	lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setTitle("취소하기", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		button.backgroundColor = UIColor.mainBlue
		button.layer.cornerRadius = 12
		return button
	}()
	
	lazy var bankButton: UIButton = {
		let button = UIButton()
		button.setTitle("은행", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		button.backgroundColor = .white
		button.setTitleColor(.mainGray, for: .normal)
		button.contentHorizontalAlignment = .left
		// TODO: titleEdgeInsets은 iOS 15부터 deprecated됨 수정 예정
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
//		button.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
//		button.semanticContentAttribute = .forceRightToLeft
//		// TODO: deprecated
//		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: -30)
		
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.mainGray.cgColor
		button.layer.cornerRadius = 12
		
		return button
	}()
	
//	lazy var bankDetailImageView: UIImageView = {
//		let imageView = UIImageView()
//		imageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysOriginal)
//
//		return imageView
//	}()
	
	lazy var downImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "chevron.down")
		imageView.tintColor = .black
		
		return imageView
	}()
	
	lazy var accountTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
		textField.attributedPlaceholder = NSAttributedString(string: "계좌번호를 입력해주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		
		return textField
	}()
	
	lazy var accountStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		[bankButton, accountTextField]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.spacing = 8
		stackView.distribution = .fill

		return stackView
	}()

	

    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavigationBar()
		configureNavigationBarShadow()
		configureViews()
		configureDummyData()
		configureButtonTarget()
        
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
	}

	
	func configureDummyData() {
		seminarNameLabel.text = "2차 세미나"
		dateInfoLabel.text = "2023-02-10 오후 6시"
		locationInfoLabel.text = "가천대학교 비전타워 B201"
		costInfoLabel.text = "10000원"
		deadlineInfoLabel.text = "2023-01-09 오후 6시"
	}
    

    
}

// MARK: functions
extension RegisterCancelVC: sendBankNameProtocol {
	// navigation bar 구성
	private func configureNavigationBar() {
		self.navigationItem.title = "신청 취소"
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
	
	private func configureViews() {
		view.backgroundColor = .white
		[seminarInfoView, nameTextField, nicknameTextField, numberTextField, accountStackView, cancelButton, downImageView]
			.forEach {view.addSubview($0)}
		
		[seminarNameLabel, seminarInfoStackView]
			.forEach {seminarInfoView.addSubview($0)}
		
		seminarNameLabel.snp.makeConstraints {
			$0.top.equalToSuperview().offset(12)
			$0.leading.equalToSuperview().inset(16)
		}
		
		seminarInfoStackView.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(seminarNameLabel.snp.bottom).offset(8)
			$0.bottom.equalToSuperview().inset(12)
		}
		
		seminarInfoView.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		
		nameTextField.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(seminarInfoView.snp.bottom).offset(24)
			$0.height.equalTo(48)
		}
		
		nicknameTextField.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(nameTextField.snp.bottom).offset(12)
			$0.height.equalTo(48)
		}

		numberTextField.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(nicknameTextField.snp.bottom).offset(12)
			$0.height.equalTo(48)
		}
		
		accountStackView.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(numberTextField.snp.bottom).offset(24)
			$0.height.equalTo(48)
		}
		
		bankButton.snp.makeConstraints {
			$0.width.equalTo(100)
		}
//		bankButton.addSubview(downImageView)
//
		downImageView.snp.makeConstraints {
			$0.width.equalTo(18)
			$0.height.equalTo(18)
			$0.trailing.equalTo(bankButton.snp.trailing).offset(-8)
			$0.centerY.equalTo(bankButton)
		}
		
		
		cancelButton.snp.makeConstraints {
			$0.bottom.equalToSuperview().inset(48)
			$0.leading.trailing.equalToSuperview().inset(12)
			$0.height.equalTo(48)

		}

		
		
	}
	
	private func configureButtonTarget() {
		cancelButton.addTarget(self, action: #selector(didTapRegisterCancelButton), for: .touchUpInside)
		bankButton.addTarget(self, action: #selector(didTapBankButton), for: .touchUpInside)
	}
	
	// 은행 텍스트 필드 tap
	@objc private func didTapBankButton() {
		let vc = RegisterCancelBankPopUpVC()
		vc.delegate = self
		self.present(vc, animated: true)
	}
	
	// 취소 완료 alert
	@objc private func didTapRegisterCancelButton() {
		let sheet = UIAlertController(title: nil, message: "신청 취소가 완료되었습니다.", preferredStyle: .alert)
		let closeAction = UIAlertAction(title: "닫기", style: .cancel)
		sheet.addAction(closeAction)
		
		present(sheet, animated: true)
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func sendBankName(name: String) {
		bankButton.setTitle(name, for: .normal)
		bankButton.setTitleColor(.black, for: .normal)
	}

}

