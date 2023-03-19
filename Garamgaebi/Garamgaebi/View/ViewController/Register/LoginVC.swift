//
//  LoginVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit
import SnapKit
import KakaoSDKUser
import AuthenticationServices

class LoginVC: UIViewController {
    
    var fcmToken = String()
    var pushProgramIdx: Int?
    var pushProgramtype: String?
    init(pushProgramIdx: Int?, pushProgramtype: String?) {
        self.pushProgramIdx = pushProgramIdx
        self.pushProgramtype = pushProgramtype
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(loginSuccessed), for: .touchUpInside)
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        //button.adjustsImageWhenHighlighted = false
        button.setImage(UIImage(named: "AppleLogin"), for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configLayouts()

        if let token = UserDefaults.standard.string(forKey: "fcmToken") {
            self.fcmToken = token
        }
        
        // TODO: 임시 kakaoLogin unlink (삭제예정)
        // kakao unlink
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }

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
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
        }
        
        //kakaoLoginButton
        kakaoLoginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
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
                    guard let accessToken = oauthToken?.accessToken else { return }
                    UserDefaults.standard.set(accessToken, forKey: "accessTokenKakao")
                    UserDefaults.standard.set(true, forKey: "kakaoLogin")
                    UserDefaults.standard.set(false, forKey: "appleLogin")
                    LoginViewModel.postLoginKakao(accessToken: accessToken, fcmToken: self.fcmToken, completion: { [weak self] result in
                        switch result {
                        case .success(let result):
                            if result.isSuccess {
                                print("성공(간편로그인(카카오)): \(result.message)")
                                UserDefaults.standard.set(result.result?.tokenInfo?.accessToken, forKey: "BearerToken")
                                UserDefaults.standard.set(result.result?.tokenInfo?.refreshToken, forKey: "refreshToken")
                                UserDefaults.standard.set(result.result?.tokenInfo?.memberIdx, forKey: "memberIdx")
                                UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                                UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                                self?.showHome()
                            } else {
                                print("실패(간편로그인(카카오)): \(result.message)")
                                print(">>> 교육, 경력 기입 화면으로 이동")
                                self?.presentNextView()
                            }
                        case .failure(let error):
                            print("실패(AF-간편로그인(카카오)): \(error.localizedDescription)")
                            // 인터넷 연결 문제 알림창 띄우기
                            let networkAlert = UIAlertController(title: "연결할 수 없음", message: "Wi-Fi 또는 셀룰러 네트워크에 연결되어\n있는지 확인하십시오.", preferredStyle: .alert)
                            let checkAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                            networkAlert.addAction(checkAction)
                            self?.present(networkAlert, animated: true, completion: nil)
                        }
                    })
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
                    guard let accessToken = oauthToken?.accessToken else { return }
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(true, forKey: "kakaoLogin")
                    UserDefaults.standard.set(false, forKey: "appleLogin")
                    LoginViewModel.postLoginKakao(accessToken: accessToken, fcmToken: self.fcmToken,completion: { [weak self] result in
                        switch result {
                        case .success(let result):
                            if result.isSuccess {
                                print("성공(간편로그인(카카오)): \(result.message)")
                                UserDefaults.standard.set(result.result?.tokenInfo?.accessToken, forKey: "BearerToken")
                                UserDefaults.standard.set(result.result?.tokenInfo?.refreshToken, forKey: "refreshToken")
                                UserDefaults.standard.set(result.result?.tokenInfo?.memberIdx, forKey: "memberIdx")
                                UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                                UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                                self?.showHome()
                            } else {
                                print("실패(간편로그인(카카오)): \(result.message)")
                                print(">>> 교육, 경력 기입 화면으로 이동")
                                self?.presentNextView()
                            }
                        case .failure(let error):
                            print("실패(AF-간편로그인(카카오)): \(error.localizedDescription)")
                            // 인터넷 연결 문제 알림창 띄우기
                            let networkAlert = UIAlertController(title: "연결할 수 없음", message: "Wi-Fi 또는 셀룰러 네트워크에 연결되어\n있는지 확인하십시오.", preferredStyle: .alert)
                            let checkAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                            networkAlert.addAction(checkAction)
                            self?.present(networkAlert, animated: true, completion: nil)
                        }
                    })
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
        let vc = TabBarController(pushProgramIdx: nil, pushProgramtype: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    //애플 소셜 로그인
    @objc func appleLogin(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let tokenStr = String(data: idToken, encoding: .utf8)
            guard let idTokenString = tokenStr else { return }
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(String(describing: idTokenString))")
            
            UserDefaults.standard.set(idTokenString, forKey: "accessTokenApple")
            UserDefaults.standard.set(false, forKey: "kakaoLogin")
            UserDefaults.standard.set(true, forKey: "appleLogin")
            LoginViewModel.postLoginApple(idToken: idTokenString, fcmToken: self.fcmToken) { [weak self] result in
                switch result {
                case .success(let result):
                    if result.isSuccess {
                        print("성공(간편로그인(애플)): \(result.message)")
                        UserDefaults.standard.set(result.result?.tokenInfo?.accessToken, forKey: "BearerToken")
                        UserDefaults.standard.set(result.result?.tokenInfo?.refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.set(result.result?.tokenInfo?.memberIdx, forKey: "memberIdx")
                        UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                        UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                        self?.showHome()
                    } else {
                        print("실패(간편로그인(애플)): \(result.message)")
                        print(">>> 교육, 경력 기입 화면으로 이동")
                        self?.presentNextView()
                    }
                case .failure(let error):
                    print("실패(AF-간편로그인(애플)): \(error.localizedDescription)")
                }
            }
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
