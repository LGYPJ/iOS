//
//  RegisterInputCareerVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/12.
//

import UIKit
import SnapKit

class RegisterInputCareerVC: UIViewController {
    
    // MARK: - Subviews

    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage4"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "경력"
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "재직 중이 아니라면\n가장 최근에 일한 곳을 알려주세요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var subtitleCompanyLabel: UILabel = {
        let label = UILabel()
        label.text = "회사"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var companyTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "회사명을 입력해주세요"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        textField.autocapitalizationType = .none
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        return textField
    }()
    
    lazy var subtitlePositionLabel: UILabel = {
        let label = UILabel()
        label.text = "직함"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var positionTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "직함을 입력해주세요 (예: 백엔드 개발자)"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
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
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var startDateTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "시작년월"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        textField.autocapitalizationType = .none
        
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
        
        textField.addLeftPadding()
        textField.placeholder = "종료년월"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
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
        button.setImage(UIImage(systemName: "checkmark.square")?.withTintColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), renderingMode: .alwaysOriginal), for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        return button
    }()
    
    lazy var subDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 경력이 없으신가요?"
        label.textColor = UIColor(hex: 0x8A8A8A)
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        return label
    }()
    
    lazy var inputEducationButton: UIButton = {
        let button = UIButton()
        button.setTitle("교육 입력하기", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(inputEducationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainBlue
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
        view.addSubview(pagingImage)
        view.addSubview(companyTextField)
        view.addSubview(positionTextField)
        view.addSubview(startDateTextField)
        view.addSubview(endDateTextField)
        view.addSubview(betweenTildLabel)
        view.addSubview(checkIsWorkingButton)
        view.addSubview(saveUserProfileButton)
        view.addSubview(inputEducationButton)
        

        /* Labels */
        [titleLabel,descriptionLabel,subtitleCompanyLabel,subtitlePositionLabel,subtitleWorkingDateLabel,subDescriptionLabel].map {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        
        //pagingImage
        pagingImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(96)
            make.height.equalTo(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(pagingImage.snp.bottom).offset(16)
        }
        
        // descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        
        // subtitleCompanyLabel
        subtitleCompanyLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
        }
        
        // companyTextField
        companyTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleCompanyLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitlePositionLabel
        subtitlePositionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(companyTextField.snp.bottom).offset(28)
        }
        
        // positionTextField
        positionTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitlePositionLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitleWorkingDateLabel
        subtitleWorkingDateLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
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
            make.left.equalTo(titleLabel.snp.left)
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
            make.left.equalTo(titleLabel.snp.left)
        }
        
        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
        
        //subDescriptionLabel
        subDescriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.bottom.equalTo(saveUserProfileButton.snp.top).offset(-8)
        }
        
        //inputEducationButton
        inputEducationButton.snp.makeConstraints { make in
            make.left.equalTo(subDescriptionLabel.snp.right).offset(8)
            make.centerY.equalTo(subDescriptionLabel.snp.centerY)
        }
    }
    
    @objc
    private func nextButtonTapped(_ sender: UIButton) {
        var nextVC = RegisterCompletedVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)

    }

    @objc
    private func inputEducationButtonTapped(_ sender: UIButton) {
        var nextVC = RegisterInputEducationVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    @objc
    private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.isSelected {
        case true:
            sender.setTitleColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), for: .normal)
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        }
    }
    
    @objc
    func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor(hex: 0x000000).withAlphaComponent(0.8).cgColor
        sender.layer.borderWidth = 1
    }
    
    @objc
    func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
    }

}
