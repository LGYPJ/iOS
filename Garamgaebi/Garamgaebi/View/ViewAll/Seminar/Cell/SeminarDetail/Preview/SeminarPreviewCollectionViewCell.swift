//
//  SeminarPreviewCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/10.
//

import UIKit
import SnapKit

class SeminarPreviewCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "SeminarPreviewCollectionViewCell"
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "발표 미리보기"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 14
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//		collectionView.showsVerticalScrollIndicator = false
		collectionView.isScrollEnabled = false
		
		return collectionView
	}()
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
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
		["docker에 대해 알아보자", "iOS에 대해 알아보자", "Android에 대해 알아보자"]
			.forEach {dummyTitleArr.append($0)}
		["애플", "승콩", "로건"]
			.forEach {dummyUserArr.append($0)}
		["재학생", "애플아카데미", "재학생"]
			.forEach {dummyBelongArr.append($0)}
	}
	
}

extension SeminarPreviewCollectionViewCell {
	private func configureViews() {
		contentView.backgroundColor = .white
		[titleLabel, collectionView]
			.forEach {contentView.addSubview($0)}
		
		titleLabel.snp.makeConstraints {
			$0.top.equalToSuperview().inset(14)
			$0.leading.equalToSuperview().inset(16)
		}
		
		collectionView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(22)
			$0.leading.equalToSuperview().inset(16)
			$0.trailing.equalToSuperview().inset(16)
			// 스크롤 가능하게 구현하려면 height를 cellItem*100 + (cellItem-1)*14
			$0.height.equalTo(3*100 + 2*14)
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(SeminarPreviewListCollectionViewCell.self, forCellWithReuseIdentifier: SeminarPreviewListCollectionViewCell.identifier)
	}
	
}
extension SeminarPreviewCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dummyTitleArr.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeminarPreviewListCollectionViewCell.identifier, for: indexPath) as? SeminarPreviewListCollectionViewCell else {return UICollectionViewCell()}
		cell.titleLabel.text = dummyTitleArr[indexPath.row]
		cell.userLabel.text = dummyUserArr[indexPath.row]
		cell.belongLabel.text = dummyBelongArr[indexPath.row]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = contentView.frame.size.width - (16 * 2)
		return CGSize(width: width, height: 100)
	}
	
	
}
