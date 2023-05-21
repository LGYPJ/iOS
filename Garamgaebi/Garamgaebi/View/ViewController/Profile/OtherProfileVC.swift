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
import Kingfisher

class OtherProfileVC: UIViewController {
    
    // MARK: - Properties
    var memberIdx: Int // 넘겨받은 memberIdx

    let token = UserDefaults.standard.string(forKey: "BearerToken")
    
    var snsData: [SnsResult] = []
    var careerData: [CareerResult] = []
    var eduData: [EducationResult] = []
    
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
    
    lazy var scrollView = UIScrollView()
    
    lazy var contentView = UIView()
    
    lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
        $0.image = UIImage(named: "DefaultProfileImage")
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
        $0.clipsToBounds = true
        $0.textAlignment = .left
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.cornerRadius = 12
    }
    
    /* 하단 히스토리 박스 */
    // SNS
    lazy var snsHistoryBox = UIView().then {
        $0.profileHistoryBox(title: "SNS")
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
    
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        view.register(ProfileSNSTableViewCell.self, forCellReuseIdentifier: ProfileSNSTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self

        return view
    }()

    
    // 경력
    lazy var careerHistoryBox = UIView().then {
        $0.profileHistoryBox(title: "경력")
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
        
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        view.register(ProfileHistoryTableViewCell.self, forCellReuseIdentifier: ProfileHistoryTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self

        return view
    }()
    
    // 교육
    lazy var eduHistoryBox = UIView().then {
        $0.profileHistoryBox(title: "교육")
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
        
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        view.register(ProfileHistoryTableViewCell.self, forCellReuseIdentifier: ProfileHistoryTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    // 에러
    lazy var errorImageView = UIImageView().then {
        $0.image = UIImage(named: "AlertImage")
    }
    lazy var errorTitle = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.textColor = .mainBlack
        $0.textAlignment = .center
        $0.text = "사용자를 찾을 수 없습니다"
    }
    lazy var errorDesc = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        $0.textColor = .mainBlack
        $0.textAlignment = .center
        $0.text = "탈퇴하거나 차단된 사용자입니다"
    }
    lazy var errorMsgStackView = UIStackView().then {
        [errorTitle, errorDesc].forEach($0.addArrangedSubview(_:))
        $0.axis = .vertical
    }
    
    // MARK: - LifeCycles
    init(memberIdx: Int) {
        self.memberIdx = memberIdx
        super.init(nibName: nil, bundle: nil)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayouts()
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        // 서버 통신
        self.getOtherInfo()
        
        self.getSnsData { [weak self] result in
            self?.snsData = result
            self?.showSnsTableView()
            self?.snsTableView.reloadData()
        }
        self.getCareerData { [weak self] result in
            self?.careerData = result
            self?.showCareerTableView()
            self?.careerTableView.reloadData()
        }
        self.getEducationData { [weak self] result in
            self?.eduData = result
            self?.showEducationTableView()
            self?.eduTableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    func configureLayouts() {
        
        // addSubview - HeaderView
        view.addSubview(headerView)
        [titleLabel, backButton].forEach { headerView.addSubview($0) }
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        // scroll - profile
        [profileImageView, profileStackView, introduceLabel]
            .forEach {scrollView.addSubview($0)}
        
        // scroll - historyBox
        [snsHistoryBox, careerHistoryBox, eduHistoryBox].forEach {scrollView.addSubview($0)}
        
        // history
        snsHistoryBox.addSubview(snsTableView)
        careerHistoryBox.addSubview(careerTableView)
        eduHistoryBox.addSubview(eduTableView)
        
        // error
        [errorImageView, errorMsgStackView].forEach {
            view.addSubview($0)
        }
        
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
    }
    
    @objc func emailLabelDidTap() {
        guard let copyString = emailLabel.text else { return }
        UIPasteboard.general.string = copyString
        showToast(message: "클립보드에 복사되었습니다")
    }
    
    
    // MARK: - [GET] 가람개비 유저 프로필 정보
    func getOtherInfo() {

        let url = "\(Constants.apiUrl)/profile/\(memberIdx)"
        
        AF.request(
            url,
            method: .get,
            interceptor: MyRequestInterceptor()
        )
        .validate()
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
                        
                        self.profileImageView.backgroundColor = .mainLightGray
                        self.profileImageView.kf.setImage(with: url, options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            //.transition(.fade(0.5)),
                            .fromMemoryCacheOrRefresh
                        ])
                    } else {
                        self.profileImageView.image = UIImage(named: "DefaultProfileImage")
                    }
                } else {
                    print("실패(\(self.memberIdx) 프로필): \(response.message)")
                    if (response.code == 2001) { // 존재하지 않는 회원
                        self.showErrorView()
                    }
                }
            case .failure(let error):
                print("실패(AF-\(self.memberIdx) 프로필): \(error.localizedDescription)")
                self.errorTitle.text = "페이지를 불러올 수 없습니다"
                self.errorDesc.text = "다시 시도해주세요"
                self.showErrorView()
            }
        }
    }
    
    // MARK: - [GET] SNS 조회
    func getSnsData(completion: @escaping (([SnsResult])) -> Void) {
        
        // http 요청 주소 지정
        let url = "\(Constants.apiUrl)/profile/sns/\(memberIdx)"
        
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
                    let result = response.result
                    self.snsHistoryBox.snp.makeConstraints { /// SNS
                        $0.top.equalTo(self.introduceLabel.snp.bottom).offset(16)
                        $0.leading.trailing.equalTo(self.introduceLabel)
                    }
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
    func getCareerData(completion: @escaping (([CareerResult])) -> Void) {
        
        // http 요청 주소 지정
        let url = "\(Constants.apiUrl)/profile/career/\(memberIdx)"

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

                    let result = response.result
                    self.careerHistoryBox.snp.makeConstraints { /// 경력
                        $0.top.equalTo(self.snsHistoryBox.snp.bottom).offset(16)
                        $0.leading.trailing.equalTo(self.snsHistoryBox)
                    }
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
    func getEducationData(completion: @escaping (([EducationResult])) -> Void) {
        
        let url = "\(Constants.apiUrl)/profile/education/\(memberIdx)"
        
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

                    let result = response.result
                    self.eduHistoryBox.snp.makeConstraints { /// 교육
                        $0.top.equalTo(self.careerHistoryBox.snp.bottom).offset(16)
                        $0.leading.trailing.equalTo(self.careerHistoryBox)
                        $0.bottom.equalTo(self.scrollView).inset(16)
                    }
                    completion(result)
                    
                } else {
                    print("실패(Education조회): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Education조회): \(error.localizedDescription)")
            }
        }
    }
    
    private func showSnsTableView() {
        let snsCount = snsData.count
        
        if (snsCount == 0) {
            snsHistoryBox.isHidden = true
            snsHistoryBox.snp.makeConstraints {
                $0.top.equalTo(introduceLabel.snp.bottom)
                $0.height.equalTo(0)
            }
        } else {
            snsTableView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(47) // 헤더 크기
                $0.leading.trailing.equalToSuperview().inset(1)
                $0.bottom.equalToSuperview().inset(0.5)
                $0.height.equalTo(snsCount * 65)
            }
        }
    }
    private func showCareerTableView() {
        let careerCount = careerData.count
        
        if (careerCount == 0) {
            careerHistoryBox.isHidden = true
            careerHistoryBox.snp.makeConstraints {
                $0.top.equalTo(snsHistoryBox.snp.bottom)
                $0.height.equalTo(0)
            }
        } else {
            careerTableView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(47) // 헤더 크기
                $0.leading.trailing.equalToSuperview().inset(1)
                $0.bottom.equalToSuperview().inset(0.5)
                $0.height.equalTo(careerCount * 90)
            }
        }
    }
    private func showEducationTableView() {
        let eduCount = eduData.count
        
        if (eduCount == 0) {
            eduHistoryBox.isHidden = true
            eduHistoryBox.snp.makeConstraints {
                $0.top.equalTo(careerHistoryBox.snp.bottom)
                $0.height.equalTo(0)
            }
        } else {
            eduTableView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(47) // 헤더 크기
                $0.leading.trailing.equalToSuperview().inset(1)
                $0.bottom.equalToSuperview().inset(0.5)
                $0.height.equalTo(eduCount * 90)
            }
        }
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
	
	// sns label 탭 시 해당 sns 웹뷰 띄움
	@objc private func didTapSnsInstagramLabel(gesture: SnsTapGestureRecognizer) {
		if gesture.type == "인스타그램" {
			guard var text = gesture.text else {return}
			text.remove(at: text.startIndex)
			let url = URL(string: "https://www.instagram.com/\(text)/")!
			UIApplication.shared.open(url)
		} else {
			guard let text = gesture.text,
				  let url = URL(string: text) else {return}
			UIApplication.shared.open(url)
		}
		
		
	}
}
// MARK: - Extension
extension OtherProfileVC: UITableViewDataSource, UITableViewDelegate {
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
            
            let type = snsData[indexPath.row].type
			let snsAddress = snsData[indexPath.row].address
            cell.snsTypeLabel.text = type
            cell.snsLinkLabel.text = snsAddress
            cell.editButton.isHidden = true
			
			let tapGesture = SnsTapGestureRecognizer(target: self, action: #selector(didTapSnsInstagramLabel))
			tapGesture.type = type
			tapGesture.text = snsAddress
			cell.snsLinkLabel.addGestureRecognizer(tapGesture)

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
            
            cell.companyLabel.text = row.company
            cell.positionLabel.text = row.position
            cell.periodLabel.text = "\(row.startDate) ~ \(endDate)"
            cell.editButton.isHidden = true
  
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
            cell.editButton.isHidden = true
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-100, width: 180, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 0.8
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showErrorView() {
        self.scrollView.snp.removeConstraints()
        self.errorImageView.snp.makeConstraints {
            $0.height.width.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.errorMsgStackView.snp.top).offset(-16)
        }
        self.errorMsgStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
            $0.width.equalTo(380)
        }
    }
}

extension OtherProfileVC: SnsButtonTappedDelegate {
    func snsEditButtonDidTap(snsIdx: Int, type: String, address: String) {
        // ProfileVC(내프로필)에 쓰이는 것이니 무시해도 됨
    }
    
    func copyButtonDidTap() {
        showToast(message: "클립보드에 복사되었습니다")
    }
}

extension OtherProfileVC: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
