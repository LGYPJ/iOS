//
//  EventInfoTableViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//  세미나/네트워킹 행사에 대한 정보를 표시하고, 신청하기 버튼이 있는 뷰 입니다.

import UIKit
import SnapKit

class EventInfoTableViewCell: UITableViewCell {
	
	static let identifier = "EventInfoTableViewCell"
	
	// n차 세미나, 네트워킹과 같은 제목 label
	lazy var eventNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var shareImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "Share")
		
		return imageView
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

	lazy var eventInfoStackView: UIStackView = {
		let stackView = UIStackView()
		[dateStackView, locationStackView, costStackView, deadlineStackView]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.spacing = 2
		stackView.axis = .vertical
		stackView.alignment = .leading
		return stackView
	}()
	
	lazy var registerButton: UIButton = {
		let button = UIButton()
		button.setTitle("신청하기", for: .normal)
		button.setTitleColor(.mainBlue, for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		button.layer.cornerRadius = 12
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.mainBlue.cgColor

		return button
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureViews()
		configureDummyData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// TODO: API연동 후 삭제
	func configureDummyData() {
		eventNameLabel.text = "2차 세미나"
		dateInfoLabel.text = "2023-02-10 오후 6시"
		locationInfoLabel.text = "가천대학교 비전타워 B201"
		costInfoLabel.text = "10000원"
		deadlineInfoLabel.text = "2023-01-09 오후 6시"
	}
	
    

}

extension EventInfoTableViewCell {
	private func configureViews() {
		[eventNameLabel, shareImageView, eventInfoStackView, registerButton]
			.forEach {addSubview($0)}
		
		eventNameLabel.snp.makeConstraints {
			$0.top.equalToSuperview().inset(16)
			$0.leading.equalToSuperview().inset(16)
		}
		
		shareImageView.snp.makeConstraints {
			$0.width.equalTo(16.5)
			$0.height.equalTo(18.3)
			$0.leading.equalTo(eventNameLabel.snp.trailing).offset(8)
			$0.centerY.equalTo(eventNameLabel)
		}
		
		eventInfoStackView.snp.makeConstraints {
			$0.leading.equalTo(eventNameLabel)
			$0.top.equalTo(eventNameLabel.snp.bottom).offset(2)
			$0.bottom.equalToSuperview().inset(16)
		}
		
		registerButton.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.width.equalTo(84)
			$0.height.equalTo(84)
			$0.trailing.equalToSuperview().inset(16)
			
		}
	}
}