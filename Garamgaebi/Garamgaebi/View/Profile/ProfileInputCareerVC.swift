//
//  ProfileInputCareerVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/15.
//

import UIKit

import Then

class ProfileInputCareerVC: UIViewController {

    // MARK: - Subviews
    lazy var subtitleCompanyLabel: UILabel = {
        let label = UILabel()
        label.text = "회사"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var companyTextField: UITextField = {
        let textField = UITextField()
        
//        textField.addLeftPadding()
        textField.placeholder = "회사명을 입력해주세요"
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

    lazy var subtitlePositionLabel : UILabel = {
        let label = UILabel()
        label.text = "직함"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        
        return label
    }()

    lazy var positionTextField: UITextField = {
        let textField = UITextField()

        textField.placeholder = "직함을 입력해주세요 (예: 백엔드 개발자)"
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

    lazy var subtitleWorkingDateLabel: UILabel = {
        let label = UILabel()
        label.text = "재직 기간"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()

    lazy var startDateTextField: UITextField = {
        let textField = UITextField()

        // textField.addLeftPadding()
        textField.placeholder = "시작년월"
        // textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1

        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)

        return textField
    }()

    lazy var betweenTildLabel: UIButton = {
        let button = UIButton()
        button.setTitle("~", for: .normal)
        button.setTitleColor(.mainGray, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.isEnabled = false
        return button
    }()

    lazy var endDateTextField: UITextField = {
        let textField = UITextField()

        // textField.addLeftPadding()
        textField.placeholder = "종료년월"
        //textField.setPlaceholderColor(.mainGray)
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

    lazy var checkIsWorkingButton: UIButton = {
        let button = UIButton()
        button.setTitle("재직 중", for: .normal)
        button.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square")?.withRenderingMode(.automatic), for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)

        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        return button
    }()

    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainBlue
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapSaveBtn), for: .touchUpInside)
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
        view.addSubview(companyTextField)
        view.addSubview(positionTextField)
        view.addSubview(startDateTextField)
        view.addSubview(endDateTextField)
        view.addSubview(betweenTildLabel)
        view.addSubview(checkIsWorkingButton)
        view.addSubview(saveUserProfileButton)


        /* Labels */
        [subtitleCompanyLabel,subtitlePositionLabel,subtitleWorkingDateLabel].map {
            view.addSubview($0)
        }
    }

    func configLayouts() {
        
        // subtitleCompanyLabel
        subtitleCompanyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }

        // companyTextField
        companyTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleCompanyLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }

        // subtitlePositionLabel
        subtitlePositionLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleCompanyLabel.snp.left)
            make.top.equalTo(companyTextField.snp.bottom).offset(28)
        }

        // positionTextField
        positionTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitlePositionLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalTo(companyTextField)
        }

        // subtitleWorkingDateLabel
        subtitleWorkingDateLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleCompanyLabel.snp.left)
            make.top.equalTo(positionTextField.snp.bottom).offset(28)
        }

        // betweenTildLabel
        betweenTildLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(38)
            make.height.equalTo(48)
            make.top.equalTo(subtitleWorkingDateLabel.snp.bottom).offset(4)
        }

        // startDateTextField
        startDateTextField.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.top)
            make.height.equalTo(48)
            make.left.equalTo(subtitleCompanyLabel.snp.left)
            make.right.equalTo(betweenTildLabel.snp.left)
        }

        // endDateTextField
        endDateTextField.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.top)
            make.height.equalTo(48)
            make.left.equalTo(betweenTildLabel.snp.right)
            make.right.equalToSuperview().inset(16)
        }

        //checkIsWorkingButton
        checkIsWorkingButton.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.bottom).offset(12)
            make.height.equalTo(23)
            make.left.equalTo(subtitleCompanyLabel.snp.left)
        }

        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
    }

    @objc private func didTapSaveBtn(_ sender: UIButton) {
        print("저장하기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.isSelected {
        case true:
            sender.setTitleColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), for: .normal)
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        }
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
        self.navigationItem.title = "경력"
        let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.leftBarButtonItem?.action  = #selector(didTapBackBarButton)
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
    @objc private func didTapBackBarButton() {
        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }

}
