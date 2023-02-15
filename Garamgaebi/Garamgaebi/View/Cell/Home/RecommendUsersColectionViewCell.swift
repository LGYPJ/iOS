//
//  RecommendUsersColectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit
import Kingfisher

class RecommendUsersColectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: RecommendUsersColectionViewCell.self)
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
    
    lazy var groupInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "group dummy"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 10)
        label.textColor = .mainBlack
        label.textAlignment = .center
        return label
    }()
    
    lazy var detailInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "detail dummy"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 10)
        label.textColor = .mainBlack
        label.textAlignment = .center
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
        contentInfoView.addSubview(groupInfoLabel)
        contentInfoView.addSubview(detailInfoLabel)
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
        
        groupInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(detailInfoLabel.snp.top)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        detailInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(groupInfoLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    public func configure(_ item: RecommendUsersInfo) {

        self.imageDefault.isHidden = false
        self.imageInfoView.image = .none
        if let urlString = item.profileUrl {
            let url = URL(string: urlString)
            self.imageInfoView.kf.indicatorType = .activity
            self.imageInfoView.kf.setImage(with: url)
            self.imageDefault.isHidden = true
        }
        
        //imageInfoView.image = UIImage(named: "untitle")?.withTintColor(.mainGray)
        // 닉네임
        nickNameInfoLabel.text = item.nickName
        
        // belong이 있으면 belong만 보여주고 아니면 group,detail
        switch(item.belong != nil){
        case true:
            belongInfoLabel.isHidden = false
            groupInfoLabel.isHidden = true
            detailInfoLabel.isHidden = true
            
            belongInfoLabel.text = item.belong
        default:
            belongInfoLabel.isHidden = true
            groupInfoLabel.isHidden = false
            detailInfoLabel.isHidden = false
            
            groupInfoLabel.text = item.group
            detailInfoLabel.text = item.detail
        }

    }
}
