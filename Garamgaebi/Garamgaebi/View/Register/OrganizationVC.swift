//
//  OrganizationVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/12.
//

import UIKit
import SnapKit

class OrganizationVC: UIViewController {
    

    // MARK: - Subviews
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage4"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "소속"
        label.textColor = .black
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자신을 표현해봐요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var presentEducationButton: UIButton = {
        let button = UIButton()
        button.setTitle("아직 경력이 없어요", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainLightBlue
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var presentCareerButton: UIButton = {
        let button = UIButton()
        button.setTitle("네, 재직 중이에요", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .mainBlue
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
        
        /* Labels */
        [titleLabel,descriptionLabel].map {
            view.addSubview($0)
        }
    }
    
    func configLayouts() {
        
        //pagingImage
        pagingImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(96)
            make.height.equalTo(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(pagingImage.snp.bottom).offset(16)
        }
        
        // descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        
        // presentEducationButton
        presentEducationButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
        
        // presentCareerButton
        presentCareerButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(14)
            make.bottom.equalTo(presentEducationButton.snp.top).inset(-14)
            make.height.equalTo(48)
        }
    }
    
    @objc
    private func nextButtonTapped(_ sender: UIButton) {
        
        var nextVC = UIViewController()
        switch sender {
        case presentCareerButton:
            nextVC = OrganizationVC()
        case presentEducationButton:
            nextVC = OrganizationVC()
        default:
            fatalError("Missing TextField...")
        }
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)

        
    }
    
}
