//
//  ProfileVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

import SnapKit
import Then

class ProfileVC: UIViewController, EditProfileDataDelegate {
    
    // MARK: - Properties
    let snsDataList = ProfileSnsDataModel.data
    let careerDataList = ProfileCareerDataModel.list
    let educationDataList = ProfileEducationDataModel.list
    
    // MARK: - Subviews
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 프로필"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 24)
        return label
    }()
    
    lazy var serviceButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "HeadsetMic"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(serviceButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    var profileImageView = UIImageView().then {
        $0.clipsToBounds = true
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
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor // UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 12
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14) // .systemFont(ofSize: 18)
        $0.textColor = .black
        $0.isUserInteractionEnabled = false
    }
    
    let profileEditBtn = UIButton().then {
        $0.basicButton()
        $0.setTitle("내 프로필 편집하기", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.backgroundColor = .mainLightBlue
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
//                $0.isHidden = true
    }
    let snsBottomRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    lazy var snsTableView: UITableView = {
        let view = UITableView()

        view.allowsSelection = true
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        
        view.register(ProfileSNSTableViewCell.self, forCellReuseIdentifier: ProfileSNSTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self

        return view
    }()
    
    let addSnsBtn = UIButton().then {
        $0.setTitle("SNS 추가", for: .normal)
        $0.profilePlusButton() // 버튼 디자인
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
        
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    lazy var careerTableView: UITableView = {
        let view = UITableView()

        view.allowsSelection = true
//        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        
        view.register(ProfileHistoryTableViewCell.self, forCellReuseIdentifier: ProfileHistoryTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self

        return view
    }()
    
    let addCareerBtn = UIButton().then {
        $0.setTitle("경력 추가", for: .normal)
        $0.profilePlusButton() // 버튼 디자인
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
        
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    lazy var eduTableView: UITableView = {
        let view = UITableView()
        
        view.allowsSelection = true
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        
        view.register(ProfileHistoryTableViewCell.self, forCellReuseIdentifier: ProfileHistoryTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    let addEduBtn = UIButton().then {
        let button = UIButton()
        $0.setTitle("교육 추가", for: .normal)
        $0.profilePlusButton() // 버튼 디자인
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayouts()
        configureDummyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Functions
    func configureLayouts() {
        
        // addSubview - HeaderView
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(serviceButton)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        // scroll - profile
        [profileImageView, profileStackView, introduceTextField, profileEditBtn]
            .forEach {scrollView.addSubview($0)}
        
        // scroll - add
        [snsTopRadiusView, snsTitleLabel, snsBottomRadiusView,
         careerTopRadiusView, careerTitleLabel, careerBottomRadiusView,
         eduTopRadiusView, eduTitleLabel, eduBottomRadiusView].forEach {scrollView.addSubview($0)}
        
        // view - sns
        [snsDefaultLabel, snsTableView, addSnsBtn].forEach { snsBottomRadiusView.addSubview($0) }
        
        // view - career
        [careerDefaultLabel, careerTableView, addCareerBtn].forEach { careerBottomRadiusView.addSubview($0) }
        
        // view - education
        [eduDefaultLabel, eduTableView, addEduBtn].forEach {
            eduBottomRadiusView.addSubview($0) }
        
        
        
        // layer
        // HeaderView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // serviceButton
        serviceButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        
        // scrollView
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
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
            $0.top.equalTo(introduceTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(introduceTextField)
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
            $0.top.equalTo(snsTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(snsTopRadiusView)
        }
        if (snsDataList.count == 0) {
            snsDefaultLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(addSnsBtn.snp.top).offset(-12)
            }
        }
        else {
            snsTableView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(addSnsBtn.snp.top).offset(-12)
                $0.height.equalTo(snsDataList.count * 41)
            }
        }
        addSnsBtn.snp.makeConstraints { /// SNS 추가 버튼
            $0.bottom.equalTo(snsBottomRadiusView).inset(12)
            $0.centerX.equalTo(snsBottomRadiusView)
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
            $0.top.equalTo(careerTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(careerTopRadiusView)
//            $0.height.equalTo(dataList.count * 65 + 72)
        }
//        careerDefaultLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(12)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(addCareerBtn.snp.top).offset(-12)
//        }
        careerTableView.backgroundColor = .mainPurple
        careerTableView.snp.makeConstraints { /// 경력 테이블뷰
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addCareerBtn.snp.top).offset(-12)
            $0.height.equalTo(careerDataList.count * 65)
        }
        
        addCareerBtn.snp.makeConstraints { /// 경력 추가 버튼
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
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
            $0.top.equalTo(eduTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(eduTopRadiusView)
            $0.bottom.equalTo(scrollView).offset(-16)
        }
//        eduDefaultLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(12)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(addEduBtn.snp.top).offset(-12)
//        }
        eduTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addEduBtn.snp.top).offset(-12)
            $0.height.equalTo(educationDataList.count * 65)
        }
        
        addEduBtn.snp.makeConstraints { /// 교육 추가 버튼
            $0.bottom.equalTo(eduBottomRadiusView).inset(12)
            $0.centerX.equalTo(eduBottomRadiusView)
        }
        /// 버튼 클릭
        addEduBtn.addTarget(self,action: #selector(self.educationButtonDidTap(_:)), for: .touchUpInside)
    }
    
    func editData(image: String, nickname: String, organization: String, email: String, introduce: String) {
        self.profileImageView.image = UIImage(named: image)
        self.nameLabel.text = nickname
        self.orgLabel.text = organization
        self.emailLabel.text = email
        self.introduceTextField.text = introduce
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
        
        // 다음 화면으로 넘길 텍스트
        guard let nameString = nameLabel.text else { return }
        guard let orgString = orgLabel.text else { return }
        guard let emailString = emailLabel.text else { return }
        guard let introduceString = introduceTextField.text else { return }
        
        // 값 넘기기
        nextVC.nameTextField.text = nameString
        nextVC.orgTextField.text = orgString
        nextVC.emailTextField.text = emailString
        nextVC.introduceTextField.text = introduceString
        nextVC.introduceTextField.textColor = .mainBlack
        
        nextVC.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func snsButtonDidTap(_ sender : UIButton) {
        print("SNS 추가 버튼 클릭")
        
        // 화면 전환
        let nextVC = ProfileInputSNSVC()
        navigationController?.pushViewController(nextVC, animated: true)
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
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == snsTableView {
            return snsDataList.count
        }
        else if tableView == careerTableView {
            return careerDataList.count
        }
        else if tableView == eduTableView {
            return educationDataList.count
        }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == snsTableView { return 41 }
        else { return 65 }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == snsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSNSTableViewCell.identifier, for: indexPath) as? ProfileSNSTableViewCell else { return UITableViewCell()}
            cell.snsConfigure(snsDataList[indexPath.row])
            return cell
        }
        else if tableView == careerTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHistoryTableViewCell.identifier, for: indexPath) as? ProfileHistoryTableViewCell else {return UITableViewCell()}
            
            cell.careerConfigure(careerDataList[indexPath.row])
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHistoryTableViewCell.identifier, for: indexPath) as? ProfileHistoryTableViewCell else {return UITableViewCell()}
            
            cell.educationConfigure(educationDataList[indexPath.row])
            return cell
        }
    }
    
}
