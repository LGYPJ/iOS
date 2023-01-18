//
//  SeminarCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

class HomeEventCollectionViewCell: UICollectionViewCell {

    static let identifier = "HomeEventCollectionViewCell"
    
    
    // MARK: - Subviews
    
    lazy var stateInfoLabel: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0.5, left: 6, bottom: 0.5, right: 6)
        button.setTitle("이번 달", for: .normal)
        button.isEnabled = false
        button.layer.cornerRadius = 4
        button.setTitleColor(.mainBlue, for: .normal)
        button.backgroundColor = .mainYellow
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 12)
        return button
    }()
    
    lazy var feeInfoLabel: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0.5, left: 6, bottom: 0.5, right: 6)
        button.setTitle("무료", for: .normal)
        button.isEnabled = false
        button.layer.cornerRadius = 4
        button.setTitleColor(.mainBlue, for: .normal)
        button.backgroundColor = UIColor(hex: 0xF1F1F1, alpha: 1)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Bold, size: 12)
        return button
    }()
    
    lazy var titleInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2차 세미나"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        label.textColor = UIColor(hex: 0xFFFFFF,alpha: 1)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        label.textColor = UIColor(hex: 0xFFFFFF,alpha: 1)
        return label
    }()
    
    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2023-02-10"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = UIColor(hex: 0xFFFFFF,alpha: 1)
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        label.textColor = UIColor(hex: 0xFFFFFF,alpha: 1)
        return label
    }()
    
    lazy var locationInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대학교 비전타워 B201"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = UIColor(hex: 0xFFFFFF,alpha: 1)
        return label
    }()
    
    lazy var dDayInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "D-9"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
        label.textColor = UIColor(hex: 0xFFFFFF,alpha: 1)
        return label
    }()
    
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 12
//        contentView.backgroundColor = UIColor(hex: 0x356EFF, alpha: 0.8)
        
        configAddSubView()
        configSubViewLayouts()
    }
    
    func configAddSubView(){
        contentView.addSubview(stateInfoLabel)
        contentView.addSubview(feeInfoLabel)
        contentView.addSubview(titleInfoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateInfoLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(locationInfoLabel)
        contentView.addSubview(dDayInfoLabel)
    }
    
    func configSubViewLayouts() {
        
        stateInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(18)
            make.left.equalToSuperview().inset(16)
        }
        
        feeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(stateInfoLabel.snp.top)
            make.left.equalTo(stateInfoLabel.snp.right).offset(8)
        }
        
        titleInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(stateInfoLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleInfoLabel.snp.bottom).offset(16)
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
        dDayInfoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dDayInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(locationInfoLabel.snp.right).offset(8)
        }
    }
    
    
    public func configure(_ item: HomeEventDataModel) {
        
        switch item.state {
        case "오픈":
            contentView.backgroundColor = UIColor(hex: 0x356EFF, alpha: 0.8)
            stateInfoLabel.setTitle("이번 달", for: .normal)
            [titleInfoLabel, dateLabel, dateInfoLabel, locationLabel, locationInfoLabel,dDayInfoLabel].map {
                $0.textColor = .white
            }
            
        case "오픈예정":
            contentView.backgroundColor = UIColor(hex: 0x356EFF, alpha: 0.1)
            stateInfoLabel.setTitle("예정된", for: .normal)
            [titleInfoLabel, dateLabel, dateInfoLabel, locationLabel, locationInfoLabel,dDayInfoLabel].map {
                $0.textColor = UIColor(hex: 0x000000, alpha: 0.8)
            }
        default:
            print("fatal error in (item.state) in 'HomeEventCollectionViewCell'"  )
        }
        
        switch item.fee {
        case 0:
            feeInfoLabel.setTitle("무료", for: .normal)
        default:
            feeInfoLabel.setTitle("유료", for: .normal)
        }
        
        titleInfoLabel.text = item.title
        dateInfoLabel.text = item.date
        locationInfoLabel.text = item.location
    }
    
}