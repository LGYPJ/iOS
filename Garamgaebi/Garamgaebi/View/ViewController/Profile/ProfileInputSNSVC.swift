//
//  ProfileInputSNSVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/19.
//

import UIKit

import Then
import Alamofire

class ProfileInputSNSVC: UIViewController, SelectServiceDataDelegate {

    // MARK: - Properties
    lazy var memberIdx: Int = 0
    lazy var token = UserDefaults.standard.string(forKey: "BearerToken")
    
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
    
    lazy var typeTextField: UITextField = {
        let textField = UITextField()
        
        textField.basicTextField()
        textField.placeholder = "표시할 이름을 입력해주세요 (예:블로그, 깃허브 등)"
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(showBottomSheet), for: .editingDidBegin)
        
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
        textField.placeholder = "https://"
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        
        return textField
    }()
    
    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        
        button.basicButton()
        button.setTitle("저장하기", for: .normal)
        
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        addSubViews()
        configLayouts()

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
        
        
        /* Labels */
        [subtitleLinkLabel,subtitleTypeLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        
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
        
        // typeTextField
        typeTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleTypeLabel.snp.bottom).offset(4)
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
            make.top.equalTo(subtitleLinkLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalTo(typeTextField)
        }
        
        
        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
        }
    }
    
    func typeSelect(type: String) {
        self.typeTextField.text = type
    }
    
    // 바텀시트 나타내기
    @objc private func showBottomSheet() {
        let bottomSheetVC = BottomSheetVC()

        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.delegate = self
        
        bottomSheetVC.titleText = "SNS 종류"
        bottomSheetVC.T1 = "인스타"
        bottomSheetVC.T2 = "블로그"
        bottomSheetVC.T3 = "깃허브"
        bottomSheetVC.T4 = "직접 입력"
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    @objc private func saveButtonDidTap(_ sender: UIButton) {
        guard let address = linkTextField.text else { return }
        postSNS(memberIdx: memberIdx, address: address) { result in
            if result {
                self.navigationController?.popViewController(animated: true)
            }
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
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - [POST] SNS 추가
    func postSNS(memberIdx: Int, address: String, completion: @escaping ((Bool) -> Void)) {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/sns"
        
        // http 요청 헤더 지정
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token ?? "")"
        ]
        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "address": address,
        ]
        
        // httpBody 에 parameters 추가
        AF.request(
            url,
            method: .post,
            parameters: bodyData,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: ProfilePostResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    print("성공(SNS추가): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(SNS추가): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-SNS추가): \(error.localizedDescription)")
            }
        }
    }
}
