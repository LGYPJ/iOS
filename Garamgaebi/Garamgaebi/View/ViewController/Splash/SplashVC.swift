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
        if UserDefaults.standard.bool(forKey: "kakaoLogin") {
           kakaoLogin()
        } else if UserDefaults.standard.bool(forKey: "appleLogin") {
            // TODO: apple 자동로그인 구현 예정
        }
    }
    
    public func kakaoLogin() {
        
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        print("accessToken: \(accessToken)")
        
        LoginViewModel.postLogin(accessToken: accessToken, completion: { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(자동로그인): \(result.message)")
                    UserDefaults.standard.set(result.result?.accessToken, forKey: "BearerToken")
                    UserDefaults.standard.set(result.result?.memberIdx, forKey: "memberIdx")
                    self?.showHome()
                } else {
                    print(">>> Onboarding 화면으로 이동")
                    print("실패(자동로그인): \(result.message)")
                    self?.showOnboarding()
                }
            case .failure(let error):
                print("실패(AF-자동로그인): \(error.localizedDescription)")
                let errorView = ErrorPageView()
                errorView.modalPresentationStyle = .fullScreen
                self?.present(errorView, animated: false)
            }
        })
    }
    
}
