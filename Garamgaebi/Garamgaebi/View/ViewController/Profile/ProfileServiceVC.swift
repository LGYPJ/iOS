//
//  ProfileServiceVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/12.
//

import UIKit
import SnapKit
import Then

class ProfileServiceVC: UIViewController, BottomSheetSelectDelegate {
    
    // MARK: - Properties
    private var isChecking: Bool = false
    private var textCount: Int = 0 {
        didSet {
            if textCount > maxTextCount {
                textCount = maxTextCount - 1
                contentLengthLabel.text = "\(textCount + 1)/\(maxTextCount)"
            }
            else {
                contentLengthLabel.text = "\(textCount)/\(maxTextCount)"
            }
        }
    }
    private let maxTextCount = 100
    private var scrollOffset : CGFloat = 0
    private var distance : CGFloat = 0
    
    // 이메일 유효성 검사
    var email = String()
    var isValidEmail = false {
        didSet {
            self.validateEmail()
        }
    }
    
    // MARK: - Subviews
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "고객센터"
        label.textColor = UIColor.mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor.mainBlack
        
        button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        
        return button
    }()
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let noticeSubtitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.textColor = UIColor.mainBlack
        $0.text = "고객센터 안내"
    }
    let noticeLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.textColor = UIColor.mainBlack
        $0.text = "휴일을 제외한 평일에는 하루 이내에 답변을 드릴게요.\n혹시 하루가 지나도 답변이 오지 않으면, 스팸 메일함을 확인해주세요."
    }
    
    let emailSubtitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.textColor = UIColor.mainBlack
        $0.text = "답변받을 이메일"
    }
    lazy var emailTextField = UITextField().then {
        $0.basicTextField()
        $0.placeholder = "답변 받을 이메일 주소"
    }
    lazy var emailAlertLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 10)
        $0.text = "이메일 형식이 올바르지 않습니다."
        $0.alpha = 0
    }
    
    let questionTypeSubtitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.textColor = UIColor.mainBlack
        $0.text = "문의 사유"
    }
    lazy var questionTypeTextField = UITextField().then {
        $0.basicTextField()
        $0.placeholder = "질문 유형을 선택해주세요"
        $0.text = ""
        
        let typeSelectBtn = UIButton()
        typeSelectBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        typeSelectBtn.tintColor = .mainBlack
        
        $0.addSubview(typeSelectBtn)
        typeSelectBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(35)
        }
    }
    
    let textViewPlaceHolder = "내용을 적어주세요"
    lazy var contentTextField = UITextView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.cornerRadius = 12
        $0.textContainerInset = UIEdgeInsets(top: 10.0, left: 12.0, bottom: 16.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.text = textViewPlaceHolder
        $0.textColor = .mainGray
        $0.delegate = self // <-
    }
    lazy var contentLengthLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 12)
        $0.textColor = UIColor(hex: 0xAEAEAE)
        $0.text = "\(textCount)/100"
    }
    
    lazy var agreeCheckBtn = UIButton().then {
        $0.setTitle("이메일 정보 제공 동의", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .automatic), for: .selected)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        $0.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        
        $0.clipsToBounds = true
    }
    
    let agreemsgLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.text = "답변을 보내드리기 위해 필요해요"
        $0.textColor = UIColor(hex: 0x8A8A8A)
    }
    
    lazy var sendBtn = UIButton().then {
        $0.basicButton()
        $0.setTitle("보내기", for: .normal)
        $0.backgroundColor = .mainGray
        $0.isEnabled = false
        
        $0.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
    }
    
    lazy var logoutLabel = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.setTitleColor(UIColor(hex: 0xAEAEAE), for: .normal)
        
        $0.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    }
    lazy var seperateLine = UIView().then {
        $0.backgroundColor = UIColor(hex: 0xAEAEAE)
    }
    lazy var withdrawalLabel = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.setTitleColor(UIColor(hex: 0xAEAEAE), for: .normal)
        
        $0.addTarget(self, action: #selector(withdrawalButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        configureLayouts()
        configureTextField()
        configureGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardObserver()
        setObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setKeyboardObserverRemove()
    }
    
    
    
    // MARK: - Functions
    private func configureLayouts() {
        
        view.backgroundColor = .white
        
        // addSubview - HeaderView
        view.addSubview(headerView)
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        // addSubview
        [noticeSubtitleLabel, noticeLabel, emailSubtitleLabel, emailTextField, emailAlertLabel, questionTypeSubtitleLabel, questionTypeTextField, contentTextField, agreeCheckBtn, agreemsgLabel, sendBtn]
            .forEach {contentView.addSubview($0)}
        [logoutLabel, seperateLine, withdrawalLabel].forEach { contentView.addSubview($0)
        }
        
        contentView.addSubview(contentLengthLabel)
        
        // layout
        
        //headerView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // backButton
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // scrollView
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // contentView
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        noticeSubtitleLabel.snp.makeConstraints { /// 고객센터 안내
            $0.top.equalTo(scrollView).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(16)

        }
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(noticeSubtitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(noticeSubtitleLabel)
        }
        
        emailSubtitleLabel.snp.makeConstraints { /// 답변 받을 이메일 주소
            $0.top.equalTo(noticeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(noticeLabel)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailSubtitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(emailSubtitleLabel)
            $0.height.equalTo(48)
        }
        emailAlertLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(emailSubtitleLabel)
        }
        
        questionTypeSubtitleLabel.snp.makeConstraints { /// 질문 유형 선택
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(emailTextField)
        }
        
        contentLengthLabel.snp.makeConstraints { /// 글자수 계산
            $0.centerY.equalTo(questionTypeSubtitleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        questionTypeTextField.snp.makeConstraints {
            $0.top.equalTo(questionTypeSubtitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(questionTypeSubtitleLabel)
            $0.height.equalTo(48)
        }
        
        contentTextField.snp.makeConstraints { /// 내용 입력
            $0.top.equalTo(questionTypeTextField.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(100)
        }
        
        agreeCheckBtn.snp.makeConstraints { /// 이메일 정보 제공 동의
            $0.top.equalTo(contentTextField.snp.bottom).offset(8)
            $0.leading.equalTo(emailTextField)
        }
        agreemsgLabel.snp.makeConstraints { /// 답변 필요
            $0.top.equalTo(agreeCheckBtn.snp.bottom)
            $0.leading.equalTo(agreeCheckBtn).offset(23)
        }
        
        sendBtn.snp.makeConstraints { /// 메일 보내기 버튼
            $0.top.equalTo(agreemsgLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(emailTextField)
        }
        
        logoutLabel.snp.makeConstraints { /// 로그아웃
            $0.top.equalTo(sendBtn.snp.bottom).offset(60)
            $0.bottom.equalTo(seperateLine.snp.top).offset(4)
            $0.centerX.equalTo(withdrawalLabel)
        }
        
        seperateLine.snp.makeConstraints { /// 구분선
            $0.centerX.equalTo(withdrawalLabel)
            $0.bottom.equalTo(withdrawalLabel.snp.top).offset(4)
            $0.height.equalTo(1)
            $0.width.equalTo(7)
        }
        
        withdrawalLabel.snp.makeConstraints { /// 회원탈퇴
            $0.bottom.equalTo(contentView).inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    func typeSelect(type: String) {
        self.questionTypeTextField.text = type
        
    }
    
    func textFieldChanged() {
        self.questionTypeTextField.layer.borderColor = UIColor.mainGray.cgColor
        allTextFieldFilledIn()
    }
    
    // 바텀시트 나타내기
    @objc private func showBottomSheet() {
        
        let bottomSheetVC = BottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.delegate = self
        
        bottomSheetVC.titleText = "질문 유형을 선택해주세요"
        bottomSheetVC.T1 = "이용문의"
        bottomSheetVC.T2 = "오류신고"
        bottomSheetVC.T3 = "서비스 제안"
        bottomSheetVC.T4 = "기타"
        
        self.present(bottomSheetVC, animated: false) {
            self.questionTypeTextField.layer.borderColor = UIColor.mainBlack.cgColor
        }
        
        /* 모든 textField가 채워졌으면 고객센터 버튼 활성화 */
        if self.isValidEmail,
           self.questionTypeTextField.text!.count != 0,
           self.textCount != 0,
           agreeCheckBtn.isSelected {
            sendBtn.isEnabled = true
            UIView.animate(withDuration: 2) { [weak self] in
                self?.sendBtn.backgroundColor = .mainBlue
            }
        }
    }
    
    // 서버 통신
    @objc private func sendButtonDidTap() {
        
        let memberIdx = UserDefaults.standard.integer(forKey: "memberIdx")
        guard let email = emailTextField.text else { return }
        guard let category = questionTypeTextField.text else { return }
        guard let content = contentTextField.text else { return }
        
        ProfileServiceViewModel.postQna(memberIdx: memberIdx, email: email, category: category, content: content) { result in
                if result {
                    self.navigationController?.popViewController(animated: true)
                }
        }
    }
    
    // 로그아웃 버튼 did tap
    @objc private func logoutButtonDidTap() {
        // 로그아웃 동의 다이얼로그
        let logoutCheckAlert = UIAlertController(title: "로그아웃하시겠습니까?", message: "", preferredStyle: .alert)
        // 로그아웃 선택지
        let logoutNoAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let logoutYesAction = UIAlertAction(title: "예", style: .default) { [self] (_) in
            let accessToken = UserDefaults.standard.string(forKey: "BearerToken") ?? ""
            let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
            let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
            print(fcmToken)
            LogoutViewModel.postLogout(accessToken: accessToken, refreshToken: refreshToken, fcmToken: fcmToken) { [weak self] result in
                switch result {
                case .success(let result):
                    if result.isSuccess {
                        print("성공(로그아웃): \(result.message)")
                        // 로그아웃 진행
                        let nextVC = LoginVC(pushProgramIdx: nil, pushProgramtype: nil)
                        // 호출하는 화면의 크기와 동일한 화면크기로 불려짐. 기존의 뷰들은 아예 삭제
                        nextVC.modalPresentationStyle = .currentContext
                        
                        // 로그아웃 시 UserDefaults에 저장된 모든 정보 삭제
                        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                            UserDefaults.standard.removeObject(forKey: key.description)
                        }
                        present(nextVC, animated: true)
                    }
                    else {
                        print("실패(로그아웃): \(result.message)")
                    }
                case .failure(let error):
                    print("실패(AF-로그아웃): \(error.localizedDescription)")
                    let errorView = ErrorPageView()
                    errorView.modalPresentationStyle = .fullScreen
                    self?.present(errorView, animated: false)
                }
            }
        }
        // 로그아웃 동의 다이얼로그 띄우기
        logoutCheckAlert.addAction(logoutNoAction)
        logoutCheckAlert.addAction(logoutYesAction)
        self.present(logoutCheckAlert, animated: true, completion: nil)
    }
    
    // 회원탈퇴 버튼 did tap
    @objc private func withdrawalButtonDidTap() {
        
        // 화면 전환
        let nextVC = ProfileWithdrawalVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        checkButtonValid(sender)
    }
    
    private func checkButtonValid(_ sender: UIButton){
        switch sender.isSelected {
        case true:
            // cornerCase에서 토글시
            sender.setTitleColor(.mainBlack, for: .normal)
            agreemsgLabel.textColor = .mainBlack
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
            agreemsgLabel.textColor = UIColor(hex: 0x8A8A8A)
        }
    }

    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // textField delegate 등록
    private func configureTextField() {
        // email
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldActivated(_:)), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(textFieldInactivated(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
        
        // questionType
        //questionTypeTextField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingDidEnd)
        
        // toggle
        agreeCheckBtn.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        agreeCheckBtn.addTarget(self, action: #selector(allTextFieldFilledIn), for: .touchUpInside)
    }
    
    // 텍스트 활성화
    @objc func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainBlack.cgColor
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.resignFirstResponder()
    }
    
    private func buttonActivated() {
        sendBtn.isEnabled = true
        UIView.animate(withDuration: 0.33) { [weak self] in
            self?.sendBtn.backgroundColor = .mainBlue
        }
    }
    private func buttonInactivated() {
        sendBtn.isEnabled = false
        UIView.animate(withDuration: 0.33) { [weak self] in
            self?.sendBtn.backgroundColor = .mainGray
        }
    }
    
    @objc func allTextFieldFilledIn() {
        
        /* 모든 textField가 채워졌으면 고객센터 버튼 활성화 */
        if self.isValidEmail,
           self.questionTypeTextField.text!.count != 0,
           self.textCount != 0 {
            
            if agreeCheckBtn.isSelected { // 정보 제공 동의 필수
                self.buttonActivated()
            }
            else { // 체크 안 했으면 무조건 비활성화
                self.buttonInactivated()
            }
        } else {
            self.buttonInactivated()
        }
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        switch sender {
        case emailTextField:
            self.isValidEmail = text.isValidEmail()
            self.email = text
            
        default:
            fatalError("Missing TextField...")
        }
    }
    
    func validateEmail() {
        if isValidEmail {
            hideAlert(textField: self.emailTextField, alertLabel: self.emailAlertLabel)
        } else {
            showAlert(textField: self.emailTextField, alertLabel: self.emailAlertLabel, status: isValidEmail)
        }
        if emailTextField.text?.count == 0 {
            hideAlert(textField: self.emailTextField, alertLabel: self.emailAlertLabel)
        }
    }
    
}
    
    private func showAlert(textField: UITextField, alertLabel: UILabel, status: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.red.cgColor
            alertLabel.alpha = 1
        }
    }
    
    private func hideAlert(textField: UITextField, alertLabel: UILabel) {
        
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.mainBlack.cgColor
            alertLabel.alpha = 0
        }
    }


// MARK: - Extension
extension ProfileServiceVC: UITextViewDelegate {
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .mainBlack
        }
        textView.layer.borderColor = UIColor.mainBlack.cgColor
    }

    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextField.text.isEmpty {
            contentTextField.text = textViewPlaceHolder
            contentTextField.textColor = UIColor.mainGray
            sendBtn.isEnabled = false
            UIView.animate(withDuration: 0.33) { [weak self] in
                self?.sendBtn.backgroundColor = .mainGray
            }
        }
        contentTextField.layer.borderColor = UIColor.mainGray.cgColor
    }

    // TextView 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if contentTextField.text.isEmpty {
            sendBtn.isEnabled = false
            UIView.animate(withDuration: 0.33) { [weak self] in
                self?.sendBtn.backgroundColor = .mainGray
            }
        }
        else if isValidEmail,
                questionTypeTextField.text?.count != 0,
                agreeCheckBtn.isSelected {
            sendBtn.isEnabled = true
            UIView.animate(withDuration: 0.33) { [weak self] in
                self?.sendBtn.backgroundColor = .mainBlue
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCount = contentTextField.text?.count ?? 0
        NotificationCenter.default.post(name: Notification.Name("textViewDidChanged"), object: textView)
    }
}

extension ProfileServiceVC {
    func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(validTextCount(_:)), name: Notification.Name("textViewDidChanged"), object: nil)
    }
    
    @objc private func validTextCount(_ notification: Notification) {
        if let textView = notification.object as? UITextView {
            if let text = textView.text {
                if text.count > maxTextCount {
                    // 100글자 넘어가면 자동으로 키보드 내려감
//                    textView.resignFirstResponder()
                }
                // 초과되는 텍스트 제거
                if text.count >= maxTextCount {
                    let index = text.index(text.startIndex, offsetBy: maxTextCount)
                    let newString = text[text.startIndex..<index]
                    textView.text = String(newString)
                }
            }
        }
    }
}

extension ProfileServiceVC {
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(viewDidQuestionTap))
        tapGestureRecognizer2.numberOfTapsRequired = 1
        tapGestureRecognizer2.isEnabled = true
        tapGestureRecognizer2.cancelsTouchesInView = false
        questionTypeTextField.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    @objc private func viewDidTap() {
        self.view.endEditing(true)
    }
    
    @objc private func viewDidQuestionTap() {
        self.view.endEditing(true)
        questionTypeTextField.layer.borderColor = UIColor.mainBlack.cgColor
        showBottomSheet()
    }
}

extension ProfileServiceVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height -= view.safeAreaInsets.top // 이 부분 조절하면서 스크롤 올리는 정도 변경
            safeArea.size.height -= headerView.frame.height // scrollView 말고 view에 headerView가 있기때문에 제외
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking
            
            // determine which UIView was selected and if it is covered by keyboard
            let activeField: UIView? = [emailTextField, contentTextField].first { $0.isFirstResponder }
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
