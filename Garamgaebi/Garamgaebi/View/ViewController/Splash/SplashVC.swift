//
//  SplashVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/15.
//

import UIKit

class SplashVC: UIViewController {
    
    lazy var splashView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "splashImage2"))
        return view
    }()
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메인 뷰에 삽입
        view.addSubview(splashView)
        splashView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(getFCMToken(_:)), name: Notification.Name("FCMToken"), object: nil)
        //        login()
    }
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard checkAppVersion() else {return}
		login()
	}
	
	// MARK: - Functions
	private func checkAppVersion() -> Bool {
		let storeVersion = VersionManager().latestVersion()!
//		let storeVersion = "2.1.0"
		let currentVersion = VersionManager.appVersion!
		let splitStoreVersion = storeVersion.split(separator: ".").map {$0}
		let splitCurrentVersion = currentVersion.split(separator: ".").map {$0}
		
		if splitCurrentVersion[0] < splitStoreVersion[0] || splitCurrentVersion[1] < splitStoreVersion[1] {
			let alert = UIAlertController(title: "업데이트 알림", message: "새로운 버전으로 업데이트 해주세요.", preferredStyle: UIAlertController.Style.alert)
			let destructiveAction = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default){(_) in
				VersionManager().openAppStore()
			}
			alert.addAction(destructiveAction)
			self.present(alert, animated: false)
			return false
		}
		
		return true
	}
    private func showHome() {
        let vc = TabBarController(pushProgramIdx: self.pushProgramIdx, pushProgramtype: self.pushProgramtype)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    private func showOnboarding() {
        let vc = OnboardingVC()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    private func showLogin() {
        let vc = LoginVC(pushProgramIdx: nil, pushProgramtype: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    private func login() {
        autoLogin()
    }
    
    public func autoLogin() {
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        LoginViewModel.postLoginAuto(refreshToken: refreshToken, completion: { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(자동로그인): \(result.message)")
                    UserDefaults.standard.set(result.result?.tokenInfo?.accessToken, forKey: "BearerToken")
					print(result.result?.tokenInfo?.accessToken)
                    UserDefaults.standard.set(result.result?.tokenInfo?.refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(result.result?.tokenInfo?.memberIdx, forKey: "memberIdx")
                    UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                    UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                    self?.showHome()
                } else if result.code == 2006 || result.code == 2027 || refreshToken == "LOGOUT" {
                    // 유효하지 않은 토큰의 경우 소셜로그인으로 이동 2006
                    // 리프레시토큰도 만료되었거나 -> Onboarding 건너뛰고 카카오로그인으로 2027
                    print(">>> 소셜로그인 화면으로 이동 (유효하지 않은 토큰)")
                    print("실패(자동로그인): \(result.message)")
                    self?.showLogin()
                }
                else {
                    print(">>> Onboarding 화면으로 이동 (서버오류, ex.최초로그인시에는 refreshToken이 존재하지 않음, 또는 올바르지 않은 토큰)")
                    print("실패(자동로그인): \(result.message)")
                    self?.showOnboarding()
                }
            case .failure(let error):
                print("실패(AF-자동로그인): \(error.localizedDescription)")
                let errorView = ErrorPageView()
                errorView.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(errorView, animated: false)
            }
        })
    }
    
    // fcmToken 받아오기
    @objc private func getFCMToken(_ notification: NSNotification) {
        let token: String = notification.userInfo?["token"] as! String
        UserDefaults.standard.set(token, forKey: "fcmToken")
    }
}
