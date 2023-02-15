//
//  SchoolEmailAuthVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/11.
//

import UIKit
import SnapKit

class UniEmailAuthVC: UIViewController {
    
    // MARK: - Propertys
    var timer: Timer?
    
    let interval = 1.0
    var userId = String()
    var isValidId = false {
        didSet {
            self.validateUserInfo()
        }
    }
    var isValidAuthNumber = false {
        didSet {
            self.validateUserInfo()
        }
    }
    private var scrollOffset : CGFloat = 0
    private var distance : CGFloat = 0
    // MARK: - Subviews
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage1"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대생 인증을 진행해주세요"
        label.textColor = .mainBlack
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
        textField.addRightPadding()
        textField.placeholder = "example"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .mainBlack
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
        label.textColor = .mainBlack
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
        textField.addRightPadding()
        textField.placeholder = "인증번호 6자리"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .mainBlack
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
        button.isEnabled = false
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
        button.isEnabled = false
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
        UserDefaults.standard.set("hsw1920@naver.com", forKey: "socialEmail")
        view.backgroundColor = .white
        emailTextField.delegate = self
        authNumberTextField.delegate = self
        addSubViews()
        configLayouts()
        configureGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setKeyboardObserverRemove()
    }
    
    // MARK: - Functions
    
    func addSubViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        /* Buttons */
        contentView.addSubview(pagingImage)
        contentView.addSubview(emailAuthSendButton)
        contentView.addSubview(authNumberSendButton)
        view.addSubview(nextButton)
        
        /* TextField */
        contentView.addSubview(emailTextField)
        contentView.addSubview(authNumberTextField)
        
        /* Labels */
        [titleLabel,descriptionLabel,emailTitleLabel,emailNotificationLabel,authNumTitleLabel,authNumNotificationLabel].forEach {
            contentView.addSubview($0)
        }
        
        emailTextField.addSubview(emailLabel)
        
    }
    
    func configLayouts() {
        //scrollView
        scrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        //contentView
        contentView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        //pagingImage
        pagingImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(72)
            make.height.equalTo(12)
            make.top.equalToSuperview().inset(28)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(pagingImage.snp.left)
            make.top.equalTo(pagingImage.snp.bottom).offset(28)
        }
        
        // descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().inset(16)
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
            make.right.equalTo(authNumberSendButton.snp.left).offset(-10)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(14)
            make.height.equalTo(48)
        }
    }
    
    @objc
    func sendEmail(_ sender: UIButton) {
        
        // 네이버메일(임시)
        let uniEmail = UniEmailAuthModel(email: "\(userId)@gachon.ac.kr")
        //let uniEmail = UniEmailAuthModel(email: "\(userId)@naver.com")
        
        // 메일을 보내면서 uniEmail UserDefault에 저장
        UserDefaults.standard.set("\(userId)@gachon.ac.kr", forKey: "uniEmail")
        //UserDefaults.standard.set("\(userId)@naver.com", forKey: "uniEmail")
        
        UniEmailAuthViewModel.requestSendEmail(uniEmail) { [weak self] result in
            switch result {
            case true:
                print(">>>Front: 이메일 전송 성공")
            default:
                print(">>>Front: 이메일 전송 실패")
            }
        }
        sender.setTitleColor(UIColor.mainBlue, for: .normal)
        sender.backgroundColor = .white
        sender.layer.borderColor = UIColor.mainBlue.cgColor
        sender.layer.borderWidth = 0.5
        authNumberTextField.isEnabled = true
        authNumberSendButton.isEnabled = true
        var count = 180
        
        if timer != nil && timer!.isValid {
            timer?.invalidate()
            timer = nil
        }

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [self]_ in
            
            UIView.transition(with: self.authNumTitleLabel, duration: 0.33,
                              options: .transitionCrossDissolve,
                              animations: {
                self.authNumTitleLabel.isHidden = false
                self.authNumberTextField.isHidden = false
                self.authNumberSendButton.isHidden = false
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
                initAuthNumberUI()
            }

        })
    }
    
    @objc
    private func authSuccessed(_ sender: Any) {
        let verifyModel = UniEmailAuthNumberModel(email: UserDefaults.standard.string(forKey: "uniEmail")!, key: authNumberTextField.text!)
        UniEmailAuthViewModel.requestVerifyAuthNumber(verifyModel) { [weak self] result in
            switch result {
            case true:
                // 인증번호 맞으면 ->
                self?.nextButton.isEnabled = true
                // 타이머 끄기
                self?.timer?.invalidate()
                self?.timer = nil
                // ++ 나머지 버튼들 누르지 못하게 해야하나?? -> 이메일 잘못 기입해서 다시 보낼
                self?.authNumberSendButton.isEnabled = false
                self?.authNumberTextField.isEnabled = false
                self?.emailTextField.isEnabled = false
                self?.emailAuthSendButton.isEnabled = false
                UIView.animate(withDuration: 0.33) {
                    self?.nextButton.backgroundColor = .mainBlue
                    self?.emailAuthSendButton.setTitle("이메일 인증완료", for: .normal)
                    self?.emailAuthSendButton.setTitleColor(.white, for: .normal)
                    self?.emailAuthSendButton.backgroundColor = .mainBlue
                }
            default:
                // 인증번호 틀리면
                // 빨갛게, shake
                
                self?.authNumberTextField.shake()
                //"인증번호가 올바르지 않습니다"
                UIView.transition(with: self!.authNumNotificationLabel, duration: 0.33, options: .transitionCrossDissolve, animations: {
                    self?.authNumNotificationLabel.isHidden = false
                })
                print(">>>Front: 인증번호가 일치하지 않습니다")
            }
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
        if sender == authNumberTextField {
            sender.text = ""
            authNumNotificationLabel.isHidden = true
            self.authNumberSendButton.isEnabled = false
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.33) {
                    self.authNumberSendButton.backgroundColor = .mainGray
                }
            }
        }
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
            self.isValidId = text.isValidId()
            self.userId = text
        case authNumberTextField:
            self.isValidAuthNumber = text.isValidAuthNumber()
        default:
            fatalError("Missing TextField...")
        }

    }
    
    private func initAuthNumberUI() {
        authNumberTextField.isEnabled = false
        authNumberSendButton.isEnabled = false
        authNumberTextField.text = ""
        authNumberSendButton.backgroundColor = .mainGray
        authNumNotificationLabel.isHidden = true
    }
    
}

extension UniEmailAuthVC {
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

extension UniEmailAuthVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        var maxLength = Int()
        switch(textField) {
        case emailTextField:
            maxLength = 20
        case authNumberTextField:
            maxLength = 6
        default:
            return false
        }
        // 최대 글자수 이상을 입력한 이후로 입력 불가능
        if text.count >= maxLength && range.length == 0 && range.location >= maxLength {
            return false
        }
        return true
    }
}


extension UniEmailAuthVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height -= view.safeAreaInsets.top * 1.5 // 이 부분 조절하면서 스크롤 올리는 정도 변경
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking
            
            // determine which UIView was selected and if it is covered by keyboard
            let activeField: UIView? = [emailTextField, authNumberTextField].first { $0.isFirstResponder }
            if let activeField = activeField {
                if safeArea.contains(CGPoint(x: 0, y: activeField.frame.maxY)) {
                    print("No need to Scroll")
                    return
                } else {
                    distance = activeField.frame.maxY - safeArea.size.height
                    scrollOffset = scrollView.contentOffset.y
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset + distance), animated: true)
                }
            }
            // prevent scrolling while typing
            scrollView.isScrollEnabled = false
        }
    }
    
    @objc private func keyboardWillHide() {
        
        if distance == 0 {
            return
        }
        // return to origin scrollOffset
//        self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        scrollOffset = 0
        distance = 0
        scrollView.isScrollEnabled = true
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func setKeyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
