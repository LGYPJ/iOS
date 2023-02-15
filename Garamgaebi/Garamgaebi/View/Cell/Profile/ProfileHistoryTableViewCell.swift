//
//  ProfileCareerTableViewCell.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/24.
//

import UIKit

import SnapKit
import Then

protocol HistoryButtonTappedDelegate: AnyObject {
    func careerButtonDidTap(careerIdx: Int, company: String, position: String, startDate: String, endDate: String, isWorking: String)
    func educationButtonDidTap(educationIdx: Int, institution: String, major: String, startDate: String, endDate: String, isLearning: String)
}

class ProfileHistoryTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    static let identifier = String(describing: ProfileHistoryTableViewCell.self)
    
    weak var delegate: HistoryButtonTappedDelegate?
    
    var id: Int = 0 // career -> 1, education -> 2
    
    var careerIdx: Int?
    var company: String?
    var position: String?
    var startDate: String?
    var endDate: String?
    var isWorking: String?
    
    lazy var companyLabel = UILabel().then {
        $0.text = "우아한 형제들"
        $0.textColor = .mainBlack
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 14)
    }
    
    lazy var positionLabel = UILabel().then {
        $0.text = "iOS 프로그래머"
        $0.textColor = .mainBlack
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
    }
    
    lazy var periodLabel = UILabel().then {
        $0.text = "2020.04 ~ 현재"
        $0.textColor = UIColor(hex: 0xB8B8B8)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage(named: "ProfileEdit"), for: .normal)
        
        $0.addTarget(self, action: #selector(historyEditButtonDidTap), for: .touchUpInside)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .red
        self.contentView.addSubview(companyLabel)
        self.contentView.addSubview(positionLabel)
        self.contentView.addSubview(periodLabel)
        self.contentView.addSubview(editButton)
      
        configureSubViewLayouts()
        
    }
    
    func configureSubViewLayouts() {
        
        companyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        positionLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(companyLabel)
            $0.top.equalTo(companyLabel.snp.bottom).offset(4)
        }
        
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(positionLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(companyLabel)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
            $0.width.height.equalTo(16)
        }
       
    }
    
    @objc private func historyEditButtonDidTap() {
        print("id: \(id)")
        if (id == 1) { // 경력
            delegate?.careerButtonDidTap(careerIdx: careerIdx ?? 0, company: company ?? "", position: position ?? "", startDate: startDate ?? "", endDate: endDate ?? "", isWorking: isWorking ?? "")
        } else if (id == 2) { // 교육
            delegate?.educationButtonDidTap(educationIdx: careerIdx ?? 0, institution: company ?? "", major: position ?? "", startDate: startDate ?? "", endDate: endDate ?? "", isLearning: isWorking ?? "")
        }
    }
    
    
//    public func careerConfigure(_ item: ProfileCareerDataModel) {
//        companyLabel.text = item.company
//        positionLabel.text = item.position
//        periodLabel.text = "\(item.startDate) ~ \(item.endDate)"
//    }
    
//    public func educationConfigure(_ item: ProfileEducationDataModel) {
//        companyLabel.text = item.organization
//        positionLabel.text = item.position
//        periodLabel.text = "\(item.startDate) ~ \(item.endDate)"
//    }
}
