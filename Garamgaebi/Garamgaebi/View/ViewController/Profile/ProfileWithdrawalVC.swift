//
//  ProfileWithdrawalVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/15.
//

import UIKit
import SnapKit
import Then

class ProfileWithdrawalVC: UIViewController {
    
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
        $0.basicTextField()
        $0.backgroundColor = .mainGray
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.text = "umc@gmail.com"
        $0.isUserInteractionEnabled = false
    }
    
    let reasonTitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        $0.text = "탈퇴 사유"
    }
    
    let reasonTypeTextField = UITextField().then {
        $0.basicTextField()
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.placeholder = "탈퇴 사유를 선택해주세요"
    }
    let typeSelectBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = .black
    }
    
    let textViewPlaceHolder = "내용을 적어주세요"
    lazy var contentTextField = UITextView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor // UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 12
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
        $0.basicButton()
        $0.setTitle("탈퇴하기", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayouts()
    }
    
    
    
    // MARK: - Functions
    private func configureLayouts() {
        // addSubview
        [headerView, noticeTitleLabel, noticeLabel, emailTitleLabel, emailTextField, reasonTitleLabel, reasonTypeTextField, typeSelectBtn, contentTextField, agreeCheckBtn, agreemsgLabel, sendBtn]
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
        
        noticeTitleLabel.snp.makeConstraints { /// 유의사항
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        noticeLabel.snp.makeConstraints { /// 안내
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(10)
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
        reasonTypeTextField.snp.makeConstraints { /// 탈퇴 사유 입력
            $0.top.equalTo(reasonTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(reasonTitleLabel)
            $0.height.equalTo(48)
        }
        
        typeSelectBtn.snp.makeConstraints { /// 유형 선택 화살표
            $0.centerY.equalTo(reasonTypeTextField)
            $0.trailing.equalTo(reasonTypeTextField.snp.trailing).inset(7)
        }
        
        contentTextField.snp.makeConstraints { /// 내용 입력
            $0.top.equalTo(reasonTypeTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(160)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(39)
            $0.leading.trailing.equalTo(emailTextField)
        }
        sendBtn.addTarget(self, action: #selector(withdrawalButtonDidTap), for: .touchUpInside)
        
    }
    
    @objc private func didTapBackBarButton() {
        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: false)
    }
    
    // 회원탈퇴 버튼 did tap
    @objc private func withdrawalButtonDidTap() {
        print("회원탈퇴 버튼 클릭")
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func toggleButton(_ sender: UIButton) {
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
    

}
