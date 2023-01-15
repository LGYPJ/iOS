//
//  ProfileWithdrawalVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/15.
//

import UIKit

class ProfileWithdrawalVC: UIViewController {
    
    // MARK: - Subviews
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
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .systemGray5
        $0.text = "umc@gmail.com"
        $0.isUserInteractionEnabled = false
    }
    
    let reasonTitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.text = "탈퇴 사유"
    }
    
    let reasonTypeTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.borderStyle = .roundedRect
        $0.placeholder = "탈퇴 사유를 선택해주세요"
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
        //$0.delegate = self // <-
    }
    
    let agreeCheckBtn = UIButton().then {
        $0.setTitle("회원 탈퇴에 관한 모든 내용을 숙지하고,", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square")?.withRenderingMode(.automatic), for: .selected)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        $0.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
    }
    
    let agreemsgLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.numberOfLines = 0
        $0.text = "회원 탈퇴를 신청합니다."
        $0.textColor = UIColor(hex: 0x8A8A8A)
    }
    
    let sendBtn = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.backgroundColor = .mainBlue
        $0.tintColor = .mainBlue
        $0.layer.cornerRadius = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureNavigationBarShadow()
        configureLayouts()
    }
    
    
    
    // MARK: - Functions
    private func configureLayouts() {
        // addSubview
        [noticeTitleLabel, noticeLabel, emailTitleLabel, emailTextField, reasonTitleLabel, reasonTypeTextField, typeSelectBtn, contentTextField, agreeCheckBtn, agreemsgLabel, sendBtn]
            .forEach {view.addSubview($0)}
        
        // layout
        noticeTitleLabel.snp.makeConstraints { /// 유의사항
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(14)
            $0.trailing.equalTo(-14)
        }
        noticeLabel.snp.makeConstraints { /// 안내
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(noticeTitleLabel)
            $0.trailing.equalTo(noticeTitleLabel)
        }
        
        emailTitleLabel.snp.makeConstraints { /// 계정 이메일
            $0.top.equalTo(noticeLabel.snp.bottom).offset(16)
            $0.leading.equalTo(noticeLabel.snp.leading)
            $0.trailing.equalTo(noticeLabel.snp.trailing)
        }
        emailTextField.snp.makeConstraints { /// 탈퇴할 이메일 주소
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(emailTitleLabel.snp.leading)
            $0.trailing.equalTo(emailTitleLabel.snp.trailing)
            $0.height.equalTo(45)
        }
        
        reasonTitleLabel.snp.makeConstraints { /// 탈퇴 사유
            $0.top.equalTo(emailTextField.snp.bottom).offset(12)
            $0.leading.equalTo(emailTextField.snp.leading)
            $0.trailing.equalTo(emailTextField.snp.trailing)
        }
        reasonTypeTextField.snp.makeConstraints { /// 탈퇴 사유 입력
            $0.top.equalTo(reasonTitleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(reasonTitleLabel.snp.leading)
            $0.trailing.equalTo(reasonTitleLabel.snp.trailing)
            $0.height.equalTo(45)
        }
        
        typeSelectBtn.snp.makeConstraints { /// 유형 선택 화살표
            $0.centerY.equalTo(reasonTypeTextField)
            $0.trailing.equalTo(reasonTypeTextField.snp.trailing).inset(7)
        }
        
        contentTextField.snp.makeConstraints { /// 내용 입력
            $0.top.equalTo(reasonTypeTextField.snp.bottom).offset(12)
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
        
        sendBtn.snp.makeConstraints { /// 회원탈퇴 버튼
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.leading.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField)
            $0.height.equalTo(45)
        }
        
        
    }
    
    
    
    // navigation bar 구성
    private func configureNavigationBar() {
        self.navigationItem.title = "회원 탈퇴"
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
        self.navigationController?.popViewController(animated: false)
    }
    
    // 회원탈퇴 버튼 did tap
    @objc private func didTapWithdrawalButton() {
        print("회원탈퇴 버튼 클릭")
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.isSelected {
        case true:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
            //sender.setTitleColor(UIColor(hex: 0x000000).withAlphaComponent(0.8), for: .normal)
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        }
    }
    

}
