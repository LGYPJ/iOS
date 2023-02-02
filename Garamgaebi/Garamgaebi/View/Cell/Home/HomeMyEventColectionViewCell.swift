//
//  HomeMyEventColectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//


import UIKit

class HomeMyEventColectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeMyEventColectionViewCell"
    public var programIdx = Int()
    public var payment = String()
    public var type = String()
    public var status = String()
    public var isOpen = String()
    lazy var dateTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xF5F5F5)
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2월 10일"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        return label
    }()
    
    lazy var timeInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "18:00"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        return label
    }()
    
    lazy var titleInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2차 세미나"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        return label
    }()
    
    lazy var locationInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대학교 비전타워 B201"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        return label
    }()
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()        
        configAddSubView()
        configSubViewLayouts()
    }
    
    func configAddSubView(){
        contentView.addSubview(dateTimeView)
        dateTimeView.addSubview(dateInfoLabel)
        dateTimeView.addSubview(timeInfoLabel)
        contentView.addSubview(titleInfoLabel)
        contentView.addSubview(locationInfoLabel)
        
    }
    
    func configSubViewLayouts() {
        dateTimeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(80)
        }
        dateInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        timeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateInfoLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        titleInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13.5)
            make.left.equalTo(dateTimeView.snp.right).offset(14)
            make.right.equalToSuperview().inset(16)
        }
        
        locationInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleInfoLabel.snp.bottom).offset(4)
            make.left.equalTo(titleInfoLabel.snp.left)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    public func configure(_ item: MyEventInfoReady) {
        
        // item.date -> (String -> Date)
        let dateTime = item.date.toDate()
        
        let dateformatter = DateFormatter()
        // (Date -> String)
        dateformatter.dateFormat = "M월 dd일"
        let dateResult = dateformatter.string(from: dateTime ?? Date())
        dateInfoLabel.text = dateResult
        
        dateformatter.dateFormat = "HH:mm"
        let timeResult = dateformatter.string(from: dateTime ?? Date())
        timeInfoLabel.text = timeResult

        titleInfoLabel.text = item.title
        locationInfoLabel.text = item.location
        
        // UI에 안보이지만 일단 저장함
        programIdx = item.programIdx
        payment = item.payment
        type = item.type
        status = item.status
        isOpen = item.isOpen
    }
}
