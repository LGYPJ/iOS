//
//  ProfileEditVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/10.
//

import UIKit

import SnapKit

class ProfileEditVC: UIViewController {
    
    // MARK: - Subviews
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 편집"
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor(hex: 0x000000,alpha: 0.8)
        button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        
        return button
    }()
    
    let profileImageView : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 50
        view.backgroundColor = .mainGray
        
        return view
    }()
    
    let profilePlusImageView = UIImageView().then {
        $0.image = UIImage(named: "ProfilePlus")
        $0.layer.cornerRadius = 11
    }
    
    let nameLabel = UILabel().then {
        $0.text = "닉네임 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let nameTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.borderStyle = .roundedRect
        $0.placeholder = "닉네임을 입럭해주세요 (최대 8글자)"
    }
    
    let orgLabel = UILabel().then {
        $0.text = "소속 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let orgTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.borderStyle = .roundedRect
        $0.placeholder = "소속을 입럭해주세요"
    }
    
    let emailLabel = UILabel().then {
        $0.text = "이메일 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let emailTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        //        $0.textColor = .mainGray
        $0.borderStyle = .roundedRect
        $0.placeholder = "이메일을 입럭해주세요"
    }
    
    let introduceLabel = UILabel().then {
        $0.text = "자기소개"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    
    let textViewPlaceHolder = "100자 이내로 작성해주세요"
    lazy var introduceTextField = UITextView().then {
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.systemGray5.cgColor // UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 8
        // $0.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 16.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14) // .systemFont(ofSize: 18)
        $0.text = textViewPlaceHolder
        $0.textColor = .mainGray
        $0.delegate = self // <-
    }
    
    let editDoneBtn = UIButton().then {
        $0.setTitle("완료하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.tintColor = .mainBlue
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 10
    }
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        configureLayouts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Functions
    func configureLayouts() {
        
        // addSubview
        [headerView, profileImageView,profilePlusImageView, nameLabel, nameTextField, orgLabel, orgTextField, emailLabel, emailTextField,introduceLabel, introduceTextField, editDoneBtn]
            .forEach {view.addSubview($0)}
        
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
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
        
        // layer
        profileImageView.snp.makeConstraints { /// 프로필 이미지
            $0.width.height.equalTo(100)
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.equalTo(16)
        }
        profilePlusImageView.snp.makeConstraints { /// 플러스 버튼
            $0.trailing.equalTo(profileImageView).offset(-2)
            $0.bottom.equalTo(profileImageView).offset(-2)
            $0.height.equalTo(22)
        }
        
        /// 닉네임
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.equalTo(profileImageView)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(48)
        }
        
        /// 소속
        orgLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.leading.equalTo(nameLabel)
        }
        
        orgTextField.snp.makeConstraints {
            $0.top.equalTo(orgLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(nameTextField)
            $0.height.equalTo(nameTextField)
        }
        
        /// 이메일
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(orgTextField.snp.bottom).offset(16)
            $0.leading.equalTo(orgLabel)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(orgTextField)
            $0.height.equalTo(nameTextField)
        }
        
        /// 별 처리
        contigureStarText()
        
        /// 자기소개
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.leading.equalTo(emailLabel)
        }
        
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(nameTextField)
            $0.height.equalTo(100)
        }
        
        
        editDoneBtn.snp.makeConstraints {
            $0.bottom.equalTo(-48)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(nameTextField)
        }
        editDoneBtn.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
    }
    
    // SubTitle 별 처리
    private func contigureStarText() {
        // NSAttributedString 객체를 만들어서 프로퍼티에 대입
        let nameText = nameLabel.text ?? ""
        let attributedString1 = NSMutableAttributedString(string: nameText)
        // NSRange값을 이용해 대입 하기 전 특정 문자열에 color 속성값을 부여
        let range1 = (nameText as NSString).range(of: "*")
        // range값을 가지고 위에서 만든 attributedString객체에 color 속성값을 추가
        attributedString1.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: range1)
        // 기존 라벨에 attributedString 객체 속성 부여
        nameLabel.attributedText = attributedString1
        
        let orgText = orgLabel.text ?? ""
        let attributedString2 = NSMutableAttributedString(string: orgText)
        let range2 = (orgText as NSString).range(of: "*")
        attributedString2.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: range2)
        orgLabel.attributedText = attributedString2
        
        let emailText = emailLabel.text ?? ""
        let attributedString3 = NSMutableAttributedString(string: emailText)
        let range3 = (emailText as NSString).range(of: "*")
        attributedString3.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: range3)
        emailLabel.attributedText = attributedString3
    }
    
    // 완료하기 버튼 did tap
    @objc private func doneButtonDidTap() {
        print("완료하기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileEditVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.font = UIFont.NotoSansKR(type: .Regular, size: 14)
            textView.textColor = .systemGray5
            //updateCountLabel(characterCount: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 100 else { return false }
        //updateCountLabel(characterCount: characterCount)
        
        return true
    }
    
}

// MARK: - Extension
extension UILabel {
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}
