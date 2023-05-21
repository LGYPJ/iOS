//
//  ProgramAttendantView.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/19.
//

import UIKit
import SnapKit

class ProgramAttendantView: UIView {
	let attendantLabel: UILabel = {
		let label = UILabel()
		label.text = "참석자"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let attendantCountLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var attendantCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 20
		layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		
		return collectionView
	}()
	
	lazy var noAttentdantBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.mainGray.withAlphaComponent(0.8).cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 12
		view.isHidden = true
		
		return view
	}()
	
	lazy var noAttendantTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "아직 참석자가 없습니다.\n첫 참석자가 되어주세요!"
		label.numberOfLines = 2
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainGray.withAlphaComponent(0.8)
		
		return label
	}()
	
	var attendantData = ProgramAttendantResult(participantList: [], isApply: false) {
		didSet {
			configureAttendants()
			attendantCollectionView.reloadData()
		}
	}
	
	init(attendantData: ProgramAttendantResult) {
		self.attendantData = attendantData
		super.init(frame: .zero)
		configureViews()
		attendantCollectionView.delegate = self
		attendantCollectionView.dataSource = self
		attendantCollectionView.register(EventAttendantCollectionViewCell.self, forCellWithReuseIdentifier: EventAttendantCollectionViewCell.identifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension ProgramAttendantView {
	private func configureViews() {
		[attendantLabel, attendantCountLabel, attendantCollectionView, noAttentdantBackgroundView]
			.forEach {addSubview($0)}
		
		attendantLabel.snp.makeConstraints {
			$0.leading.equalToSuperview()
			$0.top.equalToSuperview()
		}
		
		attendantCountLabel.snp.makeConstraints {
			$0.leading.equalTo(attendantLabel.snp.trailing).offset(4)
			$0.bottom.equalTo(attendantLabel)
		}
		
		attendantCollectionView.snp.makeConstraints {
			$0.top.equalTo(attendantLabel.snp.bottom).offset(13)
			$0.height.equalTo(85)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
		noAttentdantBackgroundView.snp.makeConstraints {
			$0.edges.equalTo(attendantCollectionView)
		}
		
		noAttentdantBackgroundView.addSubview(noAttendantTitleLabel)
		noAttendantTitleLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
	
	private func configureAttendants() {
		guard let attendantCount = attendantData.participantList?.count else {return}
		attendantCountLabel.text = "\(attendantCount)명"
		configureZeroAttendant(isZero: attendantCount == 0)
		
	}
	
	private func configureZeroAttendant(isZero: Bool) {
		if isZero {
			attendantCollectionView.isHidden = true
			noAttentdantBackgroundView.isHidden = false
		} else {
			attendantCollectionView.isHidden = false
			noAttentdantBackgroundView.isHidden = true
		}
	}
	
}

extension ProgramAttendantView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return attendantData.participantList?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventAttendantCollectionViewCell.identifier, for: indexPath) as? EventAttendantCollectionViewCell,
			  let cellData = attendantData.participantList?[indexPath.row] else {return UICollectionViewCell()}
		
		// 탈퇴한 회원 처리
		if cellData.memberIdx == -1 {
			cell.profileImageView.image = UIImage(named: "ExitProfileImage")
			cell.userNameLabel.text = "알 수 없음"
			cell.userNameLabel.textColor = .mainGray
			cell.isUserInteractionEnabled = false
		} else {
			cell.profileImageView.kf.indicatorType = .none
			cell.profileImageView.kf.setImage(with: URL(string:cellData.profileImg ?? ""), placeholder: UIImage(named: "DefaultProfileImage"), options: [.fromMemoryCacheOrRefresh])
			cell.userNameLabel.text = cellData.nickname.maxLength(length: 5)
			cell.userNameLabel.textColor = .mainBlack
			cell.isUserInteractionEnabled = true
		}
		
		// 자신이 참여중인경우 파란테두리
		if indexPath.row == 0 && attendantData.isApply {
			cell.profileImageView.layer.borderWidth = 2
			cell.userNameLabel.textColor = .mainBlue
			cell.isUserInteractionEnabled = false
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 44, height: 85)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("push other profile222")
		NotificationCenter.default.post(name: Notification.Name("pushOtherProfileInProgramDetail"), object: attendantData.participantList?[indexPath.row].memberIdx)
	}
	
	
}
