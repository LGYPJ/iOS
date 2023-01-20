//
//  IceBreakingRoomVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class IceBreakingRoomVC: UIViewController {
	
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
//		collectionView.isUserInteractionEnabled = false
		collectionView.isScrollEnabled = false
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
	
	lazy var startView: UIView = {
		let view = UIView()
		view.backgroundColor = .mainLightBlue
		view.layer.borderColor = UIColor.mainBlue.cgColor
		view.layer.borderWidth = 2
		view.layer.cornerRadius = 20
		
		return view
	}()
	
	lazy var startLabel: UILabel = {
		let label = UILabel()
		label.text = "시작하기"
		label.textColor = .mainBlue
		label.font = UIFont.NotoSansKR(type: .Bold, size: 24)
		
		
		return label
	}()
	
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
		nextButton.isHidden = true
		nextButton.alpha = 0
		
	}
	
}

extension IceBreakingRoomVC {
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
		cardCollectionView.register(IceBreakingStartCardCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingStartCardCollectionViewCell.identifier)
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
			cardCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
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

extension IceBreakingRoomVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == userCollectionview {
			switch section {
			case 0: return cardCount
			default: return 0
			}
		} else if collectionView == cardCollectionView {
			switch section {
			case 0: return 1
			case 1: return cardCount
			default: return 0
			}
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
			switch indexPath.section {
			case 0:
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingStartCardCollectionViewCell.identifier, for: indexPath) as? IceBreakingStartCardCollectionViewCell else {return UICollectionViewCell()}
				
				return cell
			case 1:
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingCardCollectionViewCell.identifier, for: indexPath) as? IceBreakingCardCollectionViewCell else {return UICollectionViewCell()}
				cell.titleLabel.text = "\(indexPath.row+1)번째 cell 입니다"
				
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
			default:
				return UICollectionViewCell()
			}
			
		} else {
			return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == cardCollectionView && indexPath.section == 0 {
			guard let cell = collectionView.cellForItem(at: indexPath) as? IceBreakingStartCardCollectionViewCell  else {return}
			UIView.transition(with: cell.contentView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
				cell.contentView.alpha = 0
				cell.titleLabel.alpha = 0
			}, completion: { [weak self] _ in
				self?.cardCollectionView.scrollToItem(at: IndexPath(row: self!.currentIndex, section: 1), at: .centeredHorizontally, animated: false)
				self?.nextButton.alpha = 1
				self?.nextButton.isHidden = false
			})
		}
	}
}

