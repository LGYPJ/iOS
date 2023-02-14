//
//  ProfileSNSTableViewCell.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/28.
//

import UIKit

import SnapKit
import Then

protocol ButtonTappedDelegate: AnyObject {
    func editButtonDidTap(snsIdx: Int, type: String, address: String)
    func copyButtonDidTap()
}

class ProfileSNSTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Properties
    static let identifier = String(describing: ProfileSNSTableViewCell.self)
    
    weak var delegate: ButtonTappedDelegate?
    
    var snsIdx: Int?
    var type: String?
    var address: String?
    
    // MARK: - Subviews
    lazy var snsTypeLable = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        $0.textColor = .mainBlack
    }
    lazy var snsLinkLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textColor = .mainBlue
        $0.textAlignment = .left
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage(named: "ProfileEdit"), for: .normal)
        
        $0.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
    lazy var copyButton = UIButton().then {
        $0.setImage(UIImage(named: "ProfileCopy"), for: .normal)
        
        $0.addTarget(self, action: #selector(copyButtonDidTap), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        contentView
        self.contentView.addSubview(snsTypeLable)
        self.contentView.addSubview(snsLinkLabel)
        self.contentView.addSubview(editButton)
        self.contentView.addSubview(copyButton)
      
        configureSubViewLayouts()
        
    }
    
    func configureSubViewLayouts() {
        
        snsTypeLable.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        snsLinkLabel.snp.makeConstraints {
            $0.top.equalTo(snsTypeLable.snp.bottom).offset(4)
            $0.leading.equalTo(snsTypeLable)
            $0.bottom.equalToSuperview().inset(12)
        }
        copyButton.snp.makeConstraints {
            $0.centerY.equalTo(editButton)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(16)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(16)
        }
       
    }
    
    @objc private func editButtonDidTap() {
        delegate?.editButtonDidTap(snsIdx: snsIdx ?? 0, type: type ?? "", address: address ?? "")
        
//        print("편집 버튼 클릭")
    }
    
    @objc private func copyButtonDidTap() {
        delegate?.copyButtonDidTap()
        
        guard let copyString = snsLinkLabel.text else { return }
        UIPasteboard.general.string = copyString
        
        print("클립보드 복사: \(copyString)")
    }
    
//    public func snsConfigure(_ item: SnsResult) {
//        snsLabel.text = item.address
//    }

}
