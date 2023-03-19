//
//  CompleteRegisterVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/13.
//

import UIKit
import SnapKit
import KakaoSDKUser
import AuthenticationServices

class CompleteRegisterVC: UIViewController {
    let myCareer: RegisterCareerInfo?
    let myEducation: RegisterEducationInfo?
    var fcmToken = String()
    init(myCareer: RegisterCareerInfo?, myEducation: RegisterEducationInfo?) {
        self.myCareer = myCareer
        self.myEducation = myEducation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subviews

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가입이\n완료되었습니다"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 32)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "찹도님, 환영합니다"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 25)
        label.textColor = .mainBlack
        return label
    }()
    
    lazy var checkAgreeTermsConditionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("(필수) 이용약관 및 개인정보수집이용 동의", for: .normal)
        button.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square")?.withTintColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), renderingMode: .automatic), for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        return button
    }()
    
    lazy var presentHomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainGray
        button.isEnabled = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(presentHomeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configLayouts()
        configNickname()
        configureGestureRecognizer()
        if let token = UserDefaults.standard.string(forKey: "fcmToken") {
            self.fcmToken = token
        }
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(presentHomeButton)
        view.addSubview(checkAgreeTermsConditionsButton)

        /* Labels */
        [titleLabel,descriptionLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(55)
        }
        
        // descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        // presentHomeButton
        presentHomeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(14)
            make.height.equalTo(48)
        }
        
        // checkAgreeTermsConditionsButton
        checkAgreeTermsConditionsButton.snp.makeConstraints { make in
            make.left.equalTo(presentHomeButton.snp.left)
            make.bottom.equalTo(presentHomeButton.snp.top).offset(-25)
            make.height.equalTo(20)
        }
    }
    
    private func configNickname() {
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            switch(nickname.count){
            case 1..<5 :
                descriptionLabel.text = "\(nickname)님, 환영합니다"
            default:
                descriptionLabel.text = "\(nickname)님,\n환영합니다"
            }
        } else {
            fatalError(">>>ERROR: CompleteRegiseterVC - nickName")
        }
    }
    
    private func registerKakao() {
        let usernickname = UserDefaults.standard.string(forKey: "nickname")!
        let userprofileEmail = UserDefaults.standard.string(forKey: "profileEmail")!
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKakao")!
        let useruniEmail = UserDefaults.standard.string(forKey: "uniEmail")!
        let userstatus = "ACTIVE"

        let userInfo =  RegisterUserInfo(nickname: usernickname, profileEmail: userprofileEmail, accessToken: accessToken, uniEmail: useruniEmail, status: userstatus)
        print(userInfo)
        
         //response 받은 memberIdx로 회원가입 API post
        RegisterUserViewModel.requestRegisterUserKakao(parameter: userInfo) { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    UserDefaults.standard.set(result.result?.memberIdx, forKey: "memberIdx")
                    if self?.myCareer == nil {
                        let passMyEducation = RegisterEducationInfo(memberIdx: result.result!.memberIdx, institution: (self?.myEducation?.institution)!, major: (self?.myEducation?.major)!, isLearning: (self?.myEducation?.isLearning)!, startDate: (self?.myEducation?.startDate)!, endDate: (self?.myEducation?.endDate)!)
                        RegisterEducationViewModel.requestInputEducation(passMyEducation) { result in
                            if result {
                                self?.loginKakao()
                            }
                        }
                    } else {
                        let passMyCareer = RegisterCareerInfo(memberIdx: result.result!.memberIdx, company: (self?.myCareer?.company)!, position: (self?.myCareer?.position)!, isWorking: (self?.myCareer?.isWorking)!, startDate: (self?.myCareer?.startDate)!, endDate: (self?.myCareer?.endDate)!)
                        RegisterCareerViewModel.requestInputCareer(passMyCareer) { result in
                            if result {
                                self?.loginKakao()
                            }
                        }
                    }
                } else {
                    // TODO: 서버 에러 핸들링
                }
            case .failure:
                // 인터넷 연결 문제 알림창 띄우기
                let networkAlert = UIAlertController(title: "회원가입 실패", message: "Wi-Fi 또는 셀룰러 네트워크에 연결되어\n있는지 확인하십시오.", preferredStyle: .alert)
                let checkAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                networkAlert.addAction(checkAction)
                self?.present(networkAlert, animated: true, completion: nil)
            }
        }
    }

	private func loginKakao() {
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKakao")!
        print("accessToken: \(accessToken)")
        UserDefaults.standard.set(true, forKey: "kakaoLogin")
        UserDefaults.standard.set(false, forKey: "appleLogin")
        LoginViewModel.postLoginKakao(accessToken: accessToken, fcmToken: fcmToken, completion: { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(로그인(카카오)): \(result.message)")
                    UserDefaults.standard.set(result.result?.tokenInfo?.accessToken, forKey: "BearerToken")
                    UserDefaults.standard.set(result.result?.tokenInfo?.refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(result.result?.tokenInfo?.memberIdx, forKey: "memberIdx")
                    UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                    UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                    self?.presentHome()
                } else {
                    // TODO: 서버 에러 핸들링
                    print("실패(로그인(카카오)): \(result.message)")
                }
            case .failure(let error):
                print("실패(AF-로그인(카카오)): \(error.localizedDescription)")
                let errorView = ErrorPageView()
                errorView.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(errorView, animated: false)
            }
        })
	}
    
    private func registerApple() {
        let usernickname = UserDefaults.standard.string(forKey: "nickname")!
        let userprofileEmail = UserDefaults.standard.string(forKey: "profileEmail")!
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenApple")!
        let useruniEmail = UserDefaults.standard.string(forKey: "uniEmail")!
        let userstatus = "ACTIVE"

        let userInfo =  RegisterUserInfo(nickname: usernickname, profileEmail: userprofileEmail, accessToken: accessToken, uniEmail: useruniEmail, status: userstatus)
        print(userInfo)
        
         //response 받은 memberIdx로 회원가입 API post
        RegisterUserViewModel.requestRegisterUserApple(parameter: userInfo) { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    UserDefaults.standard.set(result.result!.memberIdx, forKey: "memberIdx")
                    if self?.myCareer == nil {
                        let passMyEducation = RegisterEducationInfo(memberIdx: result.result!.memberIdx, institution: (self?.myEducation?.institution)!, major: (self?.myEducation?.major)!, isLearning: (self?.myEducation?.isLearning)!, startDate: (self?.myEducation?.startDate)!, endDate: (self?.myEducation?.endDate)!)
                        RegisterEducationViewModel.requestInputEducation(passMyEducation) { result in
                            if result {
                                self?.loginApple()
                            }
                        }
                    } else {
                        let passMyCareer = RegisterCareerInfo(memberIdx: result.result!.memberIdx, company: (self?.myCareer?.company)!, position: (self?.myCareer?.position)!, isWorking: (self?.myCareer?.isWorking)!, startDate: (self?.myCareer?.startDate)!, endDate: (self?.myCareer?.endDate)!)
                        RegisterCareerViewModel.requestInputCareer(passMyCareer) { result in
                            if result {
                                self?.loginApple()
                            }
                        }
                    }
                } else {
                    // TODO: 서버 에러 핸들링
                    
                }
            case .failure:
                // 인터넷 연결 문제 알림창 띄우기
                let networkAlert = UIAlertController(title: "회원가입 실패", message: "Wi-Fi 또는 셀룰러 네트워크에 연결되어\n있는지 확인하십시오.", preferredStyle: .alert)
                let checkAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                networkAlert.addAction(checkAction)
                self?.present(networkAlert, animated: true, completion: nil)
            }
            
        }
    }
    
    private func loginApple() {
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenApple")!
        print("accessToken: \(accessToken)")
        UserDefaults.standard.set(false, forKey: "kakaoLogin")
        UserDefaults.standard.set(true, forKey: "appleLogin")
        LoginViewModel.postLoginApple(idToken: accessToken, fcmToken: fcmToken, completion: { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(로그인(애플)): \(result.message)")
                    UserDefaults.standard.set(result.result?.tokenInfo?.accessToken, forKey: "BearerToken")
                    UserDefaults.standard.set(result.result?.tokenInfo?.refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(result.result?.tokenInfo?.memberIdx, forKey: "memberIdx")
                    UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                    UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                    self?.presentHome()
                } else {
                    // TODO: 서버 에러 핸들링
                    print("실패(로그인(애플)): \(result.message)")
                }
            case .failure(let error):
                print("실패(AF-로그인(애플)): \(error.localizedDescription)")
                let errorView = ErrorPageView()
                errorView.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(errorView, animated: false)
            }
        })
    }
    
    private func presentHome(){
        let nextVC = TabBarController(pushProgramIdx: nil, pushProgramtype: nil)
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    @objc
    private func presentHomeButtonTapped(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "kakaoLogin") {
            print(">>kakao")
            registerKakao()
        } else if UserDefaults.standard.bool(forKey: "appleLogin") {
            print(">>apple")
             registerApple()
        }
    }
    
    @objc
    private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if checkAgreeTermsConditionsButton.isSelected {
            presentHomeButton.isEnabled = true
            UIView.animate(withDuration: 0.33) {
                self.presentHomeButton.backgroundColor = .mainBlue
            }
            let vc = ServiceTermVC()
            present(vc,animated: true)
        } else {
            presentHomeButton.isEnabled = false
            UIView.animate(withDuration: 0.33) {
                self.presentHomeButton.backgroundColor = .mainGray
            }
            
        }
    }
}

extension CompleteRegisterVC {
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewDidTap() {
        self.view.endEditing(true)
    }
}
