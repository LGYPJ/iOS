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
		label.textColor = .mainBlack
		
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
	
	// MARK: Properties
	var seminarId: Int = 0 {
		didSet {
			print(seminarId)
			fetchPreview()
		}
	}
	
	var previews: [SeminarDetailPreview] = [] {
		didSet {
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
			$0.height.equalTo(previews.count*104 + (previews.count - 1)*12)
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(EventPreviewCollectionViewCell.self, forCellWithReuseIdentifier: EventPreviewCollectionViewCell.identifier)
	}
	
	private func fetchPreview() {
		SeminarDetailViewModel.requestSeminarPreview(seminarId: self.seminarId, completion: { [weak self] result in
			self?.previews = result
		})
	}
}

extension EventPreviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.previews.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventPreviewCollectionViewCell.identifier, for: indexPath) as? EventPreviewCollectionViewCell else {return UICollectionViewCell()}
		
		let cellData = self.previews[indexPath.row]
		cell.profileImageView.kf.indicatorType = .activity
		cell.profileImageView.kf.setImage(with: URL(string:cellData.profileImgUrl), placeholder: UIImage(named: "DefaultProfileImage"))
		cell.titleLabel.text = cellData.title
		cell.userLabel.text = cellData.nickname
		cell.belongLabel.text = cellData.organization
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = contentView.frame.size.width
		return CGSize(width: width, height: 80)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let vc = SeminarPreviewPopUpVC(previewInfo: self.previews[indexPath.row])
		vc.modalPresentationStyle = .overFullScreen
		
		NotificationCenter.default.post(name: Notification.Name("pushSeminarPreviewPopup"), object: self.previews[indexPath.row])
	}
	
	
	
	
}
