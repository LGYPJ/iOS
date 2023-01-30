//
//  ProfileServiceVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/12.
//

import UIKit
import SnapKit
import Then

class ProfileServiceVC: UIViewController, SelectServiceDataDelegate {
    
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
    
    let noticeLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.textColor = UIColor.mainBlack
        $0.text = "휴일을 제외한 평일에는 하루 이내에 답변을 드릴게요.\n혹시 하루가 지나도 답변이 오지 않으면, 스팸 메일함을 확인해주세요."
    }
    
    lazy var emailTextField = UITextField().then {
        $0.basicTextField()
        $0.placeholder = "답변 받을 이메일 주소"
        
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
    }
    
    lazy var questionTypeTextField = UITextField().then {
        $0.basicTextField()
        $0.placeholder = "질문 유형을 선택해주세요"
        
        let typeSelectBtn = UIButton()
        typeSelectBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        typeSelectBtn.tintColor = .mainBlack
        
        $0.addSubview(typeSelectBtn)
        typeSelectBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(35)
        }
        
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        $0.addTarget(self, action: #selector(showBottomSheet), for: .editingDidBegin)
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
    
    lazy var agreeCheckBtn = UIButton().then {
        $0.setTitle("이메일 정보 제공 동의", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .automatic), for: .selected)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        $0.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
    }
    
    let agreemsgLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.text = "답변을 보내드리기 위해 필요해요"
        $0.textColor = UIColor(hex: 0x8A8A8A)
    }
    
    let sendBtn = UIButton().then {
        $0.basicButton()
        $0.setTitle("보내기", for: .normal)
    }
    
    let logoutLabel = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.setTitleColor(UIColor(hex: 0xAEAEAE), for: .normal)
    }
    
    let withdrawalLabel = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.setTitleColor(UIColor(hex: 0xAEAEAE), for: .normal)
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        configureLayouts()
        
    }
    
    
    // MARK: - Functions
    private func configureLayouts() {
        // addSubview
        [headerView, noticeLabel, emailTextField, questionTypeTextField, contentTextField, agreeCheckBtn, agreemsgLabel, sendBtn, logoutLabel, withdrawalLabel]
            .forEach {view.addSubview($0)}
        
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
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
        
        noticeLabel.snp.makeConstraints { /// 안내
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)

        }
        
        emailTextField.snp.makeConstraints { /// 답변 받을 이메일 주소
            $0.top.equalTo(noticeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(noticeLabel)
            $0.height.equalTo(48)
        }
        
        questionTypeTextField.snp.makeConstraints { /// 질문 유형 선택
            $0.top.equalTo(emailTextField.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(48)
        }
        
        contentTextField.snp.makeConstraints { /// 내용 입력
            $0.top.equalTo(questionTypeTextField.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(160)
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
            $0.bottom.equalTo(withdrawalLabel.snp.top)
            $0.centerX.equalTo(withdrawalLabel)
        }
        
        withdrawalLabel.snp.makeConstraints { /// 회원탈퇴
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.centerX.equalToSuperview()
        }
        withdrawalLabel.addTarget(self, action: #selector(withdrawalButtonDidTap), for: .touchUpInside)
        
        
    }
    
    func typeSelect(questype: String) {
        self.questionTypeTextField.text = questype
    }
    
    // 바텀시트 나타내기
    @objc private func showBottomSheet() {
        let bottomSheetVC = ServiceBottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.delegate = self
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    // 회원탈퇴 버튼 did tap
    @objc private func withdrawalButtonDidTap() {
        print("회원탈퇴 버튼 클릭")
        
        // 화면 전환
        let nextVC = ProfileWithdrawalVC()
        navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @objc
    private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.isSelected {
        case true:
            sender.setTitleColor(UIColor.mainBlack, for: .normal)
            agreemsgLabel.textColor = .mainBlack
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
            agreemsgLabel.textColor = UIColor(hex: 0x8A8A8A)
        }
    }
    

    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    // 텍스트 활성화
    @objc func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainBlack.cgColor
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
    }
}

extension ProfileServiceVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .mainBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.font = UIFont.NotoSansKR(type: .Regular, size: 14)
            textView.textColor = .mainGray
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
