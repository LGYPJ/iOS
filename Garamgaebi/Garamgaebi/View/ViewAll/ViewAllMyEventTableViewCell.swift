//
//  ViewAllMyEventTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/17.
//

import UIKit

protocol ViewAllMyEventTableViewCellProtocol {
    func pushNextView(_ target : UIViewController)
}

class ViewAllMyEventTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: ViewAllMyEventTableViewCellProtocol?
    
    // MARK: - Properties
    static let identifier = String(describing: ViewAllMyEventTableViewCell.self)
    static let cellHeight = 428.0 // 지워야함
    
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
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "moreHorizon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor(hex: 0x1C1B1F)
        //button.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        
        let detail = UIAction(
            title: "상세보기",
            image: UIImage(named: "searchIcon")?.withTintColor(UIColor(hex: 0x1C1B1F)),
            handler: { _ in
                self.delegate?.pushNextView(SeminarDetailVC()) // 임시 VC
                print("상세보기 클릭됨")
            }
        )
        
        let cancel = UIAction(
            title: "신청취소",
            image: UIImage(named: "deleteIcon")?.withTintColor(UIColor(hex: 0x1C1B1F)),
            handler: { _ in
                self.delegate?.pushNextView(ViewAllMyEventVC()) // 임시 VC
                print("신청취소 클릭됨")
            }
        )

        
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(
                             identifier: nil,
                             options: .displayInline, // .destructive
                             children: [detail, cancel])
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dateTimeView)
        dateTimeView.addSubview(dateInfoLabel)
        dateTimeView.addSubview(timeInfoLabel)
        contentView.addSubview(titleInfoLabel)
        contentView.addSubview(locationInfoLabel)
        contentView.addSubview(settingButton)
        
        configSubViewLayouts()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
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
        
        titleInfoLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13.5)
            make.left.equalTo(dateTimeView.snp.right).offset(14)
            make.right.equalTo(settingButton.snp.left).offset(-14)
        }
        
        locationInfoLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        locationInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleInfoLabel.snp.bottom).offset(4)
            make.left.equalTo(titleInfoLabel.snp.left)
            make.right.equalTo(settingButton.snp.left).offset(-14)
        }
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    public func configure(_ item: ViewAllMyEventDataModel) {
        
        // item.date -> dateString
        let date = item.date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "M월 dd일"
        let dateResult = dateformatter.string(from: date)
        
        // item.date -> timeString
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let timeResult = timeformatter.string(from: date)
        
        dateInfoLabel.text = dateResult
        timeInfoLabel.text = timeResult
        titleInfoLabel.text = item.title
        locationInfoLabel.text = item.location
        
        if item.state != "마감" {
            settingButton.isHidden = false
            dateTimeView.backgroundColor = .mainLightBlue
        } else {
            settingButton.isHidden = true
        }
    }
    
    // setting button did tap
    @objc private func didTapSettingButton() {
        print("setting button did tap")
    }

}
