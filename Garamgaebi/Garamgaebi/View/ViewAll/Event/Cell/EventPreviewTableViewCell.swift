//
//  EventPreviewTableViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class EventPreviewTableViewCell: UITableViewCell {
	
	static let identifier = "EventPreviewTableViewCell"

	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "발표 미리보기"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .black
		
		return label
	}()
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 12
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.isScrollEnabled = false
		
		return collectionView
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureDummyData()
		configureViews()
		configureCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// TODO: API연동 후 삭제
	var dummyTitleArr: [String] = []
	var dummyUserArr: [String] = []
	var dummyBelongArr: [String] = []
	func configureDummyData() {
		["UICollectionView에 대해 알아보자", "iOS에 대해 알아보자", "Android에 대해 알아보자"]
			.forEach {dummyTitleArr.append($0)}
		["애플", "승콩", "로건"]
			.forEach {dummyUserArr.append($0)}
		["재학생", "애플아카데미", "재학생"]
			.forEach {dummyBelongArr.append($0)}
	}
	
}

extension EventPreviewTableViewCell {
	private func configureViews() {
		contentView.backgroundColor = .white
		[titleLabel, collectionView]
			.forEach {contentView.addSubview($0)}
		
		titleLabel.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.leading.equalToSuperview()
		}
		
		collectionView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(12)
			$0.leading.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.bottom.equalToSuperview().inset(6)
			// 스크롤 가능하게 구현하려면 height를 cellItem*100 + (cellItem-1)*14
			$0.height.equalTo(3*104 + 2*12)
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(EventPreviewCollectionViewCell.self, forCellWithReuseIdentifier: EventPreviewCollectionViewCell.identifier)
	}
}

extension EventPreviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dummyTitleArr.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventPreviewCollectionViewCell.identifier, for: indexPath) as? EventPreviewCollectionViewCell else {return UICollectionViewCell()}
		cell.titleLabel.text = dummyTitleArr[indexPath.row]
		cell.userLabel.text = dummyUserArr[indexPath.row]
		cell.belongLabel.text = dummyBelongArr[indexPath.row]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = contentView.frame.size.width
		return CGSize(width: width, height: 80)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let vc = SeminarPreviewPopUpVC()
		vc.modalPresentationStyle = .overFullScreen
		
		self.window?.rootViewController?.present(vc, animated: false)
	}
	
	
	
	
}
