//
//  ErrorPageView.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/22.
//

import Foundation

import UIKit

class ErrorPageView: UIViewController {
    
    lazy var imageView: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "networkWarning"), for: .normal)
        view.addTarget(self, action: #selector(retry), for: .touchUpInside)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "페이지를 불러올 수 없습니다"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "다시 시도해주세요"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.backgroundColor = .white
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(23)
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
    
    @objc func retry() {
        autoLogin()
    }
    
    private func showLogin() {
        let vc = LoginVC(pushProgramIdx: nil, pushProgramtype: nil)
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
    
    public func autoLogin() {
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        LoginViewModel.postLoginAuto(refreshToken: refreshToken, completion: { [weak self] result in
            switch result {
            case .success(let result):
                if result.isSuccess {
                    print("성공(자동로그인): \(result.message)")
                    UserDefaults.standard.set(result.result?.tokenInfo?.accessToken, forKey: "BearerToken")
                    UserDefaults.standard.set(result.result?.tokenInfo?.refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(result.result?.tokenInfo?.memberIdx, forKey: "memberIdx")
                    UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                    UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                    self?.navigationController?.popViewController(animated: false)
                } else if result.code == 2006 || result.code == 2027 {
                    // 유효하지 않은 토큰의 경우 소셜로그인으로 이동 2006
                    // 리프레시토큰도 만료되었거나 -> Onboarding 건너뛰고 카카오로그인으로 2027
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
                // 인터넷 연결 문제 알림창 띄우기
                let networkAlert = UIAlertController(title: "연결할 수 없음", message: "Wi-Fi 또는 셀룰러 네트워크에 연결되어\n있는지 확인하십시오.", preferredStyle: .alert)
                let checkAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                networkAlert.addAction(checkAction)
                self?.present(networkAlert, animated: true, completion: nil)
            }
        })
    }
}
