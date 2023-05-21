//
//  ProgramInfoView.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/11.
//

import UIKit
import SnapKit

class ProgramInfoView: UIView {
	let programNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let dateTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "일시"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let dateInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let locationTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "장소"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let locationInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let costTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "참가비"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let costInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let deadlineTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "신청 마감"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let deadlineInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
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

	lazy var programInfoStackView: UIStackView = {
		let stackView = UIStackView()
		[dateStackView, locationStackView, costStackView, deadlineStackView]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .vertical
		stackView.alignment = .leading
		return stackView
	}()
	
	lazy var registerButton: UIButton = {
		let button = UIButton()
		button.setTitle("신청하기", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		button.layer.cornerRadius = 12
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.mainBlue.cgColor
		button.backgroundColor = .mainBlue
		button.isUserInteractionEnabled = true
		
		button.isHidden = true
		
		return button
	}()
	
	var programInfo: ProgramDetailInfo = .init(programIdx: 0, title: "", date: "", location: "", fee: 0, endDate: "", programStatus: "", userButtonStatus: "") {
		didSet {
			configureProgramData()
		}
	}

	
	init(showRegisterButton: Bool) {
		super.init(frame: .zero)
		setupViews()
		
		if showRegisterButton {
			registerButton.isHidden = false
		} else {
			registerButton.isHidden = true
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		backgroundColor = UIColor(hex: 0xEBF0FF)
		layer.cornerRadius = 12
		
		[programNameLabel, programInfoStackView, registerButton]
			.forEach {addSubview($0)}
		
		programNameLabel.snp.makeConstraints {
			$0.top.equalToSuperview().inset(12)
			$0.leading.equalToSuperview().inset(12)
			$0.height.equalTo(29)
		}
		
		programInfoStackView.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(12)
			$0.top.equalTo(programNameLabel.snp.bottom).offset(2)
			$0.bottom.equalToSuperview().inset(12)
		}
		
		registerButton.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.trailing.equalToSuperview().inset(16)
			$0.width.equalTo(84)
			$0.height.equalTo(84)
		}

	}
	
	private func configureProgramData() {
		programNameLabel.text = programInfo.title
		dateInfoLabel.text = programInfo.date.formattingDetailDate()
		locationInfoLabel.text = programInfo.location
		
		if programInfo.fee == 0 {
			costInfoLabel.text = "무료"
		} else {
			costInfoLabel.text = "\(programInfo.fee)원"
		}
		
		deadlineInfoLabel.text = programInfo.endDate.formattingDetailDate()
		
		switch programInfo.userButtonStatus {
		case ProgramUserButtonStatus.APPLY.rawValue:
			registerButton.setTitle("신청하기", for: .normal)
			registerButton.setTitleColor(.white, for: .normal)
			registerButton.isEnabled = true
			registerButton.backgroundColor = .mainBlue
			registerButton.layer.borderWidth = 1

			
		case ProgramUserButtonStatus.CANCEL.rawValue:
			registerButton.setTitle("신청확인중", for: .normal)
			registerButton.setTitleColor(.mainBlue, for: .normal)
			registerButton.isEnabled = false
			registerButton.backgroundColor = .white
			registerButton.layer.borderWidth = 1
			
		case ProgramUserButtonStatus.BEFORE_APPLY_CONFIRM.rawValue:
			registerButton.setTitle("신청확인중", for: .normal)
			registerButton.setTitleColor(.mainBlue, for: .normal)
			registerButton.isEnabled = false
			registerButton.backgroundColor = .white
			registerButton.layer.borderWidth = 1
			
		case ProgramUserButtonStatus.APPLY_COMPLETE.rawValue:
			registerButton.setTitle("신청완료", for: .normal)
			registerButton.setTitleColor(.mainBlue, for: .normal)
			registerButton.isEnabled = false
			registerButton.backgroundColor = .white
			registerButton.layer.borderWidth = 1
			
		case ProgramUserButtonStatus.CLOSED.rawValue:
			registerButton.setTitle("마감", for: .normal)
			registerButton.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
			registerButton.isEnabled = false
			registerButton.backgroundColor = .mainGray
			registerButton.layer.borderWidth = 0

		default:
			registerButton.setTitle("", for: .normal)
			registerButton.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
			registerButton.isEnabled = false
			registerButton.backgroundColor = .mainGray
			registerButton.layer.borderWidth = 0
		}

	}
}
