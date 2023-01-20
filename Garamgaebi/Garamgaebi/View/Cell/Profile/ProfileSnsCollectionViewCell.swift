//
//  ProfileSnsCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/18.
//

import UIKit

class ProfileSnsCollectionViewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Properties
    static let identifier = String(describing: ProfileSnsCollectionViewCell.self)
    // static var id: String { return NSStringFromClass(Self.self).components(separatedBy: ".").last! }
    //static let cellHeight = 428.0
    let dataList = ProfileSnsDataModel.data
    
    var snsLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textColor = .black
    }
    
    var editButton = UIButton().then {
        $0.setImage(UIImage(named: "ProfileEdit"), for: .normal)
    }
    
    var underLine = UIView().then {
        $0.backgroundColor = .mainGray
    }
    
    // MARK: - LifeCycles
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureLayouts()
    }
    
    // MARK: - Functions
    func configureLayouts() {
        contentView.addSubview(snsLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(underLine)
        
        snsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(editButton.snp.leading).offset(-12)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(snsLabel)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.width.equalTo(16)
        }
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
