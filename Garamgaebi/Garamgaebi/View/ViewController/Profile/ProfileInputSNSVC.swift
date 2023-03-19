//
//  ProfileInputSNSVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/19.
//

import UIKit

import Then
import Alamofire

class ProfileInputSNSVC: UIViewController, BottomSheetSelectDelegate {
    func textFieldChanged() {
        typeTextField.layer.borderColor = UIColor.mainGray.cgColor
        allTextFieldFilledIn()
    }
    
    // 유효성 검사
    var isValidId = true {
        didSet {
            self.validId()
        }
    }

    // MARK: - Properties
    lazy var memberIdx: Int = 0
    lazy var token = UserDefaults.standard.string(forKey: "BearerToken")
    var snsIdx: Int = 0
    var isAutoInput: Bool = false
    lazy var tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(viewDidQuestionTap))
    
    private let maxInputCount = 22
    var autoInputTextCount = 0 {
        didSet {
            if autoInputTextCount > maxInputCount {
                autoInputTextCount = maxInputCount - 1
                autoInputTextCountLabel.text = "\(autoInputTextCount + 1)/\(maxInputCount)"
            }
            else {
                autoInputTextCountLabel.text = "\(autoInputTextCount)/\(maxInputCount)"
            }
        }
    }
    private let maxLinkCount = 140
    private var linkTextCount = 0 {
        didSet {
            if linkTextCount > maxLinkCount {
                linkTextCount = maxLinkCount - 1
            }
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
        label.text = "SNS 추가하기"
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
    
    lazy var subtitleTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "SNS 종류"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    lazy var autoInputTextCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xAEAEAE)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 12)
        label.text = "\(autoInputTextCount)/\(maxInputCount)"
        label.isHidden = true
        
        return label
    }()
    
    lazy var typeTextField: UITextField = {
        let textField = UITextField()
        textField.text = ""
        textField.basicTextField()
        textField.placeholder = "표시할 이름을 입력해주세요 (예:블로그, 깃허브 등)"
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        // 글자수 계산
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    lazy var subtitleLinkLabel : UILabel = {
        let label = UILabel()
        label.text = "링크"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        
        return label
    }()
    
    lazy var linkTextField: UITextField = {
        let textField = UITextField()
        
        textField.basicTextField()
        textField.placeholder = "링크를 입력해주세요"
        
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        // 인스타 아이디 유효성
        textField.addTarget(self, action: #selector(instagramTextFieldEditingChanged(_:)), for: .editingChanged)
        // 글자수 계산
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        return textField
    }()
    lazy var instagramAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.text = "@"
        label.isHidden = true
        
        return label
    }()
    lazy var instagramIdAlertLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 10)
        $0.text = "영문문자, 숫자, -, _, . 사용 가능합니다"
        $0.textColor = .red
        $0.alpha = 0
    }
    
    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        
        button.basicButton()
        button.setTitle("저장하기", for: .normal)
        button.backgroundColor = .mainGray
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // 편집용
    lazy var editDeleteButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("삭제하기", for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.setTitleColor(.mainBlue, for: .normal)
        button.tintColor = .mainBlue
        
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        return button
    }()
    lazy var editSaveButton: UIButton = {
        let button = UIButton()
        
        button.basicButton()
        button.setTitle("저장하기", for: .normal)
        
        button.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
        return button
    }()
    lazy var editButtonStackView: UIStackView = {
        let stackView = UIStackView()
        [editDeleteButton, editSaveButton].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        
        stackView.isHidden = true
        
        return stackView
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("편집할 snsIdx: \(snsIdx)")
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        addSubViews()
        configLayouts()
        configureGestureRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setObserver()
    }
    
    // MARK: - Functions
    func addSubViews() {
        
        /* HeaderView */
        view.addSubview(headerView)
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
        /* Buttons */
        view.addSubview(linkTextField)
        view.addSubview(typeTextField)
        view.addSubview(saveUserProfileButton)
        view.addSubview(editButtonStackView)
        
        
        /* Labels */
        [subtitleLinkLabel,subtitleTypeLabel, autoInputTextCountLabel, instagramAtLabel, instagramIdAlertLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        
        typeTextField.delegate = self
        linkTextField.delegate = self
        
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
        
        // subtitleTypeLabel
        subtitleTypeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(headerView.snp.bottom).offset(16)
        }
        autoInputTextCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(subtitleTypeLabel)
            make.right.equalToSuperview().inset(16)
        }
        
        // typeTextField
        typeTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleTypeLabel.snp.bottom).offset(8)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitleLinkLabel
        subtitleLinkLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleTypeLabel.snp.left)
            make.top.equalTo(typeTextField.snp.bottom).offset(28)
        }
        
        // linkTextField
        linkTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLinkLabel.snp.bottom).offset(8)
            make.height.equalTo(48)
            make.left.right.equalTo(typeTextField)
        }
        instagramAtLabel.snp.makeConstraints { make in
            make.centerY.equalTo(linkTextField)
            make.left.equalTo(linkTextField).offset(12)
        }
        instagramIdAlertLabel.snp.makeConstraints { make in
            make.left.equalTo(linkTextField)
            make.top.equalTo(linkTextField.snp.bottom).offset(2)
        }
        
        
        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        // editButtonStackView
        editButtonStackView.snp.makeConstraints { make in
            make.left.right.equalTo(saveUserProfileButton)
            make.bottom.equalTo(saveUserProfileButton)
            make.height.equalTo(48)
        }
    }
    
    func typeSelect(type: String) { // 선택한 SNS 유형
        switch(type) {
        case "인스타그램":
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.typeTextField.text = type
                self?.linkTextField.placeholder = "인스타그램 아이디를 입력해주세요"
                // 링크 입력
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: (self?.linkTextField.frame.height)!))
                self?.linkTextField.leftView = paddingView
                // 골뱅이 표시
                self?.instagramAtLabel.isHidden = false
            }
            
        case "직접 입력":
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.typeTextField.text = nil
                self?.typeTextField.placeholder = "SNS 종류를 직접 입력해주세요"
                self?.isAutoInput = true
                self?.autoInputTextCountLabel.isHidden = false
                //
                self?.linkTextField.basicTextField()
                self?.instagramAtLabel.isHidden = true
                self?.instagramIdAlertLabel.alpha = 0
                self?.typeTextField.removeGestureRecognizer(self!.tapGestureRecognizer2)
            }
            // 글자수 계산
            self.typeTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            
        default:
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.typeTextField.text = type
                self?.linkTextField.placeholder = "링크를 입력해주세요"
                //
                self?.linkTextField.basicTextField()
                self?.instagramAtLabel.isHidden = true
                self?.instagramIdAlertLabel.alpha = 0
            }
        }
    }
    
    // 바텀시트 나타내기
    @objc private func showBottomSheet() {
        let bottomSheetVC = BottomSheetVC()

        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.delegate = self
        
        bottomSheetVC.titleText = "SNS 종류"
        bottomSheetVC.T1 = "인스타그램"
        bottomSheetVC.T2 = "블로그"
        bottomSheetVC.T3 = "깃허브"
        bottomSheetVC.T4 = "직접 입력"
        self.present(bottomSheetVC, animated: false, completion: nil)
        self.view.endEditing(true)
    }
    
    // sns 추가 버튼
    @objc private func saveButtonDidTap(_ sender: UIButton) {
        guard let type = typeTextField.text else { return }
        var address = linkTextField.text ?? ""
        if type == "인스타그램" {
            address = "@" + address
        }
        
        ProfileHistoryViewModel.postSNS(memberIdx: memberIdx, type: type, address: address ) { result in
            if result {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    // sns 수정 버튼
    @objc private func editButtonDidTap(_ sender: UIButton) {
        guard let type = typeTextField.text else { return }
        var address = linkTextField.text ?? ""
        if type == "인스타그램" {
            address = "@" + address
        }
        
        ProfileHistoryViewModel.patchSNS(snsIdx: snsIdx, type: type, address: address ) { result in
            if result {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    // sns 삭제 버튼
    @objc private func deleteButtonDidTap(_ sender: UIButton) {
        // 삭제 동의 다이얼로그
        let deleteCheckAlert = UIAlertController(title: "삭제하시겠습니까?", message: "", preferredStyle: .alert)
        // 삭제 확인 다이얼로그
        let alert = UIAlertController(title: "삭제가 완료되었습니다.", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "닫기", style: .default) { (_) in
            // 닫기 누르면 이전 화면으로
            self.navigationController?.popViewController(animated: true)
        }
        
        // 삭제 동의 선택지
        let deleteNoAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let deleteYesAlertAction = UIAlertAction(title: "예", style: .default) { [self] (_) in
            // 삭제 진행
            ProfileHistoryViewModel.deleteSNS(snsIdx: self.snsIdx) { [self] result in
                if result {
                    // 삭제 확인 다이얼로그 띄우기
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        // 삭제 동의 다이얼로그 띄우기
        deleteCheckAlert.addAction(deleteNoAction)
        deleteCheckAlert.addAction(deleteYesAlertAction)
        self.present(deleteCheckAlert, animated: true, completion: nil)
    }
    
    private func buttonActivated() {
        saveUserProfileButton.isEnabled = true
        editSaveButton.isEnabled = true
        UIView.animate(withDuration: 0.33) { [weak self] in
            self?.saveUserProfileButton.backgroundColor = .mainBlue
            self?.editSaveButton.backgroundColor = .mainBlue
        }
    }
    private func buttonInactivated() {
        saveUserProfileButton.isEnabled = false
        UIView.animate(withDuration: 0.33) { [weak self] in
            self?.saveUserProfileButton.backgroundColor = .mainGray
            self?.editSaveButton.backgroundColor = .mainGray
        }
    }
    
    private func validId() {
        if isValidId {
            hideAlert(textField: self.linkTextField, alertLabel: self.instagramIdAlertLabel)
        } else {
            showAlert(textField: self.linkTextField, alertLabel: self.instagramIdAlertLabel, status: self.isValidId)
        }
    }
    
    private func showAlert(textField: UITextField, alertLabel: UILabel, status: Bool) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.red.cgColor
            alertLabel.alpha = 1
        }
        self.buttonInactivated()
    }
    
    private func hideAlert(textField: UITextField, alertLabel: UILabel) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.mainBlack.cgColor
            alertLabel.alpha = 0
        }
    }
    
    @objc func allTextFieldFilledIn() {
        
        /* 모든 textField가 채워졌으면 SNS 저장 버튼 활성화 */
        if self.typeTextField.text!.count != 0,
           self.linkTextField.text?.count != 0 {
            if typeTextField.text == "인스타그램" {
                print("인스타그램")
                if self.isValidId {
                    buttonActivated()
                } else {
                    buttonInactivated()
                }
            } else {
                buttonActivated()
            }
        } else { // 저장버튼 비활성화
            buttonInactivated()
        }
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainBlack.cgColor
        sender.layer.borderWidth = 1
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
    }
    
    @objc func instagramTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        switch sender {
        case linkTextField:
            if (typeTextField.text == "인스타그램") {
                self.isValidId = text.isValidInstagramId()
            }
        default:
            fatalError("Missing TextField...")
        }
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension
extension ProfileInputSNSVC: UITextFieldDelegate {
    // Return 키
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // TextField 비활성화
        return true
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer2.numberOfTapsRequired = 1
        tapGestureRecognizer2.isEnabled = true
        tapGestureRecognizer2.cancelsTouchesInView = false
        if (isAutoInput == false) { // SNS 유형이 직접 입력이 아니라면
            typeTextField.addGestureRecognizer(tapGestureRecognizer2)
        }
    }
    
    @objc private func viewDidTap() {
        self.view.endEditing(true)
    }
    
    @objc private func viewDidQuestionTap() {
        typeTextField.layer.borderColor = UIColor.mainBlack.cgColor
        if (isAutoInput == false) {
            typeTextField.addGestureRecognizer(tapGestureRecognizer2)
            showBottomSheet()
            self.view.endEditing(true)
        }
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        switch sender {
        case typeTextField:
            autoInputTextCount = typeTextField.text?.count ?? 0
            NotificationCenter.default.post(name: Notification.Name("textDidChange"), object: sender)
        case linkTextField:
            linkTextCount = linkTextField.text?.count ?? 0
            NotificationCenter.default.post(name: Notification.Name("textDidChange"), object: sender)
        default:
            print(">>>ERROR: typeText ProfileSNSVC")
        }
    }
    
    func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(validTextCount(_:)), name: Notification.Name("textDidChange"), object: nil)
    }
    
    @objc private func validTextCount(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            // typeTextField일 때 (SNS 직접 입력)
            if textField == typeTextField {
                if let text = textField.text {
                    if text.count > maxInputCount {
                        // 최대글자 넘어가면 자동으로 키보드 내려감
//                        textField.resignFirstResponder()
                    }
                    // 초과되는 텍스트 제거
                    if text.count >= maxInputCount {
                        let index = text.index(text.startIndex, offsetBy: maxInputCount)
                        let newString = text[text.startIndex..<index]
                        textField.text = String(newString)
                    }
                }
            }
            // linkTextField일 때
            if textField == linkTextField {
                if let text = textField.text {
                    if text.count > maxLinkCount {
                        // 최대글자 넘어가면 자동으로 키보드 내려감
//                        textField.resignFirstResponder()
                    }
                    // 초과되는 텍스트 제거
                    if text.count >= maxLinkCount {
                        let index = text.index(text.startIndex, offsetBy: maxLinkCount)
                        let newString = text[text.startIndex..<index]
                        textField.text = String(newString)
                    }
                }
            }
        }
    }
}
