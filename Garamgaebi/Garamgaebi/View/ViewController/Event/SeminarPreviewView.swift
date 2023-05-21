//
//  SeminarPreviewView.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/05/20.
//

import UIKit
import SnapKit
import Kingfisher

class SeminarPreviewView: UIView {
	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "발표 미리보기"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
		label.textColor = .mainBlack
		
		return label
	}()
	
	let previewCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 12
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.isScrollEnabled = false
		
		return collectionView
	}()
	
	var previews: [SeminarDetailPreview] = [] {
		didSet {
			previewCollectionView.reloadData()
		}
	}
	
	init(previews: [SeminarDetailPreview]) {
		self.previews = previews
		super.init(frame: .zero)
		configureViews()
		previewCollectionView.delegate = self
		previewCollectionView.dataSource = self
		previewCollectionView.register(EventPreviewCollectionViewCell.self, forCellWithReuseIdentifier: EventPreviewCollectionViewCell.identifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension SeminarPreviewView {
	private func configureViews() {
		backgroundColor = .white
		[titleLabel, previewCollectionView]
			.forEach {addSubview($0)}
		
		titleLabel.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.leading.equalToSuperview()
		}
		
		previewCollectionView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(12)
			$0.leading.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.bottom.equalToSuperview()
			$0.height.equalTo(3*80 + 2*12)
		}
	}
}

extension SeminarPreviewView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return previews.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventPreviewCollectionViewCell.identifier, for: indexPath) as? EventPreviewCollectionViewCell else {return UICollectionViewCell()}
		
		let cellData = self.previews[indexPath.row]
		cell.profileImageView.kf.indicatorType = .activity
		cell.profileImageView.kf.setImage(with: URL(string:cellData.profileImgUrl), placeholder: UIImage(named: "DefaultProfileImage_Square"), options: [.fromMemoryCacheOrRefresh])
		cell.titleLabel.text = cellData.title
		cell.userLabel.text = cellData.nickname
		cell.belongLabel.text = cellData.organization
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = frame.size.width
		return CGSize(width: width, height: 80)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		NotificationCenter.default.post(name: Notification.Name("pushSeminarPreviewPopup"), object: self.previews[indexPath.row])
	}
	
	
}
