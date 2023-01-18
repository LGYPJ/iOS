//
//  ProfileVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

import SnapKit
import Then

class ProfileVC: UIViewController {
    
    // MARK: - Properties
    //    private var snsCollectionView: ProfileSnsCollectionViewCell
    //    private let dataSource = ProfileSnsDataModel.data
    
    // MARK: - Subviews
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let profileTitleLabel = UILabel().then {
        $0.text = "내 프로필"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 24)
    }
    
    let serviceBtn = UIButton().then {
        $0.setImage(UIImage(named: "HeadsetMic"), for: .normal)
        $0.tintColor = .black
    }
    
    let separateLine = UIView().then {
        $0.backgroundColor = .mainGray
    }
    
    let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 50
        $0.backgroundColor = .mainGray
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 20)
    }
    
    let orgLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 16)
    }
    
    let emailLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        $0.textColor = .mainBlue
        let attributedString = NSMutableAttributedString.init(string: " ")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
        $0.attributedText = attributedString
    }
    
    lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        [nameLabel, orgLabel, emailLabel]
            .forEach {stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.spacing = 4
        
        return stackView
    }()
    
    let introduceTextField = UITextView().then {
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.systemGray5.cgColor // UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 16.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14) // .systemFont(ofSize: 18)
        $0.textColor = .black
        $0.isUserInteractionEnabled = false
    }
    
    let profileEditBtn = UIButton().then {
        $0.setTitle("내 프로필 편집하기", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.tintColor = .mainLightBlue
        $0.backgroundColor = .mainLightBlue
        $0.layer.cornerRadius = 10
    }
    
    // 하단 버튼
    // SNS
    let snsTopRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.backgroundColor = UIColor.systemGray6.cgColor
    }
    let snsTitleLabel = UILabel().then {
        $0.text = "SNS"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let snsDefaultLabel = UILabel().then {
        $0.text = "유저들과 소통을 위해서 SNS 주소를 남겨주세요!"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
//        $0.isHidden = true
    }
    let snsBottomRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    var snsCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let addSnsBtn = UIButton().then {
        $0.setTitle("SNS 추가", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.tintColor = .mainBlue
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    // 경력
    let careerTopRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.backgroundColor = UIColor.systemGray6.cgColor
    }
    let careerTitleLabel = UILabel().then {
        $0.text = "경력"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let careerDefaultLabel = UILabel().then {
        $0.text = "지금 하고 있거나\n이전에 한 일을 알려주세요"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
//        $0.isHidden = true
    }
    let careerBottomRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    var careerCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//         cv.backgroundColor = .green
        return cv
    }()
    
    let addCareerBtn = UIButton().then {
        $0.setTitle("경력 추가", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.tintColor = .mainBlue
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    // 교육
    let eduTopRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.backgroundColor = UIColor.systemGray6.cgColor
    }
    let eduTitleLabel = UILabel().then {
        $0.text = "교육"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let eduDefaultLabel = UILabel().then {
        $0.text = "지금 다니고 있거나 이전에 다녔던\n학교, 부트캠프 등 교육기관을 입력해주세요"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
//        $0.isHidden = true
    }
    let eduBottomRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    var eduCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let addEduBtn = UIButton().then {
        let button = UIButton()
        $0.setTitle("교육 추가", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.tintColor = .mainBlue
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCollectionView()
        configureLayouts()
        configureDummyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - Functions
    func configureLayouts() {
        
        // addSubview
        [profileTitleLabel, serviceBtn, separateLine]
            .forEach { view.addSubview($0)}
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        // scroll - profile
        [profileImageView, profileStackView, introduceTextField, profileEditBtn]
            .forEach {scrollView.addSubview($0)}
        
        // scroll - add
        [snsTopRadiusView, snsTitleLabel, snsDefaultLabel, snsBottomRadiusView,
         careerTopRadiusView, careerTitleLabel, careerDefaultLabel, careerBottomRadiusView, careerCollectionView, addCareerBtn,
         eduTopRadiusView, eduTitleLabel, eduDefaultLabel, eduBottomRadiusView, eduCollectionView, addEduBtn].forEach {scrollView.addSubview($0)}
        
        // view - sns
        [snsCollectionView, addSnsBtn].forEach { snsBottomRadiusView.addSubview($0) }
        
        
        
        // layer
        // title bar
        profileTitleLabel.snp.makeConstraints { /// 프로필 타이틀
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(21)
            $0.height.equalTo(70)
        }
        
        serviceBtn.snp.makeConstraints { /// 고객센터
            $0.centerY.equalTo(profileTitleLabel)
            $0.trailing.equalTo(-21)
            $0.height.equalTo(24)
            $0.width.equalTo(serviceBtn.snp.height)
        }
        /// 버튼 클릭
        serviceBtn.addTarget(self,action: #selector(self.serviceButtonDidTap(_:)), for: .touchUpInside)
        
        separateLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(profileTitleLabel.snp.bottom)
            $0.height.equalTo(1)
        }
        
        
        // scrollView
        scrollView.snp.makeConstraints {
            $0.top.equalTo(profileTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        // contentView
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        profileImageView.snp.makeConstraints { /// 프로필 이미지
            $0.width.equalTo(100)
            $0.height.equalTo(profileImageView.snp.width)
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalTo(16)
        }
        
        profileStackView.snp.makeConstraints { /// 이름, 소속, 링크 스택뷰
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
        }
        
        introduceTextField.snp.makeConstraints { /// 자기소개
            $0.top.equalTo(profileStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(profileStackView)
            $0.height.equalTo(100)
        }
        
        profileEditBtn.snp.makeConstraints { /// 프로필 편집 버튼
            $0.top.equalTo(introduceTextField.snp.bottom).offset(19)
            $0.leading.trailing.equalTo(introduceTextField)
            $0.height.equalTo(48)
        }
        /// 버튼 클릭
        profileEditBtn.addTarget(self,action: #selector(self.editButtonDidTap(_:)), for: .touchUpInside)
        
        
        // 하단
        // SNS
        snsTopRadiusView.snp.makeConstraints {
            $0.top.equalTo(profileEditBtn.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(profileEditBtn)
            $0.height.equalTo(47)
        }
        snsTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(snsTopRadiusView)
            $0.leading.trailing.equalTo(snsTopRadiusView).offset(12)
        }
        snsBottomRadiusView.snp.makeConstraints {
            let height = snsDefaultLabel.frame.height + addSnsBtn.frame.height + 120
            $0.top.equalTo(snsTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(snsTopRadiusView)
            $0.height.equalTo(height)
        }
        snsDefaultLabel.snp.makeConstraints {
            $0.top.equalTo(snsBottomRadiusView).offset(12)
            $0.centerX.equalTo(snsBottomRadiusView)
            //            $0.leading.trailing.equalTo(snsBottomRadiusView)
        }
//        snsCollectionView.snp.makeConstraints {
//            $0.top.equalTo(snsDefaultLabel.snp.bottom)
//            $0.leading.trailing.equalTo(snsBottomRadiusView)
//            $0.bottom.equalTo(addSnsBtn).offset(-12)
//        }
        
        addSnsBtn.snp.makeConstraints { /// SNS 추가 버튼
            $0.top.equalTo(snsDefaultLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(snsBottomRadiusView).offset(-16)
            $0.centerX.equalTo(snsBottomRadiusView)
            $0.height.equalTo(48)
            $0.width.equalTo(134)
        }
        /// 버튼 클릭
        addSnsBtn.addTarget(self,action: #selector(self.snsButtonDidTap(_:)), for: .touchUpInside)
        
        
        // Career
        careerTopRadiusView.snp.makeConstraints {
            $0.top.equalTo(snsBottomRadiusView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(snsTopRadiusView)
            $0.height.equalTo(47)
        }
        careerTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(careerTopRadiusView)
            $0.leading.trailing.equalTo(careerTopRadiusView).offset(12)
        }
        careerBottomRadiusView.snp.makeConstraints {
            let height = careerDefaultLabel.frame.height + addCareerBtn.frame.height + 150
            $0.top.equalTo(careerTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(careerTopRadiusView)
            $0.height.equalTo(height)
        }
        careerDefaultLabel.snp.makeConstraints {
            $0.top.equalTo(careerBottomRadiusView).offset(12)
            $0.centerX.equalTo(careerBottomRadiusView)
        }
//        careerCollectionView.snp.makeConstraints {
//            $0.top.equalTo(careerBottomRadiusView)
//            $0.leading.trailing.equalTo(careerBottomRadiusView)
//            $0.bottom.equalTo(addCareerBtn).offset(-12)
//        }
        
        addCareerBtn.snp.makeConstraints { /// 경력 추가 버튼
            $0.top.equalTo(careerDefaultLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(careerBottomRadiusView).offset(-16)
            $0.centerX.equalTo(careerBottomRadiusView)
            $0.height.equalTo(48)
            $0.width.equalTo(134)
        }
        /// 버튼 클릭
        addCareerBtn.addTarget(self,action: #selector(self.careerButtonDidTap(_:)), for: .touchUpInside)
        
        
        // 교육
        eduTopRadiusView.snp.makeConstraints {
            $0.top.equalTo(careerBottomRadiusView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(careerBottomRadiusView)
            $0.height.equalTo(47)
        }
        eduTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(eduTopRadiusView)
            $0.leading.trailing.equalTo(eduTopRadiusView).offset(12)
        }
        eduBottomRadiusView.snp.makeConstraints {
            let height = eduDefaultLabel.frame.height + addEduBtn.frame.height + 150
            $0.top.equalTo(eduTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(eduTopRadiusView)
            $0.bottom.equalTo(scrollView).offset(-16)
            $0.height.equalTo(height)
        }
        eduDefaultLabel.snp.makeConstraints {
            $0.top.equalTo(eduBottomRadiusView).offset(12)
            $0.centerX.equalTo(eduBottomRadiusView)
        }
//        eduCollectionView.snp.makeConstraints {
//            $0.top.equalTo(eduBottomRadiusView)
//            $0.leading.trailing.equalTo(eduBottomRadiusView)
//            $0.bottom.equalTo(addEduBtn).offset(-12)
//        }
        
        addEduBtn.snp.makeConstraints { /// 교육 추가 버튼
            $0.top.equalTo(eduDefaultLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(eduBottomRadiusView).offset(-16)
            $0.centerX.equalTo(eduBottomRadiusView)
            $0.height.equalTo(48)
            $0.width.equalTo(134)
        }
        /// 버튼 클릭
        addEduBtn.addTarget(self,action: #selector(self.educationButtonDidTap(_:)), for: .touchUpInside)
    }
    
    // 컬렉션뷰 등록
    private func registerCollectionView() {
        snsCollectionView.register(ProfileSnsCollectionViewCell.self, forCellWithReuseIdentifier: ProfileSnsCollectionViewCell.identifier)
    }
    
    @objc private func serviceButtonDidTap(_ sender : UIButton) {
        print("고객센터 버튼 클릭")
        
        // 화면 전환
        let nextVC = ProfileServiceVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func editButtonDidTap(_ sender : UIButton) {
        print("프로필 편집 버튼 클릭")
        
        // 화면 전환
        let nextVC = ProfileEditVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func snsButtonDidTap(_ sender : UIButton) {
        print("SNS 추가 버튼 클릭")
        
        //        // 화면 전환
        //        let nextVC = ProfileEditVC()
        //        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func careerButtonDidTap(_ sender : UIButton) {
        print("경력 추가 버튼 클릭")
        
        // 화면 전환
        let nextVC = ProfileInputCareerVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func educationButtonDidTap(_ sender : UIButton) {
        print("교육 추가 버튼 클릭")
        
        // 화면 전환
        let nextVC = ProfileInputEducationVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    // TODO: API연동 후 삭제
    func configureDummyData() {
        nameLabel.text = "코코아"
        orgLabel.text = "가천대학교 소프트웨어학과"
        emailLabel.text = "umc@gmail.com"
        introduceTextField.text = "자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소개자기소."
    }
    
}

// MARK: - Extension
extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // numberOfItemInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    // numberOfItemInSection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = snsCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileSnsCollectionViewCell.identifier, for: indexPath) as? ProfileSnsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.snsLabel.text = "www.naver.com"
        
        return cell
    }
    
    
}
