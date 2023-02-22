//
//  ErrorPageView.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/22.
//

import Foundation

import UIKit

class ErrorPageView: UIViewController {
    
    lazy var imageView: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "networkWarning"), for: .normal)
        view.addTarget(self, action: #selector(retry), for: .touchUpInside)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "페이지를 불러올 수 없습니다"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "다시 시도해주세요"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.backgroundColor = .white
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(23)
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
    
    @objc func retry() {
        self.dismiss(animated: false)
    }
    
}
