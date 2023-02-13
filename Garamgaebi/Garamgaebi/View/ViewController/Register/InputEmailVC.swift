//
//  InputEmailVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/12.
//

import UIKit
import SnapKit

class InputEmailVC: UIViewController {
    
    // MARK: - Propertys
    var profileEmail = String()
    var isValidProfileEmail = false {
        didSet {
            self.validateUserInfo()
        }
    }
    
    // MARK: - Subviews
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage3"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일을 입력해주세요"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필에 기재할\n이메일 주소를 알려주세요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var profileEmailTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.addRightPadding()
        textField.placeholder = "이메일 주소를 입력해주세요"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .mainBlack
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        textField.autocapitalizationType = .none
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        return textField
    }()
    
    lazy var emailValidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        label.textColor = UIColor(hex: 0xFF0000)
        label.isHidden = true
        return label
    }()

    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainGray // 비활성화
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configLayouts()
        configureGestureRecognizer()
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(profileEmailTextField)
        view.addSubview(pagingImage)
        view.addSubview(nextButton)
        
        /* Labels */
        [titleLabel,descriptionLabel,emailTitleLabel,profileEmailTextField,emailValidLabel].forEach {
            view.addSubview($0)
        }
 
    }
    
    func configLayouts() {
        
        //pagingImage
        pagingImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(72)
            make.height.equalTo(12)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(pagingImage.snp.left)
            make.top.equalTo(pagingImage.snp.bottom).offset(28)
        }
        
        // descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        
        // emailTitleLabel
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.left.equalTo(descriptionLabel.snp.left)
        }
        
        // emailTextField
        profileEmailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // emailValidLabel
        emailValidLabel.snp.makeConstraints { make in
            make.top.equalTo(profileEmailTextField.snp.bottom).offset(4)
            make.height.equalTo(17)
            make.left.equalToSuperview().inset(16)
        }
        
        // nextButton
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(14)
            make.height.equalTo(48)
        }
        
    }
    
    @objc
    private func nextButtonTapped(_ sender: Any) {
        // profileEmail 저장
        UserDefaults.standard.set(profileEmail, forKey: "profileEmail")
        
        // InputOrganizationVC로 화면전환
        let nextVC = InputOrganizationVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
        
    }
    
    // MARK: - ValidUserInfo
    
    func validateUserInfo() {
        self.emailValidLabel.isHidden = false
        if isValidProfileEmail {
            self.nextButton.isEnabled = true
            self.profileEmailTextField.layer.borderColor = UIColor.mainBlack.cgColor
            UIView.animate(withDuration: 0.33) {
                self.nextButton.backgroundColor = .mainBlue
                self.emailValidLabel.text = ""
            }
        } else {
            self.nextButton.isEnabled = false
            // textFiled가 비어있을 때
            if profileEmailTextField.text?.count == 0 {
                self.emailValidLabel.text = ""
                self.profileEmailTextField.layer.borderColor = UIColor.mainBlack.cgColor
            }
            // textFiled가 비어있지 않을 때
            else {
                self.profileEmailTextField.layer.borderColor = UIColor(hex: 0xFF0000).cgColor
                UIView.animate(withDuration: 0.33) {
                    self.nextButton.backgroundColor = .mainGray
                    self.emailValidLabel.text = "이메일 형식이 올바르지 않습니다"
                }
            }
        }
        
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        validateUserInfo()
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        validateUserInfo()
        self.emailValidLabel.isHidden = true
        sender.layer.borderColor = UIColor.mainGray.cgColor
    }
    
    @objc
    func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        switch sender {
        case profileEmailTextField:
            self.isValidProfileEmail = text.isValidEmail()
            self.profileEmail = text
        
        default:
            fatalError("Missing TextField...")
        }

    }
}

extension InputEmailVC {
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewDidTap() {
        self.view.endEditing(true)
    }
}
