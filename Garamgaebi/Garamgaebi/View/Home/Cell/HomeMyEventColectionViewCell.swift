//
//  HomeMyEventColectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//


import UIKit

class HomeMyEventColectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeMyEventColectionViewCell"
    
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
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
