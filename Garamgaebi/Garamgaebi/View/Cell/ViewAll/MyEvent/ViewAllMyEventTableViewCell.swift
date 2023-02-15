//
//  ViewAllMyEventTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/17.
//

import UIKit

class ViewAllMyEventTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum SettingButtonStatus{
        case READY
        case CLOSED
    }
    
    // MARK: - Properties
    static let identifier = String(describing: ViewAllMyEventTableViewCell.self)
    static let cellHeight = 428.0 // 지워야함
    
    // cell에 저장될 EventInfo
    public var cellEventInfo = MyEventToDetailInfo(programIdx: 0, type: "")
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
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
        button.setImage(UIImage(named: "moreHorizon")?.withTintColor(.mainBlue), for: .highlighted)
        button.setImage(UIImage(named: "moreHorizon")?.withTintColor(UIColor(hex: 0x1C1B1F)), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        
        let detail = UIAction(
            title: "상세보기",
            image: UIImage(named: "searchIcon")?.withTintColor(UIColor(hex: 0x1C1B1F)),
            handler: { _ in
                // 선택한 cell의 정보를 detailView에 전달
                NotificationCenter.default.post(name: Notification.Name("pushEventDetailVC"), object: self.cellEventInfo)
            }
        )
        
        let cancel = UIAction(
            title: "신청취소",
            image: UIImage(named: "deleteIcon")?.withTintColor(UIColor(hex: 0x1C1B1F)),
            handler: { _ in
                // 선택한 cell의 정보를 detailView에 전달
                NotificationCenter.default.post(name: Notification.Name("pushEventApplyCancelVC"), object: self.cellEventInfo)
            }
        )
        
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(
                             identifier: nil,
                             options: .displayInline, // .destructive
                             children: [detail, cancel])
        return button
    }()
    
    lazy var zeroDataBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.mainGray.withAlphaComponent(0.8).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var zeroDataImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "today")
        img.tintColor = .mainGray.withAlphaComponent(0.8)
        return img
    }()
    
    lazy var zeroDataDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "이번달은 네트워킹이 없습니다"
        label.numberOfLines = 1
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = .mainGray.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // cell에 데이터 있을 때
        contentView.addSubview(baseView)
        baseView.addSubview(dateTimeView)
        dateTimeView.addSubview(dateInfoLabel)
        dateTimeView.addSubview(timeInfoLabel)
        baseView.addSubview(titleInfoLabel)
        baseView.addSubview(locationInfoLabel)
        baseView.addSubview(settingButton)
        
        // cell에 데이터 없을 때
        contentView.addSubview(zeroDataBackgroundView)
        zeroDataBackgroundView.addSubview(zeroDataImage)
        zeroDataBackgroundView.addSubview(zeroDataDescriptionLabel)
        
        // default
        configSubViewLayouts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
    }
    
    func configSubViewLayouts() {
        baseView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
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
    
    private func settingButtonConfig(_ status: SettingButtonStatus) {
        let detail = UIAction(
            title: "상세보기",
            image: UIImage(named: "searchIcon")?.withTintColor(UIColor(hex: 0x1C1B1F)),
            handler: { _ in
                // 선택한 cell의 정보를 detailView에 전달
                NotificationCenter.default.post(name: Notification.Name("pushEventDetailVC"), object: self.cellEventInfo)
            }
        )
        
        let cancel = UIAction(
            title: "신청취소",
            image: UIImage(named: "deleteIcon")?.withTintColor(UIColor(hex: 0x1C1B1F)),
            handler: { _ in
                // 선택한 cell의 정보를 detailView에 전달
                NotificationCenter.default.post(name: Notification.Name("pushEventApplyCancelVC"), object: self.cellEventInfo)
            }
        )
        
        settingButton.showsMenuAsPrimaryAction = true
        
        switch status {
        case .READY:
            settingButton.menu = UIMenu(
                                 identifier: nil,
                                 options: .displayInline, // .destructive
                                 children: [detail, cancel])
        case .CLOSED:
            settingButton.menu = UIMenu(
                                 identifier: nil,
                                 options: .displayInline, // .destructive
                                 children: [detail])
        }
    }
    
    public func configureReady(_ item: MyEventInfoReady) {
        settingButtonConfig(SettingButtonStatus.READY)
        baseView.isHidden = false
        zeroDataBackgroundView.isHidden = true
        settingButton.isHidden = false
        dateTimeView.backgroundColor = .mainLightBlue
        
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
        
        cellEventInfo = MyEventToDetailInfo(programIdx: item.programIdx, type: item.type)
        
    }
    
    public func configureClose(_ item: MyEventInfoClose) {
        settingButtonConfig(SettingButtonStatus.CLOSED)
        baseView.isHidden = false
        zeroDataBackgroundView.isHidden = true
        settingButton.isHidden = true
        dateTimeView.backgroundColor = UIColor(hex: 0xF5F5F5)
        
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
        
        cellEventInfo = MyEventToDetailInfo(programIdx: item.programIdx, type: item.type)
 
    }
    
    // TODO: API 통신 후 수정
    public func configureZeroCell(caseString: String) {

        zeroDataBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        zeroDataImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(44)
            make.top.equalToSuperview().inset(14)
        }
        zeroDataDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(zeroDataImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        zeroDataDescriptionLabel.text = "\(caseString) 모임이 없습니다"
        ViewAllSeminarTableViewCell.cellHeight = 100
        baseView.isHidden = true
        zeroDataBackgroundView.isHidden = false

    }

}
