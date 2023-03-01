//
//  ProfileVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

import SnapKit
import Then
import Alamofire
import Kingfisher

class ProfileVC: UIViewController {
    
    // MARK: - Properties
    
    // 추후 로그인 구현 후 변경
    let memberIdx = UserDefaults.standard.integer(forKey: "memberIdx")

    let token = UserDefaults.standard.string(forKey: "BearerToken")
    
    var snsData: [SnsResult] = []
    var careerData: [CareerResult] = []
    var eduData: [EducationResult] = []
    
    var snsIdx: Int = 0
    var careerIdx: Int = 0
    
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
        label.textColor = .mainBlack
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
    
    lazy var scrollView = UIScrollView()
    
    lazy var contentView = UIView()
    
    lazy var profileImageView = UIImageView().then {
        // 이미지 centerCrop
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        
        $0.layer.cornerRadius = 50
    }
    
    lazy var nameLabel = UILabel().then {
        $0.textColor = .mainBlack
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 20)
    }
    
    lazy var belongLabel = UILabel().then {
        $0.textColor = .mainBlack
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 16)
    }
    
    lazy var emailLabel = UILabel().then {
        $0.textColor = .mainBlack
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        $0.textColor = .mainBlue
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emailLabelDidTap))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGestureRecognizer)
    }
    
    lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        [nameLabel, belongLabel, emailLabel]
            .forEach {stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.spacing = 4
        
        return stackView
    }()
    
    lazy var introduceLabel = BasicPaddingLabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textColor = .mainBlack
        $0.numberOfLines = 0
        $0.clipsToBounds = true // 요소가 삐져나가지 않도록 하는 속성
        $0.textAlignment = .left
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.cornerRadius = 12
    }
    
    lazy var profileEditBtn = UIButton().then {
        $0.basicButton()
        $0.setTitle("내 프로필 편집하기", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.backgroundColor = .mainLightBlue
    }
    
    // 하단 버튼
    // SNS
    lazy var snsTopRadiusView = UIView().then {
        $0.profileTopRadiusView(title: "SNS")
    }
    lazy var snsDefaultLabel = UILabel().then {
        $0.text = "유저들과 소통을 위해서 SNS 주소를 남겨주세요!"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
    }
    lazy var snsBottomRadiusView = UIView().then {
        $0.profileBottomRadiusView()
    }
    
    lazy var snsTableView: UITableView = {
        let view = UITableView()

        view.allowsSelection = true
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.isScrollEnabled = false
        
        view.register(ProfileSNSTableViewCell.self, forCellReuseIdentifier: ProfileSNSTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self

        return view
    }()
    
    lazy var addSnsBtn = UIButton().then {
        $0.setTitle("SNS 추가", for: .normal)
        $0.profilePlusButton() // 버튼 디자인
    }
    
    // 경력
    lazy var careerTopRadiusView = UIView().then {
        $0.profileTopRadiusView(title: "경력")
    }
    lazy var careerDefaultLabel = UILabel().then {
        $0.text = "지금 하고 있거나\n이전에 한 일을 알려주세요"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    lazy var careerBottomRadiusView = UIView().then {
        $0.profileBottomRadiusView()
    }
    
    lazy var careerTableView: UITableView = {
        let view = UITableView()

        view.allowsSelection = true
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.isScrollEnabled = false
        
        view.register(ProfileHistoryTableViewCell.self, forCellReuseIdentifier: ProfileHistoryTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self

        return view
    }()
    
    lazy var addCareerBtn = UIButton().then {
        $0.setTitle("경력 추가", for: .normal)
        $0.profilePlusButton() // 버튼 디자인
    }
    
    // 교육
    lazy var eduTopRadiusView = UIView().then {
        $0.profileTopRadiusView(title: "교육")
    }
    lazy var eduDefaultLabel = UILabel().then {
        $0.text = "지금 다니고 있거나 이전에 다녔던\n학교, 부트캠프 등 교육기관을 입력해주세요"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    lazy var eduBottomRadiusView = UIView().then {
        $0.profileBottomRadiusView()
    }
    
    lazy var eduTableView: UITableView = {
        let view = UITableView()
        
        view.allowsSelection = true
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.isScrollEnabled = false
        
        view.register(ProfileHistoryTableViewCell.self, forCellReuseIdentifier: ProfileHistoryTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    lazy var addEduBtn = UIButton().then {
        let button = UIButton()
        $0.setTitle("교육 추가", for: .normal)
        $0.profilePlusButton() // 버튼 디자인
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayouts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        
        // 서버 통신
        getMyInfo()
        
        self.getSnsData { [weak self] result in
            self?.snsData = result
            self?.showSnsDefaultLabel()
            self?.snsTableView.reloadData()
        }
        self.getCareerData { [weak self] result in
            self?.careerData = result
            self?.careerTableView.reloadData()
            self?.showCareerDefaultLabel()
        }
        self.getEducationData { [weak self] result in
            self?.eduData = result
            self?.showEducationDefaultLabel()
            self?.eduTableView.reloadData()
        }
    }
    
    // MARK: - Functions
    
    @objc func reloadProfile() {
        snsTableView.reloadData()
        careerTableView.reloadData()
        eduTableView.reloadData()
    }
    
    func configureLayouts() {
        
        view.backgroundColor = .white
        
        // addSubview - HeaderView
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(serviceButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        // scroll - profile
        [profileImageView, profileStackView, introduceLabel, profileEditBtn]
            .forEach {contentView.addSubview($0)}
        
        // scroll - add
        [snsTopRadiusView, snsBottomRadiusView,
         careerTopRadiusView, careerBottomRadiusView,
         eduTopRadiusView, eduBottomRadiusView].forEach {contentView.addSubview($0)}
        
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        introduceLabel.snp.makeConstraints { /// 자기소개
            $0.top.equalTo(profileStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(profileStackView)
            $0.height.equalTo(introduceLabel.intrinsicContentSize)
        }
        
        profileEditBtn.snp.makeConstraints { /// 프로필 편집 버튼
            $0.top.equalTo(introduceLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(introduceLabel)
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
        snsBottomRadiusView.snp.makeConstraints {
            $0.top.equalTo(snsTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(snsTopRadiusView)
        }
        addSnsBtn.snp.makeConstraints { /// SNS 추가 버튼
            $0.bottom.equalTo(snsBottomRadiusView).inset(12)
            $0.centerX.equalTo(snsBottomRadiusView)
        }
        /// 버튼 클릭
        addSnsBtn.addTarget(self,action: #selector(self.snsButtonDidTap(_:)), for: .touchUpInside)
        
        
        // 경력
        careerTopRadiusView.snp.makeConstraints {
            $0.top.equalTo(snsBottomRadiusView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(snsTopRadiusView)
            $0.height.equalTo(47)
        }
        careerBottomRadiusView.snp.makeConstraints {
            $0.top.equalTo(careerTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(careerTopRadiusView)
//            $0.height.equalTo(dataList.count * 65 + 72)
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
        eduBottomRadiusView.snp.makeConstraints {
            $0.top.equalTo(eduTopRadiusView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(eduTopRadiusView)
            $0.bottom.equalTo(scrollView).offset(-16)
        }
        
        addEduBtn.snp.makeConstraints { /// 교육 추가 버튼
            $0.bottom.equalTo(eduBottomRadiusView).inset(12)
            $0.centerX.equalTo(eduBottomRadiusView)
        }
        /// 버튼 클릭
        addEduBtn.addTarget(self,action: #selector(self.educationButtonDidTap(_:)), for: .touchUpInside)
    }
    
    @objc func emailLabelDidTap() {
        guard let copyString = emailLabel.text else { return }
        UIPasteboard.general.string = copyString
        self.showToast(message: "클립보드에 복사되었습니다")
    }
    
    @objc private func serviceButtonDidTap(_ sender : UIButton) {
        // 화면 전환
        let nextVC = ProfileServiceVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func editButtonDidTap(_ sender : UIButton) {
        // 화면 전환
        let nextVC = ProfileEditVC()
        
        let nameString = self.nameLabel.text ?? ""
        let orgString = self.belongLabel.text ?? ""
        let emailString = self.emailLabel.text ?? ""
        let introduceString = self.introduceLabel.text
        let profileImage = self.profileImageView.image ?? UIImage(named: "DefaultProfileImage")!
        
        // 값 넘기기
        nextVC.profileImageView.image = profileImage
        nextVC.nickNameTextField.text = nameString
        nextVC.belongTextField.text = orgString
        nextVC.emailTextField.text = emailString
        // 자기소개가 있다면 넘김
        if introduceString != nil {
            nextVC.introduceTextField.text = introduceString
            nextVC.introduceTextField.textColor = .mainBlack
        } else {
            nextVC.introduceTextField.text = "100자 이내로 작성해주세요"
            nextVC.introduceTextField.textColor = .mainGray
        }
        // 사용자
        nextVC.memberIdx = self.memberIdx
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func snsButtonDidTap(_ sender : UIButton) {
        // 화면 전환
        let nextVC = ProfileInputSNSVC()
        nextVC.memberIdx = memberIdx
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func careerButtonDidTap(_ sender : UIButton) {
        // 화면 전환
        let nextVC = ProfileInputCareerVC()
        nextVC.memberIdx = memberIdx
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func educationButtonDidTap(_ sender : UIButton) {
        // 화면 전환
        let nextVC = ProfileInputEducationVC()
        nextVC.memberIdx = memberIdx
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-150, width: 180, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // MARK: - [GET] 내프로필 정보
    func getMyInfo() {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/\(memberIdx)"
        
        // httpBody에 parameters 추가
        AF.request(
            url, // 주소
            method: .get, // 전송 타입
            interceptor: MyRequestInterceptor()
        )
        .validate() // statusCode:  200..<300
        .responseDecodable(of: ProfileResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    let result = response.result
                    // 값 넣어주기
                    self.nameLabel.text = result?.nickName
                    self.belongLabel.text = result?.belong
                    self.emailLabel.text = result?.profileEmail
                    // 자기소개
                    if let userIntro = result?.content { // 자기소개
                        //있으면 보이게
                        self.introduceLabel.text = userIntro
                        self.introduceLabel.isHidden = false
                        self.introduceLabel.snp.updateConstraints {
                            $0.top.equalTo(self.profileStackView.snp.bottom).offset(16)
                            $0.leading.trailing.equalTo(self.profileStackView)
                            $0.height.equalTo(self.introduceLabel.intrinsicContentSize)
                        }
                    } else { // 없으면 안 보이게
                        self.introduceLabel.text = nil
                        self.introduceLabel.isHidden = true
                        self.introduceLabel.snp.updateConstraints {
                            $0.top.equalTo(self.profileStackView.snp.bottom)
                            $0.height.equalTo(0)
                        }
                    }
                    // 프로필 이미지
                    if let urlString = result?.profileUrl {
                        let processor = RoundCornerImageProcessor(cornerRadius: self.profileImageView.layer.cornerRadius)
                        guard let url = URL(string: urlString) else { return }
                        self.profileImageView.backgroundColor = .white
                        self.profileImageView.kf.setImage(with: url, options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
//                            .transition(.fade(0.5)),
                            .forceRefresh
                        ])
                    } else {
                        self.profileImageView.image = UIImage(named: "DefaultProfileImage")
                    }
                } else {
                    print("실패(내프로필): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-내프로필): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [GET] SNS 조회
    func getSnsData(completion: @escaping (([SnsResult])) -> Void) {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/sns/\(memberIdx)"
        
        // httpBody에 parameters 추가
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            interceptor: MyRequestInterceptor()
        )
        .validate()
        .responseDecodable(of: SnsResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
//                    print("성공(SNS조회): \(response.message)")
                    let result = response.result
                    completion(result)
                } else {
                    print("실패(SNS조회): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-SNS조회): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [GET] Career 조회
    func getCareerData(completion: @escaping (([CareerResult]) -> Void)) {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/career/\(memberIdx)"
        
        // httpBody에 parameters 추가
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            interceptor: MyRequestInterceptor()
        )
        .validate()
        .responseDecodable(of: CareerResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
//                    print("성공(Career조회): \(response.message)")
                    let result = response.result
                    completion(result)
                    
                } else {
                    print("실패(Career조회): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Career조회): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [GET] Education 조회
    func getEducationData(completion: @escaping (([EducationResult]) -> Void)) {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/education/\(memberIdx)"
        
        // httpBody에 parameters 추가
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            interceptor: MyRequestInterceptor()
        )
        .validate()
        .responseDecodable(of: EducationResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
//                    print("성공(Education조회): \(response.message)")
                    let result = response.result
                    completion(result)
                    
                } else {
                    print("실패(Education조회): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Education조회): \(error.localizedDescription)")
            }
        }
    }
    
    func showSnsDefaultLabel() {
        let snsCount = snsData.count
        if (snsCount == 0) {
            snsTableView.snp.removeConstraints()
            snsDefaultLabel.snp.updateConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(addSnsBtn.snp.top).offset(-12)
            }
        }
        else {
            snsDefaultLabel.snp.removeConstraints()
            snsTableView.snp.updateConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(addSnsBtn.snp.top).offset(-12)
                $0.height.equalTo(snsCount * 65)
            }
        }
    }
    
    func showCareerDefaultLabel() {
        let careerCount = careerData.count
        if (careerCount == 0) {
            careerTableView.snp.removeConstraints()
            careerDefaultLabel.snp.updateConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(addCareerBtn.snp.top).offset(-12)
            }
        }
        else {
            careerTableView.snp.updateConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(addCareerBtn.snp.top).offset(-12)
                $0.height.equalTo(careerCount * 90)
            }
            careerDefaultLabel.snp.removeConstraints()
        }
    }
    
    func showEducationDefaultLabel() {
        let eduCount = eduData.count
        if (eduCount == 0) {
            eduTableView.snp.removeConstraints()
            eduDefaultLabel.snp.updateConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(addEduBtn.snp.top).offset(-12)
            }
        }
        else {
            eduDefaultLabel.snp.removeConstraints()
            eduTableView.snp.updateConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(addEduBtn.snp.top).offset(-12)
                $0.height.equalTo(eduCount * 90)
            }
        }
    }
    
}
// MARK: - Extension
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == snsTableView {
            return snsData.count
        }
        else if tableView == careerTableView {
            return careerData.count
        }
        else if tableView == eduTableView {
            return eduData.count
        }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == snsTableView { return 65 }
        else { return 90 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == snsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSNSTableViewCell.identifier, for: indexPath) as? ProfileSNSTableViewCell else { return UITableViewCell()}
            
            let row = snsData[indexPath.row]
            
            cell.snsTypeLabel.text = row.type
            cell.snsLinkLabel.text = row.address
            cell.copyButton.isHidden = true
            
            // 편집 데이터 넘기기
            cell.snsIdx = row.snsIdx
            cell.type = row.type
            cell.address = row.address
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == careerTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHistoryTableViewCell.identifier, for: indexPath) as? ProfileHistoryTableViewCell else {return UITableViewCell()}
            
            let row = careerData[indexPath.row]
            var endDate = ""
            if row.isWorking == "TRUE" { // endDate가 nil이 옴
                endDate = "현재"
            } else {
                endDate = row.endDate ?? ""
            }
            
            cell.periodLabel.text = "\(row.startDate) ~ \(endDate)"
            cell.companyLabel.text = row.company
            cell.positionLabel.text = row.position
            cell.id = 1 // 경력
            
            // 편집 데이터 넘기기
            cell.careerIdx = row.careerIdx
            cell.company = row.company
            cell.position = row.position
            cell.startDate = row.startDate
            cell.endDate = endDate
            cell.isWorking = row.isWorking
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == eduTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHistoryTableViewCell.identifier, for: indexPath) as? ProfileHistoryTableViewCell else {return UITableViewCell()}
            
            let row = eduData[indexPath.row]
            var endDate = ""
            
            if row.isLearning == "TRUE" { // endDate가 nil이 옴
                endDate = "현재"
            } else {
                endDate = row.endDate ?? ""
            }
            
            cell.companyLabel.text = row.institution
            cell.positionLabel.text = row.major
            cell.periodLabel.text = "\(row.startDate) ~ \(endDate)"
            cell.id = 2 // 교육
            
            // 편집 데이터 넘기기
            cell.careerIdx = row.educationIdx
            cell.company = row.institution
            cell.position = row.major
            cell.startDate = row.startDate
            cell.endDate = endDate
            cell.isWorking = row.isLearning
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

extension ProfileVC: SnsButtonTappedDelegate {
    func snsEditButtonDidTap(snsIdx: Int, type: String, address: String) {
        // 화면 전환
        let nextVC = ProfileInputSNSVC()
        
        // 편집 모드
        nextVC.titleLabel.text = "SNS 편집하기"
        nextVC.editButtonStackView.isHidden = false
        nextVC.saveUserProfileButton.isHidden = true
        
        var newAddress = address
        
        // SNS 유형 처리
        switch (type) {
        case "인스타그램":
            newAddress = address.removeString(target: "@")
            nextVC.instagramAtLabel.isHidden = false
            nextVC.linkTextField.placeholder = "인스타그램 아이디를 입력해주세요"
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: (nextVC.linkTextField.frame.height)))
            nextVC.linkTextField.leftView = paddingView
        case "블로그":
            print()
        case "깃허브":
            print()
        default: // 직접 입력
            nextVC.typeTextField.placeholder = "SNS 종류를 직접 입력해주세요"
            nextVC.isAutoInput = true
            nextVC.autoInputTextCountLabel.isHidden = false
        }
        
        // 값 넘기기
        nextVC.memberIdx = memberIdx
        nextVC.snsIdx = snsIdx
        nextVC.typeTextField.text = type
        nextVC.linkTextField.text = newAddress
        nextVC.autoInputTextCount = type.count

        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func copyButtonDidTap() {
        //
    }
}

extension ProfileVC: HistoryButtonTappedDelegate {
    func careerButtonDidTap(careerIdx: Int, company: String, position: String, startDate: String, endDate: String, isWorking: String) {
        // 화면 전환
        let nextVC = ProfileInputCareerVC()
        nextVC.setCurrentYear()
        
        // 편집 모드
        nextVC.titleLabel.text = "경력 편집하기"
        nextVC.editButtonStackView.isHidden = false
        nextVC.saveUserProfileButton.isHidden = true
        
        // 값 넘기기
        nextVC.memberIdx = memberIdx
        nextVC.careerIdx = careerIdx
        nextVC.companyTextField.text = company
        nextVC.positionTextField.text = position
        nextVC.startDateTextField.text = startDate
        nextVC.endDateTextField.text = endDate
        
        let start =  startDate.components(separatedBy: "/")
        nextVC.startYearValue =  start[0]
        nextVC.startMonthValue = start[1]
        let startYearIdx = nextVC.yearArray.firstIndex(of: start[0]) ?? 0
        let startMonthIdx = nextVC.monthArray.firstIndex(of: start[1]) ?? 0
        nextVC.startDatePickerView.selectRow(startYearIdx, inComponent: 0, animated: false)
        nextVC.startDatePickerView.selectRow(startMonthIdx, inComponent: 1, animated: false)
        
        
        if endDate == "현재" {
            nextVC.endYearValue = String(Int(nextVC.yearArray[0])!+1)
            nextVC.endMonthValue = nextVC.monthArray[0]
        } else {
            let end = endDate.components(separatedBy: "/")
            nextVC.endYearValue = end[0]
            nextVC.endMonthValue = end[1]
            let endYearIdx = nextVC.yearArray.firstIndex(of: end[0]) ?? 0
            let endMonthIdx = nextVC.monthArray.firstIndex(of: end[1]) ?? 0
            nextVC.endDatePickerView.selectRow(endYearIdx, inComponent: 0, animated: false)
            nextVC.endDatePickerView.selectRow(endMonthIdx, inComponent: 1, animated: false)
        }
    
        if (isWorking == "TRUE") {
            nextVC.checkIsWorkingButton.isSelected = true
            nextVC.isWorking = true
        }

        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func educationButtonDidTap(educationIdx: Int, institution: String, major: String, startDate: String, endDate: String, isLearning: String) {
        // 화면 전환
        let nextVC = ProfileInputEducationVC()
        nextVC.setCurrentYear()
        
        // 편집 모드
        nextVC.titleLabel.text = "교육 편집하기"
        nextVC.editButtonStackView.isHidden = false
        nextVC.saveUserProfileButton.isHidden = true
        
        // 값 넘기기
        nextVC.memberIdx = memberIdx
        nextVC.educationIdx = educationIdx
        nextVC.institutionTextField.text = institution
        nextVC.majorTextField.text = major
        nextVC.startDateTextField.text = startDate
        nextVC.endDateTextField.text = endDate
        
        let start =  startDate.components(separatedBy: "/")
        nextVC.startYearValue =  start[0]
        nextVC.startMonthValue = start[1]
        let startYearIdx = nextVC.yearArray.firstIndex(of: start[0]) ?? 0
        let startMonthIdx = nextVC.monthArray.firstIndex(of: start[1]) ?? 0
        nextVC.startDatePickerView.selectRow(startYearIdx, inComponent: 0, animated: false)
        nextVC.startDatePickerView.selectRow(startMonthIdx, inComponent: 1, animated: false)
        
        
        if endDate == "현재" {
            nextVC.endYearValue = String(Int(nextVC.yearArray[0])!+1)
            nextVC.endMonthValue = nextVC.monthArray[0]
        } else {
            let end = endDate.components(separatedBy: "/")
            nextVC.endYearValue = end[0]
            nextVC.endMonthValue = end[1]
            let endYearIdx = nextVC.yearArray.firstIndex(of: end[0]) ?? 0
            let endMonthIdx = nextVC.monthArray.firstIndex(of: end[1]) ?? 0
            nextVC.endDatePickerView.selectRow(endYearIdx, inComponent: 0, animated: false)
            nextVC.endDatePickerView.selectRow(endMonthIdx, inComponent: 1, animated: false)
        }
        
        if (isLearning == "TRUE") {
            nextVC.checkIsLearningButton.isSelected = true
            nextVC.isLearning = true
        }

        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
