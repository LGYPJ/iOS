//
//  HomeUserCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

class HomeUserColectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeUserColectionViewCell"
    
    // MARK: - Subviews
    
    lazy var imageInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainGray
        return view
    }()
    
    lazy var nickNameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "네온"
        label.font = UIFont.NotoSansKR(type: .Medium, size: 16)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        return label
    }()
    
    lazy var companyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대학교"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        return label
    }()
    
    lazy var positionInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "산업디자인학과"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 12)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        return label
    }()
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.mainGray.cgColor
        contentView.clipsToBounds = true
        configAddSubView()
        configSubViewLayouts()
    }
    
    func configAddSubView(){
        contentView.addSubview(imageInfoView)
        contentView.addSubview(nickNameInfoLabel)
        contentView.addSubview(companyInfoLabel)
        contentView.addSubview(positionInfoLabel)
    }
    
    func configSubViewLayouts() {
        imageInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(100)
        }
        
        nickNameInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageInfoView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        companyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameInfoLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        positionInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(companyInfoLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    public func configure(_ item: HomeUserDataModel) {
        
        //이미지 받아야함 (이미지) = item.profileImage
        
        nickNameInfoLabel.text = item.nickName
        companyInfoLabel.text = item.company
        positionInfoLabel.text = item.postion
    }
}
