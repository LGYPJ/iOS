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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메인 뷰에 삽입
        view.addSubview(splashView)
        splashView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        view.backgroundColor = .white
        
        //        login()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        login()
        
    }
    
    // MARK: - Functions
    
    private func showHome() {
        let vc = TabBarController()
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
    
    private func login() {
        autoLogin()
    }
    
    public func autoLogin() {
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        
        LoginViewModel.postLoginAuto(refreshToken: "refreshToken", completion: { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(자동로그인): \(result.message)")
                    UserDefaults.standard.set(result.result?.accessToken, forKey: "BearerToken")
                    UserDefaults.standard.set(result.result?.refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(result.result?.memberIdx, forKey: "memberIdx")
                    self?.showHome()
                } else {
                    print(">>> Onboarding 화면으로 이동")
                    print("실패(자동로그인): \(result.message)")
                    self?.showOnboarding()
                }
            case .failure(let error):
                // TODO: 아래와 같음
                // 경우 1 -> 리프레시토큰도 만료되었거나 -> Onboarding 건너뛰고 카카오로그인으로
                // 경우 2 -> 네트워킹 이슈 아래와 같음
                print("실패(AF-자동로그인): \(error.localizedDescription)")
                let errorView = ErrorPageView()
                errorView.modalPresentationStyle = .fullScreen
                self?.present(errorView, animated: false)
            }
        })
    }
    
}
