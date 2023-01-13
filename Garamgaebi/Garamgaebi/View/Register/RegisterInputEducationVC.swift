//
//  RegisterInputEducationVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/12.
//

import UIKit
import SnapKit

class RegisterInputEducationVC: UIViewController {
    // MARK: - Subviews
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage4"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "교육"
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "가장 최근에 소속되었던\n교육기관을 알려주세요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var subtitleInstitutionLabel: UILabel = {
        let label = UILabel()
        label.text = "교육기관"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var institutionTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "교육기관을 입력해주세요"
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
    
    lazy var subtitleMajorLabel: UILabel = {
        let label = UILabel()
        label.text = "전공/과정"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var majorTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "전공/과정을 입력해주세요 (예: 웹 개발 과정)"
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
    
    lazy var checkIsLearningButton: UIButton = {
        let button = UIButton()
        button.setTitle("재학 중", for: .normal)
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
        label.text = "경력이 있으신가요?"
        label.textColor = UIColor(hex: 0x8A8A8A)
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        return label
    }()
    
    lazy var inputCareerButton: UIButton = {
        let button = UIButton()
        button.setTitle("경력 입력하기", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(inputCareerButtonTapped), for: .touchUpInside)
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
        view.addSubview(institutionTextField)
        view.addSubview(majorTextField)
        view.addSubview(saveUserProfileButton)
        view.addSubview(checkIsLearningButton)
        view.addSubview(inputCareerButton)
        
        /* Labels */
        [titleLabel,descriptionLabel,subtitleInstitutionLabel,subtitleMajorLabel,subDescriptionLabel].map {
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
        
        // subtitleInstitutionLabel
        subtitleInstitutionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
        }
        
        // institutionTextField
        institutionTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleInstitutionLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitleMajorLabel
        subtitleMajorLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(institutionTextField.snp.bottom).offset(28)
        }
        
        // majorTextField
        majorTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleMajorLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        //checkIsLearningButton
        checkIsLearningButton.snp.makeConstraints { make in
            make.top.equalTo(majorTextField.snp.bottom).offset(12)
            make.height.equalTo(23)
            make.left.equalToSuperview().inset(16)
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
        
        //inputCareerButton
        inputCareerButton.snp.makeConstraints { make in
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
    private func inputCareerButtonTapped(_ sender: UIButton) {
        var nextVC = RegisterInputCareerVC()
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
