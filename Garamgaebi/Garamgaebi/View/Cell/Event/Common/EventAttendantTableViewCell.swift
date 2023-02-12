//
//  EventAttendantTableViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit
import Kingfisher

class EventAttendantTableViewCell: UITableViewCell {
	
	static let identifier = "EventAttendantTableViewCell"
	
	lazy var attendantLabel: UILabel = {
		let label = UILabel()
		label.text = "참석자"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var attendantCountLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 20
		layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		//		collectionView.layer.borderColor = UIColor.mainGray.withAlphaComponent(0.8).cgColor
		//		collectionView.layer.borderWidth = 1
		//		collectionView.layer.cornerRadius = 12
		
		return collectionView
	}()
	
	lazy var noAttentdantBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.mainGray.withAlphaComponent(0.8).cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 12
		
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
	
	// MARK: Properties
	var type: String?
	
	var programId: Int = 0 {
		didSet {
			fetchAttendant()
		}
	}
	var seminarAttendants: [SeminarDetailAttendant] = [] {
		didSet {
			configureZeroAttentdant()
			collectionView.reloadData()
		}
	}
	
	var networkingAttendants: [NetworkingDetailAttendant] = [] {
		didSet {
			configureZeroAttentdant()
			collectionView.reloadData()
		}
	}
	

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureViews()
		configureCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

	
}

extension EventAttendantTableViewCell {
	private func configureViews() {
		[attendantLabel, attendantCountLabel, collectionView, noAttentdantBackgroundView]
			.forEach {contentView.addSubview($0)}
		
		attendantLabel.snp.makeConstraints {
//			$0.leading.equalToSuperview().inset(16)
			$0.leading.equalToSuperview()
			$0.top.equalToSuperview().inset(16)
		}
		
		attendantCountLabel.snp.makeConstraints {
			$0.leading.equalTo(attendantLabel.snp.trailing).offset(4)
			$0.bottom.equalTo(attendantLabel)
		}
		
		collectionView.snp.makeConstraints {
			$0.top.equalTo(attendantLabel.snp.bottom).offset(13)
			$0.height.equalTo(85)
//			$0.leading.equalToSuperview().inset(16)
			$0.leading.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.bottom.equalToSuperview().inset(16)
		}
		
		noAttentdantBackgroundView.snp.makeConstraints {
			$0.edges.equalTo(collectionView)
		}
		
		noAttentdantBackgroundView.addSubview(noAttendantTitleLabel)
		noAttendantTitleLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(EventAttendantCollectionViewCell.self, forCellWithReuseIdentifier: EventAttendantCollectionViewCell.identifier)
	}
	
	private func fetchAttendant() {
		if self.type == "SEMINAR" {
			SeminarDetailViewModel.requestSeminarAttendant(seminarId: self.programId, completion: {[weak self] result in
				self?.seminarAttendants = result
				self?.attendantCountLabel.text = "\(result.count)명"
			})
		} else {
			NetworkingDetailViewModel.requestNetworkingAttendant(networkingId: self.programId, completion: {[weak self] result in
				self?.networkingAttendants = result
				self?.attendantCountLabel.text = "\(result.count)명"
			})
		}
		
		
	}
	
	private func configureZeroAttentdant() {
		if seminarAttendants.count == 0 && networkingAttendants.count == 0 {
			collectionView.isHidden = true
			noAttentdantBackgroundView.isHidden = false
		} else {
			collectionView.isHidden = false
			noAttentdantBackgroundView.isHidden = true
		}
	}
}

extension EventAttendantTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if self.type == "SEMINAR" {
			return self.seminarAttendants.count
		} else {
			return self.networkingAttendants.count
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventAttendantCollectionViewCell.identifier, for: indexPath) as? EventAttendantCollectionViewCell else {return UICollectionViewCell()}
		
		if self.type == "SEMINAR" {
			if String(seminarAttendants.first?.memberIdx ?? -1) == UserDefaults.standard.string(forKey: "memberIdx") ?? "" {
//				UserDefaults.standard.set(true, forKey: "programId:\(programId)")
				NotificationCenter.default.post(name: Notification.Name("programId:\(programId)"), object: true)
			} else {
//				UserDefaults.standard.set(false, forKey: "programId:\(programId)")
				NotificationCenter.default.post(name: Notification.Name("programId:\(programId)"), object: false)
			}

			let cellData = self.seminarAttendants[indexPath.row]
			cell.profileImageView.kf.indicatorType = .activity
			cell.profileImageView.kf.setImage(with: URL(string:cellData.profileImg ?? ""), placeholder: UIImage(named: "ExProfileImage"))
			
			cell.userNameLabel.text = cellData.nickname
			
			if indexPath.row == 0 && UserDefaults.standard.bool(forKey: "programId:\(programId)") {
				cell.profileImageView.layer.borderWidth = 2
				cell.userNameLabel.textColor = .mainBlue
			}
		} else {
			if String(networkingAttendants.first?.memberIdx ?? -1) == UserDefaults.standard.string(forKey: "memberIdx") ?? "" {
				NotificationCenter.default.post(name: Notification.Name("programId:\(programId)"), object: true)
			} else {
				NotificationCenter.default.post(name: Notification.Name("programId:\(programId)"), object: false)
			}
			
			let cellData = self.networkingAttendants[indexPath.row]
			cell.profileImageView.kf.indicatorType = .activity
			cell.profileImageView.kf.setImage(with: URL(string:cellData.profileImg ?? ""), placeholder: UIImage(named: "ExProfileImage"))
			cell.userNameLabel.text = cellData.nickname
			
			if indexPath.row == 0 && UserDefaults.standard.bool(forKey: "programId:\(programId)") {
				cell.profileImageView.layer.borderWidth = 2
				cell.userNameLabel.textColor = .mainBlue
			}
		}
		
		
		
//		if indexPath.row == 0{
//			cell.profileImageView.image = UIImage(named: "ExProfileImage")
//		} else {
//			cell.profileImageView.image = UIImage(systemName: "person.circle")
//		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 44, height: 85)
	}
	
	
}
