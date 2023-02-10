//
//  InputOrganizationVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/12.
//

import UIKit
import SnapKit

class InputOrganizationVC: UIViewController {
    

    // MARK: - Subviews
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage4"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "소속을 입력해주세요"
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필에 기재할\n본인의 소속을 알려주세요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    
    lazy var presentCareerButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = UILabel()
        buttonTitle.text = "경력"
        buttonTitle.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        buttonTitle.textColor = .mainBlack
        
        let buttonDescription = UILabel()
        buttonDescription.text = "본인의 경력을\n적어주세요"
        buttonDescription.numberOfLines = 0
        buttonDescription.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        buttonDescription.textColor = UIColor(hex: 0x8A8A8A)
        
        let buttonImage = UIImageView(image: UIImage(named: "careerIcon"))
        buttonImage.tintColor = .mainBlack
        buttonImage.contentMode = .scaleAspectFit
        
        [buttonTitle, buttonDescription, buttonImage].forEach {
            button.addSubview($0)
        }
        
        buttonImage.snp.makeConstraints { make in
            make.width.equalTo(36.67)
            make.height.equalTo(30)
            make.top.equalToSuperview().inset(21)
            make.left.equalToSuperview().inset(17.66)
        }
        buttonTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonDescription.snp.top).offset(-4)
        }
        buttonDescription.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(16)
        }
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.5).cgColor
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectContent), for: .touchUpInside)
        return button
    }()
    
    lazy var presentEducationButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = UILabel()
        buttonTitle.text = "교육"
        buttonTitle.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        buttonTitle.textColor = .mainBlack
        
        let buttonDescription = UILabel()
        buttonDescription.text = "본인이 받은 교육을\n적어주세요"
        buttonDescription.numberOfLines = 0
        buttonDescription.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        buttonDescription.textColor = UIColor(hex: 0x8A8A8A)
        
        let buttonImage = UIImageView(image: UIImage(named: "educationIcon"))
        buttonImage.tintColor = .mainBlack
        buttonImage.contentMode = .scaleAspectFit
        
        [buttonTitle, buttonDescription, buttonImage].forEach {
            button.addSubview($0)
        }
        
        buttonImage.snp.makeConstraints { make in
            make.width.equalTo(36.67)
            make.height.equalTo(30)
            make.top.equalToSuperview().inset(21)
            make.left.equalToSuperview().inset(17.66)
        }
        buttonTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonDescription.snp.top).offset(-4)
        }
        buttonDescription.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(16)
        }
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.5).cgColor
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectContent), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainGray // 비활성화
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configLayouts()
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        /* Buttons */
        view.addSubview(pagingImage)
        view.addSubview(presentEducationButton)
        view.addSubview(presentCareerButton)
        view.addSubview(nextButton)
        /* Labels */
        [titleLabel,descriptionLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        
        //pagingImage
        pagingImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(72)
            make.height.equalTo(12)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(pagingImage.snp.left)
            make.top.equalTo(pagingImage.snp.bottom).offset(28)
        }
        
        // descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        // presentCareerButton
        presentCareerButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(162)
            make.right.equalTo(presentEducationButton.snp.left).offset(-14)
        }
        
        // presentEducationButton
        presentEducationButton.snp.makeConstraints { make in
            make.top.equalTo(presentCareerButton.snp.top)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(162)
            make.width.equalTo(presentCareerButton.snp.width)
        }
        
        // nextButton
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
    }
    
    @objc
    private func selectContent(_ sender: UIButton) {
        nextButton.isEnabled = true
        UIView.animate(withDuration: 0.33) {
            self.nextButton.backgroundColor = .mainBlue
        }
        switch sender {
        case presentCareerButton:
            presentCareerButton.backgroundColor = .mainLightBlue
            presentEducationButton.backgroundColor = .systemBackground
            presentCareerButton.layer.borderColor = UIColor.mainBlue.cgColor
            presentEducationButton.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.5).cgColor
            nextButton.tag = 0
        case presentEducationButton:
            presentEducationButton.backgroundColor = .mainLightBlue
            presentCareerButton.backgroundColor = .systemBackground
            presentEducationButton.layer.borderColor = UIColor.mainBlue.cgColor
            presentCareerButton.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.5).cgColor
            nextButton.tag = 1
        default:
            fatalError("Missing TextField...")
        }
    }
    
    @objc
    private func nextButtonTapped(_ sender: UIButton) {
        // 다음 화면전환
        var nextVC = UIViewController()
        if sender.tag == 0 {
            nextVC = InputCareerVC()
        }
        else if sender.tag == 1 {
            nextVC = InputEducationVC()
        }
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
        
    }
    
}
