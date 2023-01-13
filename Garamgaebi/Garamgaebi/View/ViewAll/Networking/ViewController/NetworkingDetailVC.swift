//
//  NetworkingDetailVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/12.
//

import UIKit
import SnapKit

class NetworkingDetailVC: UIViewController {
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .white
		collectionView.isScrollEnabled = true
		collectionView.isUserInteractionEnabled = true

		return collectionView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavigationBar()
		configureNavigationBarShadow()
		configureCollectionView()
        configureViews()
    }
    

    
}

extension NetworkingDetailVC {
	// navigation bar 구성
	private func configureNavigationBar() {
		self.navigationItem.title = "네트워킹"
		let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
		self.navigationItem.leftBarButtonItem = backBarButtonItem
		self.navigationItem.leftBarButtonItem?.action  = #selector(didTapBackBarButton)
		backBarButtonItem.tintColor = .black
	}
	
	// navigation bar shadow 설정
	private func configureNavigationBarShadow() {
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithOpaqueBackground()

		navigationItem.scrollEdgeAppearance = navigationBarAppearance
		navigationItem.standardAppearance = navigationBarAppearance
		navigationItem.compactAppearance = navigationBarAppearance
		navigationController?.setNeedsStatusBarAppearanceUpdate()
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(SeminarInfoCollectionViewCell.self, forCellWithReuseIdentifier: SeminarInfoCollectionViewCell.identifier)
		collectionView.register(SeminarAttendantCollectionViewCell.self, forCellWithReuseIdentifier: SeminarAttendantCollectionViewCell.identifier)
		collectionView.register(SeminarPreviewCollectionViewCell.self, forCellWithReuseIdentifier: SeminarPreviewCollectionViewCell.identifier)
		// 헤더 register
		collectionView.register(SeminarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SeminarHeaderView.identifier)

	}
	
	private func configureViews() {
		view.backgroundColor = .white
		view.addSubview(collectionView)
		
		collectionView.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalToSuperview()
		}

	}
	
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	// 신청하기 버튼 did tap
	@objc private func didTapRegisterButton() {
		self.navigationController?.pushViewController(SeminarRegisterVC(), animated: true)
	}


}
// MARK: collectionview
extension NetworkingDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 3
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch indexPath.section {
		case 0:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeminarInfoCollectionViewCell.identifier, for: indexPath) as? SeminarInfoCollectionViewCell else {return UICollectionViewCell()}
			cell.registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
			cell.seminarNameLabel.text = "3차 네트워킹"
			return cell
		case 1:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeminarAttendantCollectionViewCell.identifier, for: indexPath) as? SeminarAttendantCollectionViewCell else {return UICollectionViewCell()}
			
			return cell
		case 2:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeminarPreviewCollectionViewCell.identifier, for: indexPath) as? SeminarPreviewCollectionViewCell else {return UICollectionViewCell()}
			
			return cell
		default:
			return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = view.frame.size.width
		
		switch indexPath.section {
		case 0:
			return CGSize(width: width, height: 148)
		case 1:
			return CGSize(width: width, height: 132)
		case 2:
			return CGSize(width: width, height: 396)
		default:
			return CGSize(width: 0, height: 0)
		}
	}
	
	// 헤더 설정
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SeminarHeaderView.identifier, for: indexPath)
			return headerView
		}
		return UICollectionReusableView()
	}
	// 헤더 높이
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		let width = view.frame.size.width
		switch section {
		case 1, 2:
			return CGSize(width: width, height: 1)
		default:
			return CGSize(width: 0, height: 0)
		}
	}

}


