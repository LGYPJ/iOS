//
//  HomeNotificationTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

class HomeNotificationTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    static let identifier = String(describing: HomeNotificationTableViewCell.self)
    static let cellHeight = 428.0
    
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "모아보기"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 네트워킹이 오픈되었어요"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x545454)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(contentLabel)
      
        configSubViewLayouts()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configSubViewLayouts() {
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imgView.snp.centerY)
            make.left.equalTo(imgView.snp.right).offset(8)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(8)
            make.left.equalTo(imgView.snp.left)
        }
       
    }
    
    public func configure(_ item: NotificationDetailInfo) {
        switch(item.notificationType){
        case "COLLECTIONS":
            imgView.image = UIImage(named: "supervisorAccountIcon")
            categoryLabel.text = "모아보기"
        case "SOON_CLOSE":
            imgView.image = UIImage(named: "alarmIcon")
            categoryLabel.text = "마감임박"
        case "APPLY_COMPLETE":
            imgView.image = UIImage(named: "checkCircleIcon1")
            categoryLabel.text = "신청완료"
        case "APPLY_CANCEL_COMPLETE":
            imgView.image = UIImage(named: "checkCircleIcon1")
            categoryLabel.text = "신청취소완료"
        case "APPLY_CONFIRM":
            imgView.image = UIImage(named: "checkCircleIcon2")
            categoryLabel.text = "신청확정"
        case "NON_DEPOSIT_CANCEL":
            imgView.image = UIImage(named: "checkCircleIcon2")
            categoryLabel.text = "미입금취소"
        case "REFUND_COMPLETE":
            imgView.image = UIImage(named: "checkCircleIcon3")
            categoryLabel.text = "환불완료"
        default:
            print(">>>ERROR: notificationType config")
        }

        if item.isRead == false {
            contentView.backgroundColor = .white
        } else {
            contentView.backgroundColor = .mainLightGray
        }
        contentLabel.text = item.content
    }
    
}
