//
//  SeminarRegisterContentView.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/11.
//

import UIKit
import SnapKit

class SeminarRegisterContentView: UIView {
	
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
	
//	lazy var separator: UIView = {
//		let view = UIView()
//		view.backgroundColor = .mainLightBlue
//		return view
//	}()
	
	lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 10
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
		textField.leftViewMode = .always
		textField.placeholder = "이름을 입력해주세요"

		return textField
	}()
	
	lazy var nicknameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 10
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
		textField.leftViewMode = .always
		textField.placeholder = "닉네임을 입력해주세요"
		
		return textField
	}()
	
	lazy var numberTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 10
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
		textField.leftViewMode = .always
		textField.placeholder = "전화번호를 입력해주세요"
		
		return textField
	}()
	
//	lazy var nameLabel: UILabel = {
//		let label = UILabel()
//		label.text = "이름"
//		label.textColor = .black
//		label.font = UIFont.NotoSansKR(type: .Medium, size: 14)
//
//		return label
//	}()
//
//	lazy var nicknameLabel: UILabel = {
//		let label = UILabel()
//		label.text = "닉네임"
//		label.textColor = .black
//		label.font = UIFont.NotoSansKR(type: .Medium, size: 14)
//
//		return label
//	}()
//
//	lazy var numberLabel: UILabel = {
//		let label = UILabel()
//		label.text = "전화번호"
//		label.textColor = .black
//		label.font = UIFont.NotoSansKR(type: .Medium, size: 14)
//
//		return label
//	}()
	
	lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
//		textView.layer.borderWidth = 0
		textView.font = UIFont.NotoSansKR(type: .Medium, size: 14)
		textView.textColor = .black
		textView.backgroundColor = UIColor(hex: 0xF5F5F5)
		textView.layer.cornerRadius = 12
		textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		textView.isEditable = false
		textView.isScrollEnabled = false
		
		return textView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureViews()
		configureDummyData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// TODO: API연동 후 삭제
	func configureDummyData() {
//		descriptionTextView.isHidden = true
//		costStackView.isHidden = true
		seminarNameLabel.text = "2차 세미나"
		dateInfoLabel.text = "2023-02-10 오후 6시"
		locationInfoLabel.text = "가천대학교 비전타워 B201"
		costInfoLabel.text = "10000원"
		deadlineInfoLabel.text = "2023-01-09 오후 6시"
		
		descriptionTextView.text = "카카오뱅크 3333-22-5500352\n입금자명을 닉네임/이름(예시: 찹도/민세림)으로 해주셔야 합니다.\n\n신청 확정은 신청 마감 이후에 일괄 처리됩니다.\n신청취소는 일주일 전까지 가능합니다.(이후로는 취소 불가)\n환불은 모임 당일부터 7일 이내에 순차적으로 진행됩니다.\n\n입금이 완료되지 않으면 신청이 자동적으로 취소됩니다."
	}
	
}

extension SeminarRegisterContentView {
	private func configureViews() {
		// addSubview
		[seminarInfoView,  nameTextField, nicknameTextField, numberTextField, descriptionTextView]
			.forEach {self.addSubview($0)}
		seminarInfoView.snp.makeConstraints {
			$0.top.equalTo(self.safeAreaLayoutGuide).offset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
//			$0.height.equalTo(150)
		}
		
		[seminarNameLabel, seminarInfoStackView]
			.forEach {seminarInfoView.addSubview($0)}
		
		// layout
		seminarNameLabel.snp.makeConstraints {
			$0.top.equalToSuperview().offset(5.5)
			$0.leading.equalToSuperview().inset(16)
		}
		
		seminarInfoStackView.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(seminarNameLabel.snp.bottom).offset(8)
			$0.bottom.equalToSuperview().inset(12)
		}
		
//		separator.snp.makeConstraints {
//			$0.width.equalToSuperview()
//			$0.leading.trailing.equalToSuperview()
//			$0.height.equalTo(8)
//			$0.top.equalTo(seminarInfoStackView.snp.bottom).offset(13.5)
//		}
		
		nameTextField.snp.makeConstraints {
			$0.top.equalTo(seminarInfoView.snp.bottom).offset(24)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
		nicknameTextField.snp.makeConstraints {
			$0.top.equalTo(nameTextField.snp.bottom).offset(12)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
		numberTextField.snp.makeConstraints {
			$0.top.equalTo(nicknameTextField.snp.bottom).offset(12)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
//		nameLabel.snp.makeConstraints {
//			$0.centerY.equalTo(nameTextField.snp.top)
//			$0.leading.equalTo(nameTextField).offset(17)
//		}
//
//		nicknameLabel.snp.makeConstraints {
//			$0.centerY.equalTo(nicknameTextField.snp.top)
//			$0.leading.equalTo(nicknameTextField).offset(17)
//		}
//
//		numberLabel.snp.makeConstraints {
//			$0.centerY.equalTo(numberTextField.snp.top)
//			$0.leading.equalTo(numberTextField).offset(17)
//		}
		
		
		descriptionTextView.snp.makeConstraints {
			$0.top.equalTo(numberTextField.snp.bottom).offset(23)
			$0.leading.trailing.equalToSuperview().inset(23)
			$0.bottom.equalToSuperview()
		}
	}
}

