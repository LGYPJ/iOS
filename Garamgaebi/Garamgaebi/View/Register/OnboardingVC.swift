//
//  OnboardingVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit
import SnapKit
import Then

class OnboardingVC: UIViewController {
    
    // MARK: - Subviews
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.isScrollEnabled = false
        return cv
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainBlue
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        if #available(iOS 14.0, *) {
            view.backgroundStyle = .minimal // .minimal
        }
        view.numberOfPages = onboardingData.count
        view.setIndicatorImage(UIImage(named: "BluePoint"), forPage: 0)
        view.setIndicatorImage(UIImage(named: "WhitePoint"), forPage: 1)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: - Property
    var onboardingData: [OnboardingDataModel] = []
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            for page in 0..<pageControl.numberOfPages {
                if page == currentPage {
                    pageControl.setIndicatorImage(UIImage(named: "BluePoint"), forPage: page)
                } else {
                    pageControl.setIndicatorImage(UIImage(named: "WhitePoint"), forPage: page)
                }
            }
            if currentPage == onboardingData.count - 1 {
                nextButton.setTitle("시작하기", for: .normal)
            } else {
                nextButton.setTitle("다음", for: .normal)
            }
        }
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setOnboardingData()
        setLayouts()
        setAttributes()
        setCollectionView()
    }
    
    
    // MARK: - Functions
    
    private func setLayouts() {
        
        /* nextButton */
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
        
        /* pageControl */
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-39)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func setAttributes() {
        pageControl.numberOfPages = onboardingData.count
        pageControl.currentPageIndicatorTintColor = .mainBlue
        pageControl.pageIndicatorTintColor = .mainGray
        
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-139)
            make.height.equalTo(100)
            make.width.equalToSuperview()
        }
        
        
    }
    
    private func setOnboardingData() {
        onboardingData.append(contentsOf: [
            OnboardingDataModel(title: "가천대생 개발자들의\n모임 참여를 보다 간편하게",
                                subTitle: "모임의 시작에서 끝까지 개가천선으로 확인해요"),
            OnboardingDataModel(title: "활발한\n가천대생들의 네트워킹",
                                subTitle: "프로필을 통해 선후배와 함께 소통해요")
        ])
    }
    
    @objc
    private func nextButtonTapped(_ sender: Any) {
        if currentPage == onboardingData.count - 1 {

            // LoginVC로 화면전환
            let nextVC = LoginVC()
            nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - Extenstion

extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.cellId, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        
        cell.titleLabel.text = onboardingData[indexPath.row].title
        cell.subTitleLabel.text = onboardingData[indexPath.row].subTitle
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
