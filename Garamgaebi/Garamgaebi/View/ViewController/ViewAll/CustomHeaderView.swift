//
//  CustomHeaderView.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/16.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let identifier = String(describing: UITableViewHeaderFooterView.self)
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "headerTitle"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        configSubViewLayouts()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configSubViewLayouts() {
        title.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(16)
            make.top.equalTo(contentView.snp.top).inset(16)
        }
    }
}
