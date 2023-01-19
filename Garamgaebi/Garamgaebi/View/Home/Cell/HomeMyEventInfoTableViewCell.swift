//
//  HomeMyEventInfoTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

class HomeMyEventInfoTableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    static let identifier = String(describing: HomeMyEventInfoTableViewCell.self)
    static var cellHeight = 400.0
    
    let dataList = HomeMyEventDataModel.list

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 모임"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.minimumLineSpacing = 18.0
        layout.minimumInteritemSpacing = 0
        //layout.itemSize = .init(width: 300, height: cellHeight)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.isScrollEnabled = false
        
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        view.clipsToBounds = true
        view.register(HomeMyEventColectionViewCell.self, forCellWithReuseIdentifier: HomeMyEventColectionViewCell.identifier)
        
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(collectionView)
        configSubViewLayouts()
 
        // 부모 셀 높이 가변설정 (모임이 하나이상 존재할때)        
        HomeMyEventInfoTableViewCell.cellHeight = 54.0 + 88.0 * Double(dataList.count) - 8.0 + 16.0
    }
    
    func configSubViewLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()//.offset(-16)
        }
    }
}

extension HomeMyEventInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMyEventColectionViewCell.identifier, for: indexPath) as? HomeMyEventColectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(dataList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width-32, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
