//
//  LoginVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit
import SnapKit

class LoginVC: UIViewController {
    
    // MARK: - Subviews
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비"
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 36)
        return label
    }()

    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대생들을 위한 커뮤니티"
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비에서\n가천대 선후배를 찾아봐요!"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Medium, size: 18)
        label.textColor = .black
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
        
        // UniEmailAuthVC로 화면전환
        let nextVC = UniEmailAuthVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
        
    }
    
}
