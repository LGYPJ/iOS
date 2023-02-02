//
//  SchoolEmailAuthVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit
import SnapKit

class SchoolEmailAuthVC: UIViewController {

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
    
    lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
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
    
    lazy var authNumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        label.isHidden = true
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
    
    lazy var emailNotificationLabel: UILabel = {
        let label = UILabel()
        label.text = "메일을 받지 못하신 경우, 스팸 메일함을 확인해주세요."
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        return label
    }()
    
    lazy var authNumberSendButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("인증", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .mainGray // 비활성화
        
        button.addTarget(self, action: #selector(authSuccessed), for: .touchUpInside)
        
        button.isHidden = true
        return button
    }()
    
    lazy var authNumNotificationLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호가 올바르지 않습니다"
        label.textColor = UIColor(hex: 0xFF0000)
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
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
        view.addSubview(pagingImage)
        view.addSubview(emailAuthSendButton)
        view.addSubview(authNumberSendButton)
        view.addSubview(nextButton)
        
        /* TextField */
        view.addSubview(emailTextField)
        view.addSubview(authNumberTextField)
        
        /* Labels */
        [titleLabel,descriptionLabel,emailTitleLabel,emailNotificationLabel,authNumTitleLabel,authNumNotificationLabel].forEach {
            view.addSubview($0)
        }
        
        emailTextField.addSubview(emailLabel)
        
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
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // emailLabel
        emailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        //emailAuthSendButton
        emailAuthSendButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(14)
        }
        
        // emailNotificationLabel
        emailNotificationLabel.snp.makeConstraints { make in
            make.top.equalTo(emailAuthSendButton.snp.bottom).offset(4)
            make.left.equalTo(emailAuthSendButton.snp.left)
        }
        
        // authNumTitleLabel
        authNumTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailNotificationLabel.snp.bottom).offset(22)
            make.left.equalTo(emailNotificationLabel.snp.left)
        }
        
        //authNumberTextField
        authNumberTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(authNumTitleLabel.snp.bottom).offset(12)
            make.width.equalTo(296)
            make.height.equalTo(48)
        }
        
        //authNumberSendButton
        authNumberSendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(authNumberTextField.snp.top)
            make.width.equalTo(52)
            make.height.equalTo(48)
        }
        
        // authNumNotificationLabel
        authNumNotificationLabel.snp.makeConstraints { make in
            make.top.equalTo(authNumberTextField.snp.bottom).offset(4)
            make.left.equalTo(authNumberTextField.snp.left)
            make.height.equalTo(22)
        }
        
        // nextButton
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
        
        
    }
    
    @objc
    func sendEmail(_ sender: UIButton) {
        
        sender.setTitleColor(UIColor.mainBlue, for: .normal)
        sender.backgroundColor = .white
        sender.layer.borderColor = UIColor.mainBlue.cgColor
        sender.layer.borderWidth = 0.5
        
        var count = 5
        
        if timer != nil && timer!.isValid {
            timer?.invalidate()
            timer = nil
        }

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [self]_ in
            
            UIView.transition(with: self.authNumTitleLabel, duration: 0.33,
                              options: .transitionCrossDissolve,
                              animations: {
                self.authNumTitleLabel.isHidden = false
            })
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
            UIView.transition(with: self.nextButton, duration: 0.33,
                              options: .transitionCrossDissolve,
                              animations: {
                self.nextButton.isHidden = false
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
        
        // 임시로 올바른 인증번호 111111로 설정
        if authNumberTextField.text?.hasPrefix("111111") == true {
            // 인증번호 맞으면 ->
            self.nextButton.isEnabled = true
            // 타이머 끄기
            timer?.invalidate()
            timer = nil
            // ++ 나머지 버튼들 누르지 못하게 해야하나?? -> 이메일 잘못 기입해서 다시 보낼
            self.authNumberSendButton.isEnabled = false
            self.authNumberTextField.isEnabled = false
            self.emailTextField.isEnabled = false
            self.emailAuthSendButton.isEnabled = false
            UIView.animate(withDuration: 0.33) {
                self.nextButton.backgroundColor = .mainBlue
                self.emailAuthSendButton.setTitle("이메일 인증완료", for: .normal)
                self.emailAuthSendButton.setTitleColor(.white, for: .normal)
                self.emailAuthSendButton.backgroundColor = .mainBlue
            }
            
            
            
            
        }
        else {
            // 인증번호 틀리면
            // 빨갛게
            authNumberTextField.layer.borderColor = UIColor(hex: 0xFF0000).cgColor
            authNumberTextField.layer.borderWidth = 1
            //"인증번호가 올바르지 않습니다"
            UIView.transition(with: self.authNumNotificationLabel, duration: 0.33,
                              options: .transitionCrossDissolve,
                              animations: {
                self.authNumNotificationLabel.isHidden = false
            })
        }
    }
    
    @objc
    private func nextButtonTapped(_ sender: Any) {
        // EmailVC로 화면전환
        let nextVC = InputNickNameVC()
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
        
        // 올바른 인증번호의 양식 -> 6자리 숫자가 맞을 때
        if isValidAuthNumber {
            self.authNumberSendButton.isEnabled = true
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.33) {
                    self.authNumberTextField.layer.borderColor = UIColor.mainBlack.cgColor
                    self.authNumberTextField.layer.borderWidth = 1
                    self.authNumNotificationLabel.isHidden = true
                    self.authNumberSendButton.backgroundColor = .mainBlue
                }
            }
        // 올바르지 않은 인증번호의 양식 -> 6자리 숫자가 아닐 때
        } else {
            self.authNumberSendButton.isEnabled = false
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.33) {
                    self.authNumberSendButton.backgroundColor = .mainGray
                }
            }
        }
        
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor.mainBlack.cgColor
        sender.layer.borderWidth = 1
        
        if sender == emailTextField {
            emailLabel.textColor = .mainBlack
        }
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
        
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





