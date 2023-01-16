//
//  ProfileInputEducationVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/16.
//

import UIKit

class ProfileInputEducationVC: UIViewController {

    // MARK: - Subviews
    lazy var subtitleInstitutionLabel: UILabel = {
        let label = UILabel()
        label.text = "교육 기관"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var institutionTextField: UITextField = {
        let textField = UITextField()
        
//        textField.addLeftPadding()
        textField.placeholder = "교육기관을 입력해주세요"
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

    lazy var subtitleMajorLabel : UILabel = {
        let label = UILabel()
        label.text = "전공/과정"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        
        return label
    }()

    lazy var majorTextField: UITextField = {
        let textField = UITextField()

        textField.placeholder = "전공/과정을 입력해주세요 (예: 웹 개발 과정)"
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

    lazy var subtitleLearningDateLabel: UILabel = {
        let label = UILabel()
        label.text = "교육 기간"
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

    lazy var checkIsLearningButton: UIButton = {
        let button = UIButton()
        button.setTitle("교육 중", for: .normal)
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
        view.addSubview(institutionTextField)
        view.addSubview(majorTextField)
        view.addSubview(startDateTextField)
        view.addSubview(endDateTextField)
        view.addSubview(betweenTildLabel)
        view.addSubview(checkIsLearningButton)
        view.addSubview(saveUserProfileButton)


        /* Labels */
        [subtitleInstitutionLabel,subtitleMajorLabel,subtitleLearningDateLabel].map {
            view.addSubview($0)
        }
    }

    func configLayouts() {
        
        // subtitleCompanyLabel
        subtitleInstitutionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }

        // companyTextField
        institutionTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleInstitutionLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }

        // subtitlePositionLabel
        subtitleMajorLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
            make.top.equalTo(institutionTextField.snp.bottom).offset(28)
        }

        // positionTextField
        majorTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleMajorLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalTo(institutionTextField)
        }

        // subtitleWorkingDateLabel
        subtitleLearningDateLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
            make.top.equalTo(majorTextField.snp.bottom).offset(28)
        }

        // betweenTildLabel
        betweenTildLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(38)
            make.height.equalTo(48)
            make.top.equalTo(subtitleLearningDateLabel.snp.bottom).offset(4)
        }

        // startDateTextField
        startDateTextField.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.top)
            make.height.equalTo(48)
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
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
        checkIsLearningButton.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.bottom).offset(12)
            make.height.equalTo(23)
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
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
        self.navigationItem.title = "교육"
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
