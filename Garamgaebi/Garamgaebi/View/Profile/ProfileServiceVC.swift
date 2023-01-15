//
//  ProfileServiceVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/12.
//

import UIKit

class ProfileServiceVC: UIViewController {
    
    // MARK: - Subviews
    let noticeLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.text = "휴일을 제외한 평일에는 하루 이내에 답변을 드릴게요.\n혹시 하루가 지나도 답변이 오지 않으면, 스팸 메일함을 확인해주세요."
    }
    
    let emailTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.borderStyle = .roundedRect
        $0.placeholder = "답변 받을 이메일을 입력해 주세요"
    }
    
    let questionTypeTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.borderStyle = .roundedRect
        $0.placeholder = "질문 유형을 선택해주세요"
    }
    let typeSelectBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = .black
    }
    
    let textViewPlaceHolder = "내용을 적어주세요"
    lazy var contentTextField = UITextView().then {
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.systemGray5.cgColor // UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 8
        // $0.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 16.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14) // .systemFont(ofSize: 18)
        $0.text = textViewPlaceHolder
        $0.textColor = .mainGray
        $0.delegate = self // <-
    }
    
    let agreeCheckBtn = UIButton().then {
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
        $0.setTitle("보내기", for: .normal)
        $0.backgroundColor = .mainBlue
        $0.tintColor = .mainBlue
        $0.layer.cornerRadius = 10
    }
    
    let withdrawalLabel = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureLayouts()
        configureNavigationBar()
        configureNavigationBarShadow()
    }
    
    
    // MARK: - Functions
    private func configureLayouts() {
        // addSubview
        [noticeLabel, emailTextField, questionTypeTextField, typeSelectBtn, contentTextField, agreeCheckBtn, agreemsgLabel, sendBtn, withdrawalLabel]
            .forEach {view.addSubview($0)}
        
        // layout
        noticeLabel.snp.makeConstraints { /// 안내
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(14)
            $0.trailing.equalTo(-14)
        }
        
        emailTextField.snp.makeConstraints { /// 답변 받을 이메일 주소
            $0.top.equalTo(noticeLabel.snp.bottom).offset(16)
            $0.leading.equalTo(noticeLabel.snp.leading)
            $0.trailing.equalTo(noticeLabel.snp.trailing)
        }
        
        questionTypeTextField.snp.makeConstraints { /// 질문 유형 선택
            $0.top.equalTo(emailTextField.snp.bottom).offset(12)
            $0.leading.equalTo(emailTextField.snp.leading)
            $0.trailing.equalTo(emailTextField.snp.trailing)
        }
        
        typeSelectBtn.snp.makeConstraints { /// 유형 선택 화살표
            $0.centerY.equalTo(questionTypeTextField)
            $0.trailing.equalTo(questionTypeTextField.snp.trailing).inset(7)
        }
        
        contentTextField.snp.makeConstraints { /// 내용 입력
            $0.top.equalTo(questionTypeTextField.snp.bottom).offset(12)
            $0.leading.equalTo(emailTextField.snp.leading)
            $0.trailing.equalTo(emailTextField.snp.trailing)
            $0.height.equalTo(160)
        }
        
        agreeCheckBtn.snp.makeConstraints { /// 이메일 정보 제공 동의
            $0.top.equalTo(contentTextField.snp.bottom).offset(12)
            $0.leading.equalTo(emailTextField.snp.leading)
            //$0.width.equalTo(150)
            //$0.trailing.equalTo(emailTextField.snp.trailing)
        }
        agreemsgLabel.snp.makeConstraints { /// 답변 필요
            $0.top.equalTo(agreeCheckBtn.snp.bottom)
            $0.leading.equalTo(agreeCheckBtn.snp.leading).offset(20)
        }
        
        sendBtn.snp.makeConstraints { /// 메일 보내기 버튼
            $0.top.equalTo(agreemsgLabel.snp.bottom).offset(40)
            $0.leading.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField)
        }
        
        withdrawalLabel.snp.makeConstraints { /// 회원탈퇴
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.centerX.equalToSuperview()
        }
        withdrawalLabel.addTarget(self, action: #selector(didTapWithdrawalButton), for: .touchUpInside)
        
        
    }
    
    
    
    // navigation bar 구성
    private func configureNavigationBar() {
        self.navigationItem.title = "고객센터"
        let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.leftBarButtonItem?.action  = #selector(didTapBackBarButton)
        backBarButtonItem.tintColor = .black
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // navigation bar shadow 설정
    private func configureNavigationBarShadow() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()

        navigationController?.navigationBar.tintColor = .clear

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    @objc private func didTapBackBarButton() {
        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    // 회원탈퇴 버튼 did tap
    @objc private func didTapWithdrawalButton() {
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
            sender.setTitleColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), for: .normal)
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        }
    }

}

extension ProfileServiceVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
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
