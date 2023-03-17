//
//  ProfileWithdrawalVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/15.
//

import UIKit
import SnapKit
import Then
import KakaoSDKUser

class ProfileWithdrawalVC: UIViewController, BottomSheetSelectDelegate {
    func textFieldChanged() {
        reasonTypeTextField.layer.borderColor = UIColor.mainGray.cgColor
        allTextFieldFilledIn()
    }
    
    // MARK: - Properties
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
    private var category: String = ""
    
    // MARK: - Subviews
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 탈퇴"
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
    
    let noticeTitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.text = "탈퇴 시 유의사항"
    }
    
    let noticeLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.text = "탈퇴 시 회원 정보 및 모든 서비스의 이용 내역이 삭제됩니다. 삭제된 데이터는 복구가 불가능합니다."
    }
    
    let emailTitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.text = "계정 이메일"
    }
    
    let emailTextField = UITextField().then {
        guard let uniEmail = UserDefaults.standard.string(forKey: "uniEmail") else { return }
        $0.basicTextField()
        $0.backgroundColor = UIColor(hex: 0xF5F5F5)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.text = uniEmail
        $0.textColor = UIColor(hex: 0xAEAEAE)
        $0.isUserInteractionEnabled = false // uniEmail 수정 불가
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor
    }
    
    let reasonTitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.text = "탈퇴 사유"
    }
    
    lazy var reasonTypeTextField = UITextField().then {
        $0.basicTextField()
        $0.placeholder = "탈퇴 사유를 선택해주세요"
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
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 8.0, bottom: 12.0, right: 8.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.text = textViewPlaceHolder
        $0.textColor = .mainGray
        $0.delegate = self // <-
        $0.isHidden = true
    }
    lazy var contentLengthLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 12)
        $0.textColor = UIColor(hex: 0xAEAEAE)
        $0.text = "\(textCount)/100"
        $0.isHidden = true
    }
    
    lazy var agreeCheckBtn = UIButton().then {
        $0.setTitle("회원 탈퇴에 관한 모든 내용을 숙지하고,", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square")?.withRenderingMode(.automatic), for: .selected)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        $0.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        $0.addTarget(self, action: #selector(allTextFieldFilledIn), for: .touchUpInside)
    }
    
    let agreemsgLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.text = "회원 탈퇴를 신청합니다."
        $0.textColor = UIColor(hex: 0x8A8A8A)
    }
    
    lazy var sendBtn = UIButton().then {
        $0.basicButton()
        $0.setTitle("탈퇴하기", for: .normal)
        
        $0.backgroundColor = .mainGray
        $0.isEnabled = false
        
        $0.addTarget(self, action: #selector(withdrawalButtonDidTap), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayouts()
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
        [noticeTitleLabel, noticeLabel, emailTitleLabel, emailTextField, reasonTitleLabel, reasonTypeTextField, contentTextField, agreeCheckBtn, agreemsgLabel]
            .forEach {contentView.addSubview($0)}
        view.addSubview(sendBtn)
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
            $0.bottom.equalTo(sendBtn.snp.top)
        }
        
        // contentView
        contentView.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.bottom.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(scrollView)
        }
        
        noticeTitleLabel.snp.makeConstraints { /// 유의사항
            $0.top.equalTo(scrollView).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(16)
        }
        noticeLabel.snp.makeConstraints { /// 안내
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(noticeTitleLabel)
        }
        
        emailTitleLabel.snp.makeConstraints { /// 계정 이메일
            $0.top.equalTo(noticeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(noticeLabel)
        }
        emailTextField.snp.makeConstraints { /// 탈퇴할 이메일 주소
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(emailTitleLabel)
            $0.height.equalTo(48)
        }
        
        reasonTitleLabel.snp.makeConstraints { /// 탈퇴 사유
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(emailTextField)
        }
        
        contentLengthLabel.snp.makeConstraints { /// 글자수 계산
            $0.centerY.equalTo(reasonTitleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        reasonTypeTextField.snp.makeConstraints { /// 탈퇴 사유 입력
            $0.top.equalTo(reasonTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(reasonTitleLabel)
            $0.height.equalTo(48)
        }
        
        contentTextField.snp.makeConstraints { /// 내용 입력
            $0.top.equalTo(reasonTypeTextField.snp.bottom).offset(0)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(0)
        }
        
        agreeCheckBtn.snp.makeConstraints { /// 회원탈퇴 내용 숙지
            $0.top.equalTo(contentTextField.snp.bottom).offset(8)
            $0.leading.equalTo(emailTextField.snp.leading)
        }
        agreemsgLabel.snp.makeConstraints { /// 회원탈퇴 신청
            $0.top.equalTo(agreeCheckBtn.snp.bottom)
            $0.leading.equalTo(agreeCheckBtn.snp.leading).offset(23)
        }
        
        sendBtn.snp.makeConstraints { /// 회원탈퇴 버튼
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalTo(emailTextField)
        }
        
    }
    
    func typeSelect(type: String) {
        self.reasonTypeTextField.text = type
        if (agreeCheckBtn.isSelected &&
            type != "기타") {
            buttonActivated()
        }
        if (type == "기타") {
            contentTextField.snp.updateConstraints { // 내용 입력 표시
                $0.height.equalTo(100)
                $0.top.equalTo(self.reasonTypeTextField.snp.bottom).offset(16)
            }
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.contentTextField.isHidden = false
                self?.contentLengthLabel.isHidden = false
            }
            if (textCount == 0) { // 이전 입력 텍스트가 없다면
                buttonInactivated()
            }
        } else {
            contentTextField.snp.updateConstraints { // 내용 입력 표시 X
                $0.height.equalTo(0)
                $0.top.equalTo(reasonTypeTextField.snp.bottom).offset(0)
            }
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.contentTextField.isHidden = true
                self?.contentLengthLabel.isHidden = true
            }
        }
        switch(type) {
        case "이용이 불편해서":
            category = "UNCOMFORTABLE"
        case "사용 빈도가 낮아서":
            category = "UNUSED"
        case "콘텐츠 내용이 부족해서":
            category = "CONTENT_LACK"
        default:
            category = "ETC"
        }
        
    }
    
    // 바텀시트 나타내기
    @objc private func showBottomSheet() {
        let bottomSheetVC = BottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.delegate = self
        
        bottomSheetVC.titleText = "탈퇴 사유를 선택해주세요"
        bottomSheetVC.T1 = "이용이 불편해서"
        bottomSheetVC.T2 = "사용 빈도가 낮아서"
        bottomSheetVC.T3 = "콘텐츠 내용이 부족해서"
        bottomSheetVC.T4 = "기타"
        
        self.present(bottomSheetVC, animated: false) {
            self.reasonTypeTextField.layer.borderColor = UIColor.mainBlack.cgColor
        }
        self.view.endEditing(true)
    }
    
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 회원탈퇴 버튼 did tap
    @objc private func withdrawalButtonDidTap() {
        let memberIdx = UserDefaults.standard.integer(forKey: "memberIdx")
        var content = contentTextField.text
        if contentTextField.textColor == .mainGray {
            content = "nil"
        }
        
        // 회원탈퇴 동의 다이얼로그
        let withdrawalCheckAlert = UIAlertController(title: "탈퇴하시겠습니까?", message: "", preferredStyle: .alert)
        // 회원탈퇴 선택지
        let withdrawalNoAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let withdrawalYesAction = UIAlertAction(title: "예", style: .default) { [self] (_) in
            ProfileServiceViewModel.postWithdrawl(memberIdx: memberIdx, content: content, category: category) { result in
                if result {
                    // 회원 탈퇴가 끝나면 간편 로그인 화면으로 이동
                    let nextVC = LoginVC(pushProgramIdx: nil, pushProgramtype: nil)
                    
                    // kakao unlink
                    UserApi.shared.unlink {(error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("unlink() success.")
                        }
                    }
                    
                    nextVC.modalPresentationStyle = .currentContext
                    self.present(nextVC, animated: true)
                }
            }
        }
        // 회원탈퇴 동의 다이얼로그 띄우기
        withdrawalCheckAlert.addAction(withdrawalNoAction)
        withdrawalCheckAlert.addAction(withdrawalYesAction)
        self.present(withdrawalCheckAlert, animated: true, completion: nil)
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
        if self.reasonTypeTextField.text!.count != 0,
           self.agreeCheckBtn.isSelected { // 탈퇴 내용 숙지 동의 필수
            
            if reasonTypeTextField.text == "기타" { // 탈퇴 사유가 기타이면 내용 입력 글자가 있어야 버튼 활성화
                
                if textCount != 0 {
                    buttonActivated()
                }
                else {
                    buttonInactivated()
                }
            } else {
                buttonActivated()
            }
        } else {
            buttonInactivated()
        }
    }
}
// MARK: - Extension
extension ProfileWithdrawalVC: UITextViewDelegate {
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
            contentTextField.textColor = .mainGray
            buttonInactivated()
        }
        contentTextField.layer.borderColor = UIColor.mainGray.cgColor
    }

    // TextView 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if contentTextField.text.isEmpty {
            buttonInactivated()
        }
        else if reasonTypeTextField.text?.count != 0,
                contentTextField.text.count != 0,
                agreeCheckBtn.isSelected {
            buttonActivated()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCount = contentTextField.text?.count ?? 0
        NotificationCenter.default.post(name: Notification.Name("textViewDidChanged"), object: textView)
    }
}

extension ProfileWithdrawalVC {
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


extension ProfileWithdrawalVC {
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(viewDidQuestionTap))
        tapGestureRecognizer2.numberOfTapsRequired = 1
        tapGestureRecognizer2.isEnabled = true
        tapGestureRecognizer2.cancelsTouchesInView = false
        reasonTypeTextField.addGestureRecognizer(tapGestureRecognizer2)
        
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewDidTap() {
        self.view.endEditing(true)
    }
    
    @objc private func viewDidQuestionTap() {
        self.view.endEditing(true)
        reasonTypeTextField.layer.borderColor = UIColor.mainBlack.cgColor
        showBottomSheet()
    }
}

extension ProfileWithdrawalVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height -= view.safeAreaInsets.top // 이 부분 조절하면서 스크롤 올리는 정도 변경
            safeArea.size.height -= headerView.frame.height // scrollView 말고 view에 headerView가 있기때문에 제외
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking
            
            // determine which UIView was selected and if it is covered by keyboard
            let activeField: UIView? = [contentTextField].first { $0.isFirstResponder }
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
