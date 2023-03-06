//
//  RecommendUsersColectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit
import Kingfisher

class RecommendUsersCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: RecommendUsersCollectionViewCell.self)
    // MARK: - Subviews
    
    lazy var imageInfoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .mainLightGray
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageDefault: UIImageView = {
        let img = UIImageView(image: UIImage(named: "untitle"))
        return img
    }()
    
    lazy var contentInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var nickNameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "nickname dummy"
        label.font = UIFont.NotoSansKR(type: .Medium, size: 14)
        label.textColor = .mainBlack
        label.textAlignment = .center
        return label
    }()
    
    lazy var belongInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "belong dummy"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 10)
        label.textColor = .mainBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.mainGray.cgColor
        contentView.clipsToBounds = true
        configAddSubView()
        configSubViewLayouts()
    }
    
    func configAddSubView(){
        contentView.addSubview(imageInfoView)
        imageInfoView.addSubview(imageDefault)
        contentView.addSubview(contentInfoView)
        contentInfoView.addSubview(nickNameInfoLabel)
        contentInfoView.addSubview(belongInfoLabel)
    }
    
    func configSubViewLayouts() {
        imageInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        imageDefault.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(30)
        }
        contentInfoView.snp.makeConstraints { make in
            make.top.equalTo(imageInfoView.snp.bottom)
            make.left.right.equalToSuperview().inset(6)
            make.bottom.equalToSuperview()
        }
        
        nickNameInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(20)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        belongInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameInfoLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    public func configure(_ item: RecommendUsersInfo) {

        self.imageDefault.isHidden = false
        self.imageInfoView.image = .none
        
        // 프로필 이미지
        if let urlString = item.profileUrl {
            let processor = RoundCornerImageProcessor(cornerRadius: self.imageInfoView.layer.cornerRadius)
            guard let url = URL(string: urlString) else { return }
            
            self.imageInfoView.kf.setImage(with: url, options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(0.5)),
                .forceRefresh
            ])
            self.imageDefault.isHidden = true
            
        } else {
            self.imageDefault.image = UIImage(named: "untitle")
            self.imageDefault.isHidden = false
            self.imageInfoView.image = .none
        }
        
        // 닉네임
        nickNameInfoLabel.text = item.nickName

        switch(item.belong != nil){
        case true:
            belongInfoLabel.isHidden = false
            belongInfoLabel.text = item.belong
        default:
            belongInfoLabel.isHidden = true
        }

    }
}
