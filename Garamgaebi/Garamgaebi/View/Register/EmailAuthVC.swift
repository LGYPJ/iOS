//
//  EmailAuthVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit
import SnapKit

class EmailAuthVC: UIViewController {

    // MARK: - Propertys
    //let timeSelector: Selector = #selector(updateTime)
    var timer: Timer?
    
    let interval = 1.0
    var userId = String()
    var isValidId = false {
        didSet { // 프로퍼티 옵저버 :23
            self.validateUserInfo()
        }
    }
    var isValidAuthNumber = false {
        didSet { // 프로퍼티 옵저버 :
            self.validateUserInfo()
        }
    }
    
    
    
    // MARK: - Subviews
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage1"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대생 인증"
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비 사용을 위해서는 가천대생 인증이 필요해요\n가천대학교 이메일 인증을 진행해주세요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "example"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        textField.autocapitalizationType = .none
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 0.5
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        return textField
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "@gachon.ac.kr"
        label.textColor = .mainGray
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        return label
    }()
    
    lazy var authNumberTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.placeholder = "인증번호 6자리"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 0.5
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        
        textField.isHidden = true
        return textField
    }()
    
    lazy var emailAuthSendButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("이메일 발송하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainGray // 비활성화
        
        button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        
        return button
    }()
    
    lazy var authNumberSendButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("인증번호 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainGray // 비활성화
        
        button.addTarget(self, action: #selector(authSuccessed), for: .touchUpInside)
        
        button.isHidden = true
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
        view.addSubview(emailAuthSendButton)
        view.addSubview(authNumberSendButton)
        view.addSubview(emailTextField)
        view.addSubview(authNumberTextField)
        view.addSubview(pagingImage)
        
        /* Labels */
        [titleLabel,descriptionLabel].map {
            view.addSubview($0)
        }
        
        emailTextField.addSubview(emailLabel)
        
    }
    
    func configLayouts() {

        //pagingImage
        pagingImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(96)
            make.height.equalTo(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
        }
        
        //titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(pagingImage.snp.bottom).offset(16)
        }
        
        //descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        
        //emailTextField
        emailTextField.snp.makeConstraints { make in
            //make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        //emailAuthSendButton
        emailAuthSendButton.snp.makeConstraints { make in
            //make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
        }
        
        //authNumberTextField
        authNumberTextField.snp.makeConstraints { make in
            //make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(emailAuthSendButton.snp.bottom).offset(72)
            make.left.right.equalToSuperview().inset(16)
        }
        
        //authNumberSendButton
        authNumberSendButton.snp.makeConstraints { make in
            //make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(authNumberTextField.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        
    }
    
    @objc
    func sendEmail(_ sender: UIButton) {
        
        sender.setTitleColor(UIColor.mainBlue, for: .normal)
        sender.backgroundColor = .white
        sender.layer.borderColor = UIColor.mainBlue.cgColor
        sender.layer.borderWidth = 0.5
        
        var count = 180
        
        if timer != nil && timer!.isValid {
            timer?.invalidate()
            timer = nil
        }

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [self]_ in
            
            UIView.transition(with: self.authNumberTextField, duration: 0.33,
                              options: .transitionCrossDissolve,
                              animations: {
                self.authNumberTextField.isHidden = false
            })
            UIView.transition(with: self.authNumberSendButton, duration: 0.33,
                              options: .transitionCrossDissolve,
                              animations: {
                self.authNumberSendButton.isHidden = false
            })
            
            let minutes = count / 60
            let seconds = count % 60
            count -= 1
            
            //남은 시간(초)가 0보다 크면
            if count > 0 {
                sender.setTitle("이메일 재발송하기 (\(minutes)분 \(seconds)초)", for: .normal)
            } else {
                sender.setTitle("이메일 재발송하기", for: .normal)
                sender.setTitleColor(.white, for: .normal)
                sender.backgroundColor = .mainBlue
            }

        })
    }
    
    @objc
    private func authSuccessed(_ sender: Any) {
        
        // NickNameVC로 화면전환
        let nextVC = NickNameVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
        
    }
    
    // MARK: - ValidUserInfo
    
    func validateUserInfo() {
        if isValidId && authNumberSendButton.isHidden {
            self.emailAuthSendButton.isEnabled = true
            UIView.animate(withDuration: 0.33) {
                self.emailAuthSendButton.backgroundColor = .mainBlue
            }
        } else if authNumberSendButton.isHidden{
            self.emailAuthSendButton.isEnabled = false
            UIView.animate(withDuration: 0.33) {
                self.emailAuthSendButton.backgroundColor = .mainGray
            }
        }
        
        if isValidAuthNumber {
            self.authNumberSendButton.isEnabled = true
            UIView.animate(withDuration: 0.33) {
                self.authNumberSendButton.backgroundColor = .mainBlue
            }
        } else {
            self.authNumberSendButton.isEnabled = false
            UIView.animate(withDuration: 0.33) {
                self.authNumberSendButton.backgroundColor = .mainGray
            }
        }
        
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor(hex: 0x000000).withAlphaComponent(0.8).cgColor
        sender.layer.borderWidth = 0.5
        
        if sender == emailTextField {
            emailLabel.textColor = UIColor(hex: 0x000000).withAlphaComponent(0.8)
        }
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 0.5
        
        // emailTextField이 비어있을때 emailLabel을 다시 비활성
        if sender == emailTextField
            && emailTextField.text?.count == 0 {
            emailLabel.textColor = .mainGray
        }
        
    }
    
    @objc
    func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""

        switch sender {
        case emailTextField:
            self.isValidId = text.isValidId()
            self.userId = text
        case authNumberTextField:
            self.isValidAuthNumber = text.isValidAuthNumber()
        default:
            fatalError("Missing TextField...")
        }

    }
    
    
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}

extension UITextField {
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
    
}

extension String {
    // 숫자 6자일때 -> True
    func isValidAuthNumber() -> Bool {
        let authNumberRegEx = "[0-9]{6}"
        let authNumberTest = NSPredicate.init(format: "SELF MATCHES %@", authNumberRegEx)
        
        return authNumberTest.evaluate(with: self)
    }
    
    // id 정규표현식 5~13자
    func isValidId() -> Bool {
        let idRegEx = "[A-Za-z0-9]{5,13}"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        
        return idTest.evaluate(with: self)
    }
}


