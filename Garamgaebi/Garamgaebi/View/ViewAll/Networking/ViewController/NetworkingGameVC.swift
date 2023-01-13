//
//  NetworkingGameVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit

class NetworkingGameVC: UIViewController {
	
	lazy var backgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .mainGray
		view.layer.cornerRadius = 10
		
		return view
	}()
	
	lazy var cardCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//		collectionView.isPagingEnabled = true
		collectionView.isScrollEnabled = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.layer.cornerRadius = 10
		
		return collectionView
	}()
	
	lazy var startButton: UIButton = {
		let button = UIButton()
		button.setTitle("시작하기", for: .normal)
		button.backgroundColor = .mainBlue
		button.layer.cornerRadius = 12
		
		return button
	}()
	
	lazy var nextButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .mainGray
		button.tintColor = .black
//		button.setTitle("다음", for: .normal)
		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		button.layer.cornerRadius = 20
		
		return button
	}()
	
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavigationBar()
		configureNavigationBarShadow()
		configureViews()
		configureCollectionView()
		configureButtonTarget()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		cardCollectionView.isHidden = true
		startButton.isHidden = false
		nextButton.alpha = 0
		nextButton.isEnabled = false
	}
    

    

}

extension NetworkingGameVC {
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
		cardCollectionView.delegate = self
		cardCollectionView.dataSource = self
		cardCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
	}
	
	private func configureViews() {
		view.backgroundColor = .white
		[backgroundView, nextButton]
			.forEach {view.addSubview($0)}
		
		backgroundView.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(38)
			$0.trailing.equalTo(nextButton.snp.leading).offset(-8)
			$0.height.equalTo(backgroundView.snp.width).multipliedBy(1.5)
			$0.centerY.equalToSuperview()
		}
		
		nextButton.snp.makeConstraints {
			$0.trailing.trailing.equalToSuperview().inset(4)
			$0.centerY.equalTo(backgroundView)
			$0.width.equalTo(40)
			$0.height.equalTo(40)
		}
		
		backgroundView.addSubview(cardCollectionView)
		backgroundView.addSubview(startButton)
		
		cardCollectionView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		startButton.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.width.equalTo(217)
			$0.height.equalTo(48)
		}
		
	}
	
	private func configureButtonTarget() {
		startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
		nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
	}
	
	
	@objc private func didTapStartButton() {
		// 화면 뒤집어지는 애니메이션
		UIView.transition(with: backgroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
		// nextButton 서서히 나타나는 애니메이션
		UIView.animate(withDuration: 0.5, animations: {
			self.nextButton.alpha = 1
		}, completion: { [weak self] _ in
			self?.nextButton.isEnabled = true
		})
		
		startButton.isHidden = true
		cardCollectionView.isHidden = false
		
	}
	
	@objc private func didTapNextButton() {
		let visibleItems: NSArray = cardCollectionView.indexPathsForVisibleItems as NSArray
		let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
		let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
		print("\(currentItem), \(nextItem)")
		
		if nextItem.row < 5 {
			cardCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
		}
		if nextItem.row == 4 {
			UIView.animate(withDuration: 0.5, animations: {
				self.nextButton.alpha = 0
			}, completion: { [weak self] _ in
				self?.nextButton.isEnabled = false
			})
		}
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
}

extension NetworkingGameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else {return UICollectionViewCell()}
		cell.backgroundColor = .mainGray
		cell.titleLabel.text = "\(indexPath.row + 1)번째 cell입니다."
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
	
	
}

