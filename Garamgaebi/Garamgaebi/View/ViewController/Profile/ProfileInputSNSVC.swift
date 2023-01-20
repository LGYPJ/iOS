//
//  ProfileInputSNSVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/19.
//

import UIKit

import Then

class ProfileInputSNSVC: UIViewController {

    // MARK: - Subviews
    lazy var subtitleLinkLabel: UILabel = {
        let label = UILabel()
        label.text = "링크"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var linkTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "https://"
        //        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        textField.autocapitalizationType = .none
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        return textField
    }()
    
    lazy var subtitleNameLabel : UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "표시할 이름을 입력해주세요 (예:블로그, 깃허브 등)"
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        textField.autocapitalizationType = .none
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        
        return textField
    }()
    
    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainBlue
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        addSubViews()
        configLayouts()
        configureNavigationBar()
        configureNavigationBarShadow()
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(linkTextField)
        view.addSubview(nameTextField)
        view.addSubview(saveUserProfileButton)
        
        
        /* Labels */
        [subtitleLinkLabel,subtitleNameLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        
        // subtitleLinkLabel
        subtitleLinkLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        // linkTextField
        linkTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLinkLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitleNameLabel
        subtitleNameLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleLinkLabel.snp.left)
            make.top.equalTo(linkTextField.snp.bottom).offset(28)
        }
        
        // nameTextField
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleNameLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalTo(linkTextField)
        }
        
        
        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
    }
    
    @objc private func saveButtonDidTap(_ sender: UIButton) {
        print("저장하기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor(hex: 0x000000).withAlphaComponent(0.8).cgColor
        sender.layer.borderWidth = 1
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
    }
    
    // TODO: NavigationBar
    // navigation bar 구성
    private func configureNavigationBar() {
        self.navigationItem.title = "SNS"
        let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.leftBarButtonItem?.action  = #selector(backBarButtonDidTap)
        backBarButtonItem.tintColor = .black
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // navigation bar shadow 설정
    private func configureNavigationBarShadow() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        
        navigationController?.navigationBar.tintColor = .clear
        
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func backBarButtonDidTap() {
        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
}
