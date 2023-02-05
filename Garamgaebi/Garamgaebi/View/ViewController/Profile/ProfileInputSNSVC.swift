//
//  ProfileInputSNSVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/19.
//

import UIKit

import Then
import Alamofire

class ProfileInputSNSVC: UIViewController {

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
        label.text = "SNS"
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
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
    
    lazy var subtitleLinkLabel: UILabel = {
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
    
    lazy var subtitleNameLabel : UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.basicTextField()
        textField.placeholder = "표시할 이름을 입력해주세요 (예:블로그, 깃허브 등)"
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        print("2: viewWillDisappear()")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        print("2: viewDidDisappear()")
    }
    
    // MARK: - Functions
    
    func addSubViews() {
        
        /* HeaderView */
        view.addSubview(headerView)
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
        /* Buttons */
        view.addSubview(linkTextField)
        view.addSubview(nameTextField)
        view.addSubview(saveUserProfileButton)
        
        
        /* Labels */
        [subtitleLinkLabel,subtitleNameLabel].forEach {
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
        
        // subtitleLinkLabel
        subtitleLinkLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(headerView.snp.bottom).offset(16)
        }
        
        // linkTextField
        linkTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLinkLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitleNameLabel
        subtitleNameLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleLinkLabel.snp.left)
            make.top.equalTo(linkTextField.snp.bottom).offset(28)
        }
        
        // nameTextField
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleNameLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalTo(linkTextField)
        }
        
        
        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
        }
    }
    
    @objc private func saveButtonDidTap(_ sender: UIButton) {
//        print("저장하기 버튼 클릭")
        guard let address = linkTextField.text else { return }
        postSNS(memberIdx: memberIdx, address: address)
                       
        self.navigationController?.popViewController(animated: true)
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
//        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - [POST] SNS 추가
    func postSNS(memberIdx: Int, address: String) {
        
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
                } else {
                    print("실패(SNS추가): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-SNS추가): \(error.localizedDescription)")
            }
        }
    }
}
