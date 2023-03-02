//
//  LoginVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit
import SnapKit
import KakaoSDKUser

class LoginVC: UIViewController {
    
    // MARK: - Subviews
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비"
        label.textColor = .mainBlue
        label.font = UIFont.NotoSansKR(type: .Bold, size: 36)
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대생들을 위한 커뮤니티"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비에서\n가천대 선후배를 찾아봐요!"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Medium, size: 18)
        label.textColor = .mainBlack
        return label
    }()
    
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "KakaoLoginButton"), for: .normal)
        //button.adjustsImageWhenHighlighted = false
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(loginSuccessed), for: .touchUpInside)
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        //button.adjustsImageWhenHighlighted = false
        button.setTitle("APPLE", for: .normal)
        button.backgroundColor = UIColor.init(hex: 0x1C1C1C)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configLayouts()
        
        
        // TODO: 임시 kakaoLogin unlink (삭제예정)
        // kakao unlink
//        UserApi.shared.unlink {(error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("unlink() success.")
//            }
//        }
        
        
    }
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
        
        /* Labels */
        [titleLabel,subTitleLabel,descriptionLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        /* Buttons */
        
        //appleLoginButton
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
        }
        
        //kakaoLoginButton
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(53.7)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-13.2)
        }
        
        /* Labels */
        
        //titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(117)
        }
        
        //subTitleLabel
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
        
        //descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(13)
        }
    }
    
    @objc
    private func loginSuccessed(_ sender: Any) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 톡으로 로그인 성공")
                    
                    _ = oauthToken
                    /// 로그인 관련 메소드 추가
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserDefaults.standard.set(user?.kakaoAccount?.email, forKey: "socialEmail")
                            
                            let usersocialEmail = UserDefaults.standard.string(forKey: "socialEmail")!
                            
                            // 해당 socialEmail이 존재하는 계정이면 바로 로그인
                            LoginViewModel.postLogin(socialEmail: usersocialEmail, completion: { [weak self] result in
                                switch result {
                                case .success(let result):
                                    if result.isSuccess {
                                        print("성공(간편로그인): \(result.message)")
                                        UserDefaults.standard.set(result.result?.accessToken, forKey: "BearerToken")
                                        UserDefaults.standard.set(result.result?.memberIdx, forKey: "memberIdx")
                                        self?.showHome()
                                    } else {
                                        print("실패(간편로그인): \(result.message)")
                                        print(">>> 교육, 경력 기입 화면으로 이동")
                                        self?.presentNextView()
                                    }
                                case .failure(let error):
                                    print("실패(AF-간편로그인): \(error.localizedDescription)")
                                }
                            })
                            
                        }
                    }
                }
            }
        }
        else {
            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                    print("로그인 실패")
                } else {
                    print("카카오 계정으로 로그인 성공")
                    _ = oauthToken
                    /// 관련 메소드 추가
                    
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserDefaults.standard.set(user?.kakaoAccount?.email, forKey: "socialEmail")
                            let usersocialEmail = UserDefaults.standard.string(forKey: "socialEmail")!
                            
                            // 해당 socialEmail이 존재하는 계정이면 바로 로그인
                            LoginViewModel.postLogin(socialEmail: usersocialEmail, completion: { [weak self] result in
                                switch result {
                                case .success(let result):
                                    if result.isSuccess {
                                        print("성공(간편로그인): \(result.message)")
                                        UserDefaults.standard.set(result.result?.accessToken, forKey: "BearerToken")
                                        UserDefaults.standard.set(result.result?.memberIdx, forKey: "memberIdx")
                                        self?.showHome()
                                    } else {
                                        print("실패(간편로그인): \(result.message)")
                                        print(">>> 교육, 경력 기입 화면으로 이동")
                                        self?.presentNextView()
                                    }
                                case .failure(let error):
                                    print("실패(AF-간편로그인): \(error.localizedDescription)")
                                }
                            })
                            
                            
                            //TODO: socialEmail -> identifier로 수정 후 postLogin의 socialEmail을 identifier로 수정
//                            UserDefaults.standard.set(user?.id, forKey: "userIdentifier")
//                            let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier")!
//                            print("identifier: \(userIdentifier)")
//
//                            LoginViewModel.postLogin(socialEmail: userIdentifier, completion: { [weak self] result in
//                                switch result {
//                                case .success(let result):
//                                    if result.isSuccess {
//                                        print("성공(간편로그인): \(result.message)")
//                                        UserDefaults.standard.set(result.result?.accessToken, forKey: "BearerToken")
//                                        UserDefaults.standard.set(result.result?.memberIdx, forKey: "memberIdx")
//                                        self?.showHome()
//                                    } else {
//                                        print("실패(간편로그인): \(result.message)")
//                                        print(">>> 교육, 경력 기입 화면으로 이동")
//                                        self?.presentNextView()
//                                    }
//                                case .failure(let error):
//                                    print("실패(AF-간편로그인): \(error.localizedDescription)")
//                                }
//                            })
                            
                        }
                    }
                    
                }
            }
        }
        
    }
    
    private func presentNextView(){
        let nextVC = UniEmailAuthVC()
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    private func showHome() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
}
