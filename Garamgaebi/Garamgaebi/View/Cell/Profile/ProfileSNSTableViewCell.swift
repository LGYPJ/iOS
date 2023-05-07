//
//  ProfileSNSTableViewCell.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/28.
//

import UIKit

import SnapKit
import Then

protocol SnsButtonTappedDelegate: AnyObject {
    func snsEditButtonDidTap(snsIdx: Int, type: String, address: String)
    func copyButtonDidTap()
}

class ProfileSNSTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Properties
    static let identifier = String(describing: ProfileSNSTableViewCell.self)
    
    weak var delegate: SnsButtonTappedDelegate?
    
    var snsIdx: Int?
    var type: String?
    var address: String?
    
    // MARK: - Subviews
    lazy var snsTypeLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        $0.textColor = .mainBlack
    }
    lazy var snsLinkLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.textColor = .mainBlue
        $0.textAlignment = .left
		$0.isUserInteractionEnabled = true
    }
    
    lazy var snsStackView = UIStackView().then {
        [snsTypeLabel, snsLinkLabel].forEach($0.addArrangedSubview(_:))
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    lazy var editButton = UIButton().then { // ProfileVC용
        $0.setImage(UIImage(named: "ProfileEdit"), for: .normal)
        
        $0.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
    lazy var copyButton = UIButton().then { // OhterProfileVC용
        $0.setImage(UIImage(named: "ProfileCopy"), for: .normal)
        
        $0.addTarget(self, action: #selector(copyButtonDidTap), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // contentView
        self.contentView.addSubview(snsStackView)
        self.contentView.addSubview(editButton)
        self.contentView.addSubview(copyButton)
      
        configureSubViewLayouts()
        
    }
    
    func configureSubViewLayouts() {
        
        snsStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(copyButton.snp.leading)
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
    
    @objc private func editButtonDidTap() { // ProfileVC용
        delegate?.snsEditButtonDidTap(snsIdx: snsIdx ?? 0, type: type ?? "", address: address ?? "")
    }
    
    @objc private func copyButtonDidTap() { // OtherProfileVC용
        delegate?.copyButtonDidTap()
        
        guard let copyString = snsLinkLabel.text else { return }
        UIPasteboard.general.string = copyString
        
        print("클립보드 복사: \(copyString)")
    }
}
