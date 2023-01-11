//
//  SeminarAttendantCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/10.
//

import UIKit
import SnapKit

class SeminarAttendantCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "SeminarAttendantCollectionViewCell"
	
	lazy var attendantLabel: UILabel = {
		let label = UILabel()
		label.text = "참석자"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
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

extension SeminarAttendantCollectionViewCell {
	private func configureViews() {
		contentView.backgroundColor = .white
		[attendantLabel, attendantCountLabel, collectionView]
			.forEach {contentView.addSubview($0)}
		
		attendantLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalToSuperview().inset(14)
		}
		
		attendantCountLabel.snp.makeConstraints {
			$0.leading.equalTo(attendantLabel.snp.trailing).offset(4)
			$0.bottom.equalTo(attendantLabel)
		}
		
		collectionView.snp.makeConstraints {
			$0.top.equalTo(attendantLabel.snp.bottom).offset(10)
			$0.height.equalTo(65)
			$0.leading.equalToSuperview().inset(16)
			$0.trailing.equalToSuperview()
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(SeminarAttendantListCollectionViewCell.self, forCellWithReuseIdentifier: SeminarAttendantListCollectionViewCell.identifier)
	}
}

extension SeminarAttendantCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dummyUserNameArr.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeminarAttendantListCollectionViewCell.identifier, for: indexPath) as? SeminarAttendantListCollectionViewCell else {return UICollectionViewCell()}
		cell.userNameLabel.text = dummyUserNameArr[indexPath.row]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 44, height: 65)
	}
	
	
}
