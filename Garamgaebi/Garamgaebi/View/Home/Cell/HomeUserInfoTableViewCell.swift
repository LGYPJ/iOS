//
//  HomeUserInfoTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit

class HomeUserInfoTableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    static let identifier = String(describing: HomeUserInfoTableViewCell.self)
    static let cellHeight = 254.0
    
    let dataList = HomeUserDataModel.list
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비 유저"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 18.0
        layout.minimumInteritemSpacing = 0
        //layout.itemSize = .init(width: 300, height: cellHeight)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.isScrollEnabled = true
        
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(HomeUserColectionViewCell.self, forCellWithReuseIdentifier: HomeUserColectionViewCell.identifier)
        
        return view
    }()
    
    lazy var interSpcace: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.contentView.addSubview(titleLabel)
        
        self.contentView.addSubview(collectionView)
        
        self.contentView.addSubview(interSpcace)
        configSubViewLayouts()
        
    }
    
    func configSubViewLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(184)
        }
                
        interSpcace.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    
}

extension HomeUserInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width/390*120
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem/120*184
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeUserColectionViewCell.identifier, for: indexPath) as? HomeUserColectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(dataList[indexPath.row])
        
        return cell
    }

}
