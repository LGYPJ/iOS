//
//  NetworkingIcebreakingEntranceView.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/25.
//

import UIKit
import SnapKit

class NetworkingIcebreakingEntranceView: UIView {
	
	let icebreakingLabel: UILabel = {
		let label = UILabel()
		label.text = "아이스 브레이킹"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.text = "아이스브레이킹 참여는\n네트워킹 당일 정해진 시간에 오픈합니다."
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		label.numberOfLines = 2
		
		return label
	}()
	
	let contentImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "ExNetworkingImage")
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	lazy var entranceContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .mainGray
		view.layer.cornerRadius = 12
		
		return view
	}()
	
	lazy var entranceLabel: UILabel = {
		let label = UILabel()
		label.font = .NotoSansKR(type: .Regular, size: 16)
		label.textColor = UIColor(hex: 0x8A8A8A)
		label.text = "참가하기"
		
		return label
	}()
	
	lazy var entranceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "chevron.right.circle")?.withTintColor(UIColor(hex: 0x8A8A8A), renderingMode: .alwaysOriginal)
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	var programStartTime: String = ""
	var isUserApplyProgram: Bool = false
	
	init() {
		super.init(frame: .zero)
		configureViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateUI() {
		checkUserCanEnterIceBreaking()
	}
}

extension NetworkingIcebreakingEntranceView {
	private func configureViews() {
		backgroundColor = UIColor(hex: 0xF9F9F9)
		layer.cornerRadius = 12
		[icebreakingLabel, descriptionLabel, contentImageView, entranceContainerView]
			.forEach {addSubview($0)}
		
		icebreakingLabel.snp.makeConstraints {
			$0.top.equalToSuperview().inset(12)
			$0.leading.equalToSuperview().inset(12)
		}
		
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(icebreakingLabel.snp.bottom).offset(8)
			$0.leading.equalTo(icebreakingLabel)
		}
		
		contentImageView.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(25)
			$0.leading.trailing.equalToSuperview()
			$0.height.equalTo(154)
//			$0.height.equalTo(contentImageView.snp.width)
			$0.bottom.equalToSuperview().inset(36)
		}
		entranceContainerView.snp.makeConstraints {
			$0.centerY.equalTo(icebreakingLabel)
			$0.trailing.equalToSuperview().inset(16)
		}
		
		[entranceLabel, entranceImageView]
			.forEach {entranceContainerView.addSubview($0)}
		entranceLabel.snp.makeConstraints {
			$0.top.bottom.equalToSuperview().inset(4)
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().inset(8)
		}
		entranceImageView.snp.makeConstraints {
			$0.width.height.equalTo(17)
			$0.top.bottom.equalToSuperview().inset(4)
			$0.centerY.equalToSuperview()
			$0.leading.equalTo(entranceLabel.snp.trailing).offset(8)
			$0.trailing.equalToSuperview().inset(8)
		}
	}
	
	private func checkUserCanEnterIceBreaking() {
		if self.isUserApplyProgram && isAvailableNetworking(fromDate: self.programStartTime) {
			entranceContainerView.backgroundColor = .mainBlue
			entranceContainerView.isUserInteractionEnabled = true
			entranceLabel.textColor = .white
			entranceImageView.image = UIImage(systemName: "chevron.right.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
		} else {
			entranceContainerView.backgroundColor = .mainGray
			entranceContainerView.isUserInteractionEnabled = false
			entranceLabel.textColor = UIColor(hex: 0x8A8A8A)
			entranceImageView.image = UIImage(systemName: "chevron.right.circle")?.withTintColor(UIColor(hex: 0x8A8A8A), renderingMode: .alwaysOriginal)
		}
	}
	
	// 시작시간이 지나면 true, 시작 전이면 false
	private func isAvailableNetworking(fromDate: String) -> Bool {
		guard let eventDate = fromDate.toDate() else {return false}
//		guard let eventDate = "2023-05-25T11:00:00".toDate() else {return false}
		
		let dateTest = Date().compare(eventDate)
		if dateTest == .orderedDescending {  // 시작시간이 현재시간보다 이전인 경우
			return true
		} else {
			return false
		}
	}
}
