//
//  EventAttendantTableViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class EventAttendantTableViewCell: UITableViewCell {
	
	static let identifier = "EventAttendantTableViewCell"
	
	lazy var attendantLabel: UILabel = {
		let label = UILabel()
		label.text = "참석자"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .black

		return label
	}()
	
	lazy var attendantCountLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 24
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		
		return collectionView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureViews()
		configureDummyData()
		configureCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// TODO: API연동 후 삭제
	var dummyUserNameArr: [String] = []
	func configureDummyData() {
		["승콩", "연현", "코코아", "찹도", "네온", "래리", "로건", "로니", "신디", "애플", "줄리아", "짱구"]
			.forEach {dummyUserNameArr.append($0)}
		attendantCountLabel.text = "\(dummyUserNameArr.count)명"
	}
	
}

extension EventAttendantTableViewCell {
	private func configureViews() {
		[attendantLabel, attendantCountLabel, collectionView]
			.forEach {contentView.addSubview($0)}
		
		attendantLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalToSuperview().inset(16)
		}
		
		attendantCountLabel.snp.makeConstraints {
			$0.leading.equalTo(attendantLabel.snp.trailing).offset(4)
			$0.bottom.equalTo(attendantLabel)
		}
		
		collectionView.snp.makeConstraints {
			$0.top.equalTo(attendantLabel.snp.bottom).offset(13)
			$0.height.equalTo(68)
			$0.leading.equalToSuperview().inset(16)
			$0.trailing.equalToSuperview()
			$0.bottom.equalToSuperview().inset(16)
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(EventAttendantCollectionViewCell.self, forCellWithReuseIdentifier: EventAttendantCollectionViewCell.identifier)
	}
}

extension EventAttendantTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dummyUserNameArr.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventAttendantCollectionViewCell.identifier, for: indexPath) as? EventAttendantCollectionViewCell else {return UICollectionViewCell()}
		cell.userNameLabel.text = dummyUserNameArr[indexPath.row]
		cell.profileImageView.image = UIImage(systemName: "person.fill")
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 44, height: 65)
	}
	
	
}
