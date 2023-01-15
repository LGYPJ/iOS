//
//  NetworkingGameRoomVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class NetworkingGameRoomVC: UIViewController {
	
	lazy var userCollectionview: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 24
		layout.itemSize = CGSize(width: 44, height: 68)
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		
		return collectionView
	}()
	
	lazy var separator: UIView = {
		let view = UIView()
		view.backgroundColor = .mainGray
		
		return view
	}()
	
	lazy var cardCollectionView: UICollectionView = {
//		let layout = UICollectionViewFlowLayout()
		let layout = CustomFlowLayout()
				
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.isUserInteractionEnabled = false
		collectionView.decelerationRate = .fast
		
		
		return collectionView
	}()
	
	lazy var nextButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		button.tintColor = .white
		button.backgroundColor = .mainBlue
		
		return button
	}()
	
//	lazy var startButton: UIButton = {
//		let button = UIButton()
//		button.setTitle("시작하기", for: .normal)
//		button.backgroundColor = .mainBlue
//		button.tintColor = .white
//		button.layer.cornerRadius = 12
//
//		return button
//	}()
	
	var cardCount = 10
	var currentIndex = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureNavigationBar()
		configureNavigationBarShadow()
		configureCollectionView()
		configureViews()
		configureButtonTarget()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		currentIndex = 0
		
	}
	
}

extension NetworkingGameRoomVC {
	// navigation bar 구성
	private func configureNavigationBar() {
		self.navigationItem.title = "가천관"
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
		userCollectionview.delegate = self
		userCollectionview.dataSource = self
		userCollectionview.register(IceBreakingUserCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingUserCollectionViewCell.idetifier)
		cardCollectionView.delegate = self
		cardCollectionView.dataSource = self
		cardCollectionView.register(IceBreakingCardCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingCardCollectionViewCell.identifier)
	}
	
	private func configureViews() {
		view.backgroundColor = .white
		[userCollectionview, separator, cardCollectionView, nextButton]
			.forEach {view.addSubview($0)}
		userCollectionview.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
			$0.leading.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.height.equalTo(68)
		}
		separator.snp.makeConstraints {
			$0.height.equalTo(1)
			$0.leading.trailing.equalToSuperview()
			$0.top.equalTo(userCollectionview.snp.bottom).offset(16)
		}
		
		cardCollectionView.snp.makeConstraints {
			$0.top.equalTo(separator.snp.bottom)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide)
		}
		
		nextButton.snp.makeConstraints {
			$0.centerY.equalTo(cardCollectionView)
			$0.width.height.equalTo(36)
			$0.trailing.equalTo(cardCollectionView).offset(-58)
		}
		nextButton.layer.cornerRadius = 36/2
	}
	
	private func configureButtonTarget() {
		nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	// 다음 카드 버튼 did tap
	@objc private func didTapNextButton() {
		currentIndex += 1
		if currentIndex < cardCount {
			// 해당 인덱스로 스크롤
			cardCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
			userCollectionview.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
			
			cardCollectionView.reloadData()
			userCollectionview.reloadData()
		}
		// 다음 버튼 서서히 사라지는 애니메이션
		if currentIndex == (cardCount - 1) {
			UIView.animate(withDuration: 0.5, animations: {
				self.nextButton.alpha = 0
			}, completion: { [weak self] _ in
				self?.nextButton.isEnabled = false
			})
		}
	}
}

extension NetworkingGameRoomVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == userCollectionview {
			return cardCount
		} else if collectionView == cardCollectionView {
			return cardCount
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == userCollectionview {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingUserCollectionViewCell.idetifier, for: indexPath) as? IceBreakingUserCollectionViewCell else {return UICollectionViewCell()}
			cell.nameLabel.text = "연현"
			if indexPath.row == currentIndex {
				cell.profileImageView.layer.borderWidth = 2
			}
			return cell
		} else if collectionView == cardCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingCardCollectionViewCell.identifier, for: indexPath) as? IceBreakingCardCollectionViewCell else {return UICollectionViewCell()}
			cell.titleLabel.text = "\(indexPath.row + 1)번째 cell 입니다"
			
			// 현재 셀, 앞 뒤 셀들만 보여지고 나머지는 숨김
			if (currentIndex-1)...(currentIndex+1) ~= (indexPath.row) {
				cell.isHidden = false
			} else {
				cell.isHidden = true
			}
			
			// 현재 셀만 내용이 보이도록
			if indexPath.row == currentIndex {
				cell.titleLabel.isHidden = false
			} else{
				cell.titleLabel.isHidden = true
			}
			
			return cell
		} else {
			return UICollectionViewCell()
		}
	}
	
	

	
	
	
	
}





//class NetworkingGameRoomVC: UIViewController {
//
//	lazy var backgroundView: UIView = {
//		let view = UIView()
//		view.backgroundColor = .mainGray
//		view.layer.cornerRadius = 10
//
//		return view
//	}()
//
//	lazy var cardCollectionView: UICollectionView = {
//		let layout = UICollectionViewFlowLayout()
//		layout.scrollDirection = .horizontal
//		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
////		collectionView.isPagingEnabled = true
//		collectionView.isScrollEnabled = false
//		collectionView.showsHorizontalScrollIndicator = false
//		collectionView.layer.cornerRadius = 10
//
//		return collectionView
//	}()
//
//	lazy var startButton: UIButton = {
//		let button = UIButton()
//		button.setTitle("시작하기", for: .normal)
//		button.backgroundColor = .mainBlue
//		button.layer.cornerRadius = 12
//
//		return button
//	}()
//
//	lazy var nextButton: UIButton = {
//		let button = UIButton()
//		button.backgroundColor = .mainGray
//		button.tintColor = .black
////		button.setTitle("다음", for: .normal)
//		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//		button.layer.cornerRadius = 20
//
//		return button
//	}()
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//		configureNavigationBar()
//		configureNavigationBarShadow()
//		configureViews()
//		configureCollectionView()
//		configureButtonTarget()
//    }
//
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//		self.tabBarController?.tabBar.isHidden = true
//		cardCollectionView.isHidden = true
//		startButton.isHidden = false
//		nextButton.alpha = 0
//		nextButton.isEnabled = false
//	}
//
//
//
//
//}
//
//extension NetworkingGameRoomVC {
//	// navigation bar 구성
//	private func configureNavigationBar() {
//		self.navigationItem.title = "가천관"
//		let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
//		self.navigationItem.leftBarButtonItem = backBarButtonItem
//		self.navigationItem.leftBarButtonItem?.action  = #selector(didTapBackBarButton)
//		backBarButtonItem.tintColor = .black
//	}
//
//	// navigation bar shadow 설정
//	private func configureNavigationBarShadow() {
//		let navigationBarAppearance = UINavigationBarAppearance()
//		navigationBarAppearance.configureWithOpaqueBackground()
//
//		navigationItem.scrollEdgeAppearance = navigationBarAppearance
//		navigationItem.standardAppearance = navigationBarAppearance
//		navigationItem.compactAppearance = navigationBarAppearance
//		navigationController?.setNeedsStatusBarAppearanceUpdate()
//	}
//
//	private func configureCollectionView() {
//		cardCollectionView.delegate = self
//		cardCollectionView.dataSource = self
//		cardCollectionView.register(IceBreakingCardCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingCardCollectionViewCell.identifier)
//	}
//
//	private func configureViews() {
//		view.backgroundColor = .white
//		[backgroundView, nextButton]
//			.forEach {view.addSubview($0)}
//
//		backgroundView.snp.makeConstraints {
//			$0.leading.equalToSuperview().inset(38)
//			$0.trailing.equalTo(nextButton.snp.leading).offset(-8)
//			$0.height.equalTo(backgroundView.snp.width).multipliedBy(1.5)
//			$0.centerY.equalToSuperview()
//		}
//
//		nextButton.snp.makeConstraints {
//			$0.trailing.trailing.equalToSuperview().inset(4)
//			$0.centerY.equalTo(backgroundView)
//			$0.width.equalTo(40)
//			$0.height.equalTo(40)
//		}
//
//		backgroundView.addSubview(cardCollectionView)
//		backgroundView.addSubview(startButton)
//
//		cardCollectionView.snp.makeConstraints {
//			$0.edges.equalToSuperview()
//		}
//		startButton.snp.makeConstraints {
//			$0.center.equalToSuperview()
//			$0.width.equalTo(217)
//			$0.height.equalTo(48)
//		}
//
//	}
//
//	private func configureButtonTarget() {
//		startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
//		nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
//	}
//
//
//	@objc private func didTapStartButton() {
//		// 화면 뒤집어지는 애니메이션
//		UIView.transition(with: cardCollectionView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
//		// nextButton 서서히 나타나는 애니메이션
//		UIView.animate(withDuration: 0.5, animations: {
//			self.nextButton.alpha = 1
//		}, completion: { [weak self] _ in
//			self?.nextButton.isEnabled = true
//		})
//
//		startButton.isHidden = true
//		cardCollectionView.isHidden = false
//
//	}
//
//	@objc private func didTapNextButton() {
//		// 현재 collectionView에서 보여지는 아이템의 리스트
//		let visibleItems: NSArray = cardCollectionView.indexPathsForVisibleItems as NSArray
//		// 한번에 한 카드만 보여지므로 visibleItems의 첫번째(0)의 indexPath
//		let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//		let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
//
//		if nextItem.row < 5 {
//			cardCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
//		}
//		if nextItem.row == 4 {
//			UIView.animate(withDuration: 0.5, animations: {
//				self.nextButton.alpha = 0
//			}, completion: { [weak self] _ in
//				self?.nextButton.isEnabled = false
//			})
//		}
//	}
//
//	// 뒤로가기 버튼 did tap
//	@objc private func didTapBackBarButton() {
//		self.navigationController?.popViewController(animated: true)
//	}
//}
//
//extension NetworkingGameRoomVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		return 5
//	}
//
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingCardCollectionViewCell.identifier, for: indexPath) as? IceBreakingCardCollectionViewCell else {return UICollectionViewCell()}
//		cell.backgroundColor = .mainGray
//		cell.titleLabel.text = "\(indexPath.row + 1)번째 cell입니다."
//
//		return cell
//	}
//
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
//	}
//
//
//}
//
