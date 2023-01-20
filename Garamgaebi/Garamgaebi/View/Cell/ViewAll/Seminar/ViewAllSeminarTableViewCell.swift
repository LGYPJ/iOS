//
//  ViewAllSeminarTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/16.
//

import UIKit

class ViewAllSeminarTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    static let identifier = String(describing: ViewAllSeminarTableViewCell.self)
    static let cellHeight = 428.0
    
    lazy var titleInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2차 세미나"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.5)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.5)
        return label
    }()
    
    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2023-02-10"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.5)
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.5)
        return label
    }()
    
    lazy var locationInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대학교 비전타워 B201"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.5)
        return label
    }()
    
    lazy var stateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.5)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 12
        
        contentView.addSubview(titleInfoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateInfoLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(locationInfoLabel)
        contentView.addSubview(stateInfoLabel)
      
        configSubViewLayouts()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
    }
    
    func configSubViewLayouts() {

        titleInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.right.equalToSuperview().inset(12)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleInfoLabel.snp.bottom).offset(32)
            make.left.equalTo(titleInfoLabel.snp.left)
        }
        dateInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.left.equalTo(dateLabel.snp.right).offset(8)
        }
        locationLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(dateInfoLabel.snp.bottom)
            make.left.equalTo(titleInfoLabel.snp.left)
        }
        locationInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.left.equalTo(locationLabel.snp.right).offset(8)
        }
        stateInfoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stateInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(locationInfoLabel.snp.right).offset(8)
        }
       
    }
    
    public func configure(_ item: ViewAllSeminarDataModel) {
        
        titleInfoLabel.text = item.title
        dateInfoLabel.text = item.date
        locationInfoLabel.text = item.location
        switch item.state {
        case "오픈":
            contentView.backgroundColor = UIColor(hex: 0x356EFF, alpha: 0.8)
            stateInfoLabel.text = item.state
            [titleInfoLabel, dateLabel, dateInfoLabel, locationLabel, locationInfoLabel,stateInfoLabel].forEach {
                $0.textColor = .white
            }
        case "오픈예정":
            contentView.backgroundColor = UIColor(hex: 0x356EFF, alpha: 0.1)
            stateInfoLabel.text = item.state
        case "마감":
            contentView.backgroundColor = UIColor(hex: 0xF5F5F5)
            stateInfoLabel.text = ""
        default:
            print("fatal error in ViewAllSeminarTableViewCell")
        }
        
    }
    

}
