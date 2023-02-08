//
//  OtherProfileVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/02/06.
//

import UIKit

import SnapKit
import Then
import Alamofire

class OtherProfileVC: UIViewController {
    
    // MARK: - Properties

    // TODO: memberIdx 넘겨받기
    var memberIdx: Int // 넘겨받은 memberIdx

    let token = UserDefaults.standard.string(forKey: "BearerToken")
    
    // MARK: - Subviews
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필"
        label.textColor = UIColor.mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor.mainBlack
        button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        
        return button
    }()
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.cornerRadius = 12
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textColor = .mainBlack
        $0.isUserInteractionEnabled = false
    }
    
    // 하단 버튼
    // SNS
    let snsTopRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.backgroundColor = UIColor(hex: 0xF5F5F5).cgColor
    }
    let snsTitleLabel = UILabel().then {
        $0.text = "SNS"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
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

    
    // 경력
    let careerTopRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.backgroundColor = UIColor(hex: 0xF5F5F5).cgColor
    }
    let careerTitleLabel = UILabel().then {
        $0.text = "경력"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
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
    
    // 교육
    let eduTopRadiusView = UIView().then {
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.backgroundColor = UIColor(hex: 0xF5F5F5).cgColor
    }
    let eduTitleLabel = UILabel().then {
        $0.text = "교육"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
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
    
    // MARK: - LifeCycles
    
    init(memberIdx: Int) {
        self.memberIdx = memberIdx
        super.init(nibName: nil, bundle: nil)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayouts()
        
        // 서버 통신
        getOtherInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 서버 통신
        //        print("1: viewWillAppear()")
        self.getSnsData()
        self.getCareerData()
        self.getEducationData()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserHistoryBox()
    }
    
    
    // MARK: - Functions
    func configureLayouts() {
        
        // addSubview - HeaderView
        view.addSubview(headerView)
        [titleLabel, backButton].forEach { headerView.addSubview($0) }
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        // scroll - profile
        [profileImageView, profileStackView, introduceTextField]
            .forEach {scrollView.addSubview($0)}
        
        // scroll - add
        [snsTopRadiusView, snsTitleLabel, snsBottomRadiusView,
         careerTopRadiusView, careerTitleLabel, careerBottomRadiusView,
         eduTopRadiusView, eduTitleLabel, eduBottomRadiusView].forEach {scrollView.addSubview($0)}
        
        // history
        snsBottomRadiusView.addSubview(snsTableView)
        careerBottomRadiusView.addSubview(careerTableView)
        eduBottomRadiusView.addSubview(eduTableView)
        
        // layer
        //headerView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // backButton
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
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
        
        
        // 하단
        // SNS
        snsTopRadiusView.snp.makeConstraints {
            $0.top.equalTo(introduceTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(introduceTextField)
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
        }
        
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
    }
    
    
    // MARK: - [GET] 가람개비 유저 프로필 정보
    func getOtherInfo() {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/\(memberIdx)"
        
        let authorization = "Bearer \(token ?? "")"
        
        // http 요청 헤더 지정
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": authorization
        ]
        
        // httpBody에 parameters 추가
        AF.request(
            url, // 주소
            method: .get, // 전송 타입
            encoding: JSONEncoding.default, // 인코딩 스타일
            headers: header // 헤더 지정
        )
        .validate() // statusCode:  200..<300
        .responseDecodable(of: ProfileResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
//                    print("성공(\(self.memberIdx) 프로필): \(response.message)")
                    let result = response.result
                    
                    // 값 넣어주기
                    self.nameLabel.text = result.nickName
                    self.orgLabel.text = result.belong
                    self.emailLabel.text = result.profileEmail
                    if let userIntro = result.content { // 자기소개가 있으면
                        self.introduceTextField.text = userIntro
                    } else {
                        self.introduceTextField.text = ""
                    }
//                 // 프로필 이미지
                    if let urlString = result.profileUrl {
                        let url = URL(string: urlString)

                        self.profileImageView.kf.indicatorType = .activity
                        self.profileImageView.kf.setImage(with: url)
                    }
//                    completion(result)
                } else {
                    // 통신은 정상적으로 됐으나(200), error발생
                    print("실패(\(self.memberIdx) 프로필): \(response.message)")
                }
            case .failure(let error):
                // 실제 HTTP에러 404 또는 디코드 에러?
                print("실패(AF-\(self.memberIdx) 프로필): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [GET] SNS 조회
    func getSnsData() {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/sns/\(memberIdx)"
        
        let authorization = "Bearer \(token ?? "")"
        
        // http 요청 헤더 지정
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Authorization": authorization
        ]
        
        // httpBody에 parameters 추가
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: SnsResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
//                    print("성공(SNS조회): \(response.message)")
                    let result = response.result

                    let snsData = SnsData.shared
                    
                    // 값 넣어주기
                    snsData.snsDataModel = result
//                    print("받은 SNS: \(snsData.snsDataModel.count)")
                    self.snsTableView.reloadData()
                    
                } else {
                    print("실패(SNS조회): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-SNS조회): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [GET] Career 조회
    func getCareerData() {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/career/\(memberIdx)"
        
        let authorization = "Bearer \(token ?? "")"
        
        // http 요청 헤더 지정
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Authorization": authorization
        ]
        
        // httpBody에 parameters 추가
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: CareerResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
//                    print("성공(Career조회): \(response.message)")
                    let result = response.result

                    let careerData = CareerData.shared
                    
                    // 값 넣어주기
                    careerData.careerDataModel = result
//                    print("받은 Career: \(careerData.careerDataModel.count)")
                    self.careerTableView.reloadData()
                    
                } else {
                    print("실패(Career조회): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Career조회): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [GET] Education 조회
    func getEducationData() {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/education/\(memberIdx)"
        
        let authorization = "Bearer \(token ?? "")"
        
        // http 요청 헤더 지정
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Authorization": authorization
        ]
        
        // httpBody에 parameters 추가
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: EducationResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
//                    print("성공(Education조회): \(response.message)")
                    let result = response.result

                    let eduData = EducationData.shared
                    
                    // 값 넣어주기
                    eduData.educationDataModel = result
//                    print("받은 Education: \(edudata.educationDataModel.count)")
                    self.eduTableView.reloadData()
                    
                } else {
                    print("실패(Education조회): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Education조회): \(error.localizedDescription)")
            }
        }
    }
    
    //TODO: 없을 때는 안 보여주기
    private func showUserHistoryBox() {
        // sns
        let snsCount = SnsData.shared.snsDataModel.count
        snsTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(snsCount * 41)
        }
        
        // career
        let careerCount = CareerData.shared.careerDataModel.count
        careerTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(careerCount * 65)
        }
        
        // education
        let eduCount = EducationData.shared.educationDataModel.count
        eduTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(eduCount * 65)
        }
        
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Extension
extension OtherProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 저장된 데이터 가져오기
        let snsDataModel = SnsData.shared.snsDataModel
        let careerDataModel = CareerData.shared.careerDataModel
        let eduDataModel = EducationData.shared.educationDataModel
        
        if tableView == snsTableView {
//            print("SNS 개수: \(snsDataModel.count)")
            return snsDataModel.count
        }
        else if tableView == careerTableView {
//            print("Career 개수: \(careerDataModel.count)")
            return careerDataModel.count
        }
        else if tableView == eduTableView {
//            print("Edu 개수: \(eduDataModel.count)")
            return eduDataModel.count
        }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == snsTableView { return 41 }
        else { return 65 }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 저장된 데이터 가져오기
        let snsDataModel = SnsData.shared.snsDataModel
        let careerDataModel = CareerData.shared.careerDataModel
        let eduDataModel = EducationData.shared.educationDataModel
        
        
        if tableView == snsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSNSTableViewCell.identifier, for: indexPath) as? ProfileSNSTableViewCell else { return UITableViewCell()}
            cell.snsLabel.text = snsDataModel[indexPath.row].address
            cell.editButton.setImage(UIImage(named: "ProfileCopy"), for: .normal)
            
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == careerTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHistoryTableViewCell.identifier, for: indexPath) as? ProfileHistoryTableViewCell else {return UITableViewCell()}
            
            let row = careerDataModel[indexPath.row]
            
            cell.companyLabel.text = row.company
            cell.positionLabel.text = row.position
            cell.periodLabel.text = "\(row.startDate) ~ \(row.endDate)"
            cell.editButton.isHidden = true
  
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == eduTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHistoryTableViewCell.identifier, for: indexPath) as? ProfileHistoryTableViewCell else {return UITableViewCell()}
            
            let row = eduDataModel[indexPath.row]
//            print(row.institution)
            cell.companyLabel.text = row.institution
            cell.positionLabel.text = row.major
            cell.periodLabel.text = "\(row.startDate) ~ \(row.endDate)"
            cell.editButton.isHidden = true
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
}

