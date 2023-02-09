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
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 32)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "찹도님, 환영합니다"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 25)
        label.textColor = .black
        return label
    }()
    
    lazy var checkAgreeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 동의하기", for: .normal)
        button.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square")?.withTintColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), renderingMode: .automatic), for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.setTitleColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Medium, size: 14)
        
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        return button
    }()
    
    lazy var checkAgreeAgeButton: UIButton = {
        let button = UIButton()
        button.setTitle("(필수) 만 14세 이상이에요", for: .normal)
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
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(presentHomeButton)
        view.addSubview(checkAgreeAllButton)
        view.addSubview(checkAgreeAgeButton)
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
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
        
        // checkAgreeTermsConditionsButton
        checkAgreeTermsConditionsButton.snp.makeConstraints { make in
            make.left.equalTo(presentHomeButton.snp.left)
            make.bottom.equalTo(presentHomeButton.snp.top).offset(-25)
            make.height.equalTo(20)
        }
        
        // checkAgreeAgeButton
        checkAgreeAgeButton.snp.makeConstraints { make in
            make.left.equalTo(presentHomeButton.snp.left)
            make.bottom.equalTo(checkAgreeTermsConditionsButton.snp.top).offset(-2)
            make.height.equalTo(20)
        }
        
        // checkAgreeAllButton
        checkAgreeAllButton.snp.makeConstraints { make in
            make.left.equalTo(presentHomeButton.snp.left)
            make.bottom.equalTo(checkAgreeAgeButton.snp.top).offset(-2)
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
    
    private func register() {
        let usernickname = UserDefaults.standard.string(forKey: "nickname")!
        let userprofileEmail = UserDefaults.standard.string(forKey: "profileEmail")!
        let usersocialEmail = UserDefaults.standard.string(forKey: "socialEmail")!
        let useruniEmail = UserDefaults.standard.string(forKey: "uniEmail")!
        let userstatus = "ACTIVE"
        // TODO: password 추후 제거 예정
        let userpassword = "1234" //UserDefaults.standard.string(forKey: "password")!
        let userInfo =  RegisterUserInfo(nickname: usernickname, profileEmail: userprofileEmail, socialEmail: usersocialEmail, uniEmail: useruniEmail, status: userstatus, password: userpassword)
        print(userInfo)
        
         //response 받은 memberIdx로 회원가입 API post
        RegisterUserViewModel.requestRegisterUser(parameter: userInfo) { [weak self] result in
            UserDefaults.standard.set(result.memberIdx, forKey: "memberIdx")
            if self?.myCareer == nil {
                guard let passMyEducation = RegisterEducationInfo(memberIdx: result.memberIdx, institution: (self?.myEducation!.institution)!, major: self?.myEducation!.major ?? "", isLearning: self?.myEducation!.isLearning ?? "", startDate: (self?.myEducation!.startDate)!, endDate: self?.myEducation!.endDate ?? "") as? RegisterEducationInfo else {
                    return
                }
                RegisterEducationViewModel.requestInputEducation(passMyEducation) { result in
                    if result {
                        self?.login()
                    }
                }
            } else {
                guard let passMyCareer = RegisterCareerInfo(memberIdx: result.memberIdx, company: (self?.myCareer!.company)!, position: self?.myCareer!.position ?? "", isWorking: self?.myCareer!.isWorking ?? "", startDate: (self?.myCareer!.startDate)!, endDate: self?.myCareer!.endDate ?? "") as? RegisterCareerInfo else { return }
                RegisterCareerViewModel.requestInputCareer(passMyCareer) { result in
                    if result {
                        self?.login()
                    }
                }
            }
                                                            
        }
    }
	
	private func login() {
        // 임시로 uniEmail, password 사용
        //jrwedo@gachon.ac.kr
        //1234
        let useruniEmail = UserDefaults.standard.string(forKey: "uniEmail")!
        let userpassword = "1234"
        print("로그인 된 uniEmail: \(useruniEmail)")
        print("로그인 된 password: \(userpassword)")
        
        LoginViewModel.postLogin(uniEmail: useruniEmail, password: userpassword, completion: { [weak self] result in
            UserDefaults.standard.set(result.accessToken, forKey: "BearerToken")
            UserDefaults.standard.set(result.memberIdx, forKey: "memberIdx")
            self?.presentHome()
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
        // TODO: 모두 완료 후 login() 지우고, register() 활성화
        /// 현재 로그인된 정보
        /// memberIdx: 36
        /// uniEmail: seutest@gachon.ac.kr
        /// passwod: 1234
//        register()
        
        login()
    }
    
    @objc
    private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender {
        case checkAgreeAllButton:
            if checkAgreeAllButton.isSelected {
                checkAgreeAgeButton.isSelected = true
                checkAgreeTermsConditionsButton.isSelected = true
            }
            else {
                checkAgreeAgeButton.isSelected = false
                checkAgreeTermsConditionsButton.isSelected = false
            }
        case checkAgreeAgeButton:
            if !checkAgreeAgeButton.isSelected {
                checkAgreeAllButton.isSelected = false
            }
        case checkAgreeTermsConditionsButton:
            if !checkAgreeTermsConditionsButton.isSelected {
                checkAgreeAllButton.isSelected = false
            }
        default:
            print("nothing")
        }
        
        if checkAgreeAgeButton.isSelected
            && checkAgreeTermsConditionsButton.isSelected {
            checkAgreeAllButton.isSelected = true
            presentHomeButton.isEnabled = true
            presentHomeButton.backgroundColor = .mainBlue
        } else {
            presentHomeButton.isEnabled = false
            presentHomeButton.backgroundColor = .mainGray
        }
        
    }

}
