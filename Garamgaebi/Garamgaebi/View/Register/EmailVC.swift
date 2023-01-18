//
//  EmailVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/12.
//

import UIKit
import SnapKit

class EmailVC: UIViewController {
    
    // MARK: - Propertys
    var userEmail = String()
    var isValidEmail = false {
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
        label.text = "이메일"
        label.textColor = .black
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
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "이메일 주소를 입력해주세요"
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
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(emailTextField)
        view.addSubview(pagingImage)
        view.addSubview(nextButton)
        
        /* Labels */
        [titleLabel,descriptionLabel,emailValidLabel].map {
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
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        // nickNameValidLabel
        emailValidLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
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
        let nextVC = OrganizationVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
        
    }
    
    // MARK: - ValidUserInfo
    
    func validateUserInfo() {
        if isValidEmail {
            self.nextButton.isEnabled = true
            UIView.animate(withDuration: 0.33) {
                self.nextButton.backgroundColor = .mainBlue
            }
            self.emailValidLabel.text = "사용 가능한 이메일입니다"
            self.emailValidLabel.textColor = .mainBlue
        } else {
            self.nextButton.isEnabled = false
            UIView.animate(withDuration: 0.33) {
                self.nextButton.backgroundColor = .mainGray
            }
            self.emailValidLabel.text = "이메일 형식이 올바르지 않습니다!"
            self.emailValidLabel.textColor = UIColor(hex: 0xFF0000)
        }
        
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor(hex: 0x000000).withAlphaComponent(0.8).cgColor
        sender.layer.borderWidth = 1
        
        self.emailValidLabel.isHidden = false

    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
        
    }
    
    @objc
    func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        switch sender {
        case emailTextField:
            self.isValidEmail = text.isValidEmail()
            self.userEmail = text
        
        default:
            fatalError("Missing TextField...")
        }

    }
}

extension String {
    
    // id 정규표현식 5~13자
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
}