//
//  NickNameVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit

class NickNameVC: UIViewController {
    
    // MARK: - Propertys
    var userNickName = String()
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
        label.text = "닉네임"
        label.textColor = .black
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
    
    lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "닉네임을 입력해주세요 (최대 8글자)"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
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
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        //label.text = "최대 8글자까지 작성이 가능합니다!"
        //label.text = "사용 가능하지 않은 닉네임입니다."
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
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(nickNameTextField)
        view.addSubview(pagingImage)
        view.addSubview(nextButton)
        
        /* Labels */
        [titleLabel,descriptionLabel,nickNameValidLabel].map {
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
        
        // emailTextField
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        // nickNameValidLabel
        nickNameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(4)
            make.height.equalTo(17)
            make.left.equalToSuperview().inset(16)
        }
        
        // nextButton
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
        
    }
    
    @objc
    private func nextButtonTapped(_ sender: Any) {
        // EmailVC로 화면전환
        let nextVC = LoginVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
        
    }
    
    // MARK: - ValidUserInfo
    
    func validateUserInfo() {
        if isValidNickName {
            self.nextButton.isEnabled = true
            UIView.animate(withDuration: 0.33) {
                self.nextButton.backgroundColor = .mainBlue
            }
            self.nickNameValidLabel.text = "사용 가능한 닉네임입니다"
            self.nickNameValidLabel.textColor = .mainBlue
        } else {
            self.nextButton.isEnabled = false
            UIView.animate(withDuration: 0.33) {
                self.nextButton.backgroundColor = .mainGray
            }
            self.nickNameValidLabel.text = "사용 가능하지 않은 닉네임입니다."
            //self.nickNameValidLabel.text = "최대 8글자까지 작성이 가능합니다!"
            self.nickNameValidLabel.textColor = .red
        }
        
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor(hex: 0x000000).withAlphaComponent(0.8).cgColor
        sender.layer.borderWidth = 1
        
        self.nickNameValidLabel.isHidden = false

    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
        
    }
    
    @objc
    func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        switch sender {
        case nickNameTextField:
            self.isValidNickName = text.isValidNickName()
            self.userNickName = text
        
        default:
            fatalError("Missing TextField...")
        }

    }
}

extension String {
    
    // id 정규표현식 5~13자
    func isValidNickName() -> Bool {
        let nickRegEx = "[가-힣A-Za-z0-9]{2,8}"
        let nickTest = NSPredicate(format: "SELF MATCHES %@", nickRegEx)
        
        return nickTest.evaluate(with: self)
    }
}
