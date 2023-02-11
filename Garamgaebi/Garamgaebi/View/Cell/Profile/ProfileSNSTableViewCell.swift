//
//  ProfileSNSTableViewCell.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/28.
//

import UIKit

import SnapKit
import Then

protocol ButtonTappedDelegate: class {
    func copyButtonDidTap()
}

class ProfileSNSTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Properties
    static let identifier = String(describing: ProfileSNSTableViewCell.self)
    weak var delegate: ButtonTappedDelegate?
    
    
    // MARK: - Subviews
    lazy var snsLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textColor = .mainBlack
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage(named: "ProfileEdit"), for: .normal)
        
        $0.addTarget(self, action: #selector(copyButtonDidTap), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        contentView
        self.contentView.addSubview(snsLabel)
        self.contentView.addSubview(editButton)
      
        configureSubViewLayouts()
        
    }
    
    func configureSubViewLayouts() {
        
        snsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(editButton.snp.leading).offset(-12)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(snsLabel)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(16)
        }
       
    }
    
    @objc private func copyButtonDidTap() {
        delegate?.copyButtonDidTap()
        
        guard let copyString = snsLabel.text else { return }
        UIPasteboard.general.string = copyString
        
        print("클립보드 복사: \(copyString)")
    }
    
//    public func snsConfigure(_ item: SnsResult) {
//        snsLabel.text = item.address
//    }

}
