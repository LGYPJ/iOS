//
//  CompleteRegisterVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/13.
//

import UIKit
import SnapKit

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
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")!
        let useruniEmail = UserDefaults.standard.string(forKey: "uniEmail")!
        let userstatus = "ACTIVE"
        // TODO: password 추후 제거 예정

        let userInfo =  RegisterUserInfo(nickname: usernickname, profileEmail: userprofileEmail, accessToken: accessToken, uniEmail: useruniEmail, status: userstatus)
        print(userInfo)
        
         //response 받은 memberIdx로 회원가입 API post
        RegisterUserViewModel.requestRegisterUser(parameter: userInfo) { [weak self] result in
            UserDefaults.standard.set(result.memberIdx, forKey: "memberIdx")
            if self?.myCareer == nil {
                let passMyEducation = RegisterEducationInfo(memberIdx: result.memberIdx, institution: (self?.myEducation?.institution)!, major: (self?.myEducation?.major)!, isLearning: (self?.myEducation?.isLearning)!, startDate: (self?.myEducation?.startDate)!, endDate: (self?.myEducation?.endDate)!)
                RegisterEducationViewModel.requestInputEducation(passMyEducation) { result in
                    if result {
                        self?.login()
                    }
                }
            } else {
                let passMyCareer = RegisterCareerInfo(memberIdx: result.memberIdx, company: (self?.myCareer?.company)!, position: (self?.myCareer?.position)!, isWorking: (self?.myCareer?.isWorking)!, startDate: (self?.myCareer?.startDate)!, endDate: (self?.myCareer?.endDate)!)
                RegisterCareerViewModel.requestInputCareer(passMyCareer) { result in
                    if result {
                        self?.login()
                    }
                }
            }
                                                            
        }
    }
	
	private func login() {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")!
        print("accessToken: \(accessToken)")

        LoginViewModel.postLoginKakao(accessToken: accessToken, fcmToken: fcmToken, completion: { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(로그인): \(result.message)")
                    UserDefaults.standard.set(result.result?.accessToken, forKey: "BearerToken")
                    UserDefaults.standard.set(result.result?.refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(result.result?.memberIdx, forKey: "memberIdx")
                    self?.presentHome()
                } else {
                    print("실패(로그인): \(result.message)")
                    print("버튼 다시 눌러보세요")
                }
            case .failure(let error):
                print("실패(AF-로그인): \(error.localizedDescription)")
            }
        })
	}
    
    private func presentHome(){
        let nextVC = TabBarController()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    @objc
    private func presentHomeButtonTapped(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "kakaoLogin") {
            registerKakao()
        } else if UserDefaults.standard.bool(forKey: "appleLogin") {
            // registerApple
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
