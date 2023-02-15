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
        
        // 일단 그냥 로그인
        login()
        
        //TODO: 로그아웃 상태이면 onboarding으로 넘겨주기
        /*
         
         
         
         
         
         
         */
    }
    
    // MARK: - Functions
    
    private func showHome() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    private func login() {
        let useruniEmail = UserDefaults.standard.string(forKey: "uniEmail")!
        let userpassword = "1234"
        print("로그인 된 uniEmail: \(useruniEmail)")
        print("로그인 된 password: \(userpassword)")
        
        LoginViewModel.postLogin(uniEmail: useruniEmail, password: userpassword, completion: { [weak self] result in
            UserDefaults.standard.set(result.accessToken, forKey: "BearerToken")
            UserDefaults.standard.set(result.memberIdx, forKey: "memberIdx")
            self?.showHome()
        })
    }
}
