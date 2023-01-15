//
//  SeminarCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

class HomeEventCollectionViewCell: UICollectionViewCell {

    static let identifier = "HomeEventCollectionViewCell"
    
    lazy var imageView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainGray
        return view
    }()
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(imageView)
        configSubViewLayouts()
    }
    
    func configSubViewLayouts() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(40)
        }
    }
}
