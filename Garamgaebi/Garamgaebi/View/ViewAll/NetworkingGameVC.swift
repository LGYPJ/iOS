//
//  NetworkingGameVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class NetworkingGameVC: UIViewController {
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = 16
		layout.minimumLineSpacing = 16
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		return collectionView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureNavigationBar()
		configureNavigationBarShadow()
		cofigureViews()
		configureCollectionView()
    }
    

    

}

extension NetworkingGameVC {
	// navigation bar 구성
	private func configureNavigationBar() {
		self.navigationItem.title = "아이스브레이킹"
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
	
	private func cofigureViews() {
		view.backgroundColor = .white
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
//			$0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(IceBreakingRoomCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingRoomCollectionViewCell.identifier)
		
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
}

extension NetworkingGameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 8
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingRoomCollectionViewCell.identifier, for: indexPath) as? IceBreakingRoomCollectionViewCell else {return UICollectionViewCell()}
		cell.roomTitleLabel.text = "가천관"
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.frame.width - 16) / 2
		let height = (collectionView.frame.height - (16*3)) / 4
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		navigationController?.pushViewController(NetworkingGameRoomVC(), animated: true)
	}
	
	
}
