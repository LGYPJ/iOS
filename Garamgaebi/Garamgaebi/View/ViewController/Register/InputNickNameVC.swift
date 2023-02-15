//
//  InputNickNameVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit

class InputNickNameVC: UIViewController {
    
    // MARK: - Propertys
    var nickName = String()
    var isValidNickName = false {
        didSet { 
            self.validateUserInfo()
        }
    }
    
    // MARK: - Subviews
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage2"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비에서 사용할\n당신의 닉네임을 설정해주세요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var nickNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.addRightPadding()
        textField.placeholder = "닉네임 (8자 이내, 한글, 영문, 숫자 사용 가능)"
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
    
    lazy var nickNameValidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.NotoSansKR(type: .Regular, size: 10)
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
        view.addSubview(nickNameTextField)
        view.addSubview(pagingImage)
        view.addSubview(nextButton)
        
        /* Labels */
        [titleLabel,descriptionLabel,nickNameTitleLabel,nickNameValidLabel].forEach {
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
        // nickNameTitleLabel
        nickNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.left.equalTo(descriptionLabel.snp.left)
        }
        
        // nickNameTextField
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // nickNameValidLabel
        nickNameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(2)
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
        
        // nickName 저장
        UserDefaults.standard.set(nickName, forKey: "nickname")
        
        // InputEmailVC로 화면전환
        let nextVC = InputEmailVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
        
    }
    
    // MARK: - ValidUserInfo
    
    func validateUserInfo() {
        self.nickNameValidLabel.isHidden = false
        if isValidNickName {
            self.nextButton.isEnabled = true
            self.nickNameTextField.layer.borderColor = UIColor.mainBlack.cgColor
            UIView.animate(withDuration: 0.33) {
                self.nextButton.backgroundColor = .mainBlue
                self.nickNameValidLabel.text = ""
            }
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .mainGray
            // textFiled가 비어있을 때
            if self.nickNameTextField.text?.count == 0 {
                self.nickNameValidLabel.text = ""
                self.nickNameTextField.layer.borderColor = UIColor.mainBlack.cgColor
            }
            else {
                // 글자 수 맞으면
                if self.nickNameTextField.text!.count > 0,
                   self.nickNameTextField.text!.count <= 8 {
                    self.nickNameValidLabel.text = "사용할 수 없는 닉네임입니다"
                }
                // 글자 수 안 맞으면
                else {
                    self.nickNameValidLabel.text = "8자 이내로 입력해주세요"
                }
                
                self.nickNameTextField.layer.borderColor = UIColor(hex: 0xFF0000).cgColor
            }
            self.nickNameValidLabel.textColor = UIColor(hex: 0xFF0000)
        }
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        self.validateUserInfo()
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        self.validateUserInfo()
        self.nickNameValidLabel.isHidden = true
        sender.layer.borderColor = UIColor.mainGray.cgColor
    }
    
    @objc
    func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        switch sender {
        case nickNameTextField:
            self.isValidNickName = text.isValidNickName()
            self.nickName = text
        
        default:
            fatalError("Missing TextField...")
        }

    }
}

extension InputNickNameVC {
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


