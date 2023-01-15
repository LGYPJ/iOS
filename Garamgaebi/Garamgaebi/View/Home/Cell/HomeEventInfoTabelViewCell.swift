//
//  HomeEventInfoTabelViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

class HomeEventInfoTableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    static let identifier = String(describing: HomeEventInfoTableViewCell.self)
    static let cellHeight = 428.0
    let dataList = EventDataModel.list
    
    
    lazy var seminarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "세미나"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    lazy var seminarPopUpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PopUpIcon"), for: .normal)
        return button
    }()
    
    lazy var seminarViewAllLabel: UIButton = {
        let button = UIButton()
        button.setTitle("세미나 모아보기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        return button
    }()
    lazy var seminarViewAllButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: "arrowForward"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    lazy var seminarViewAllStack: UIStackView = {
        let stackView = UIStackView()
        [seminarViewAllLabel,seminarViewAllButton]
            .forEach {stackView.addArrangedSubview($0)}
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var networkingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워킹"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    lazy var networkingPopUpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PopUpIcon"), for: .normal)
        return button
    }()
    
    lazy var networkingViewAllLabel: UIButton = {
        let button = UIButton()
        button.setTitle("네트워킹 모아보기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        return button
    }()
    lazy var networkingViewAllButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: "arrowForward"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    lazy var networkingViewAllStack: UIStackView = {
        let stackView = UIStackView()
        [networkingViewAllLabel,networkingViewAllButton]
            .forEach {stackView.addArrangedSubview($0)}
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 18.0
        layout.minimumInteritemSpacing = 0
        //layout.itemSize = .init(width: 300, height: cellHeight)
        return layout
    }()
    
    lazy var seminarCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.isScrollEnabled = true
        
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(HomeEventCollectionViewCell.self, forCellWithReuseIdentifier: HomeEventCollectionViewCell.identifier)
        
        return view
    }()
    
    lazy var networkingCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.isScrollEnabled = true
        
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(HomeEventCollectionViewCell.self, forCellWithReuseIdentifier: HomeEventCollectionViewCell.identifier)

        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.seminarCollectionView.dataSource = self
        self.seminarCollectionView.delegate = self
        self.seminarCollectionView.tag = 1
        
        self.networkingCollectionView.dataSource = self
        self.networkingCollectionView.delegate = self
        self.networkingCollectionView.tag = 2
        
        self.contentView.addSubview(seminarTitleLabel)
        self.contentView.addSubview(seminarPopUpButton)
        self.contentView.addSubview(seminarViewAllButton)
        self.contentView.addSubview(seminarViewAllStack)
        self.contentView.addSubview(seminarCollectionView)
        
        self.contentView.addSubview(networkingTitleLabel)
        self.contentView.addSubview(networkingPopUpButton)
        self.contentView.addSubview(networkingViewAllButton)
        self.contentView.addSubview(networkingViewAllStack)
        self.contentView.addSubview(networkingCollectionView)
        configSubViewLayouts()
        
    }
    
    func configSubViewLayouts() {
        seminarTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        seminarPopUpButton.snp.makeConstraints { make in
            make.centerY.equalTo(seminarTitleLabel.snp.centerY)
            make.left.equalTo(seminarTitleLabel.snp.right).offset(4)
            make.width.height.equalTo(16)
        }
        seminarViewAllStack.snp.makeConstraints { make in
            make.top.equalTo(seminarTitleLabel.snp.top)
            make.right.equalToSuperview().inset(16)
        }
        seminarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(seminarTitleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(140)
        }
        
        networkingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(seminarCollectionView.snp.bottom).offset(40)
            make.left.equalToSuperview().inset(16)
        }
        networkingPopUpButton.snp.makeConstraints { make in
            make.centerY.equalTo(networkingTitleLabel.snp.centerY)
            make.left.equalTo(networkingTitleLabel.snp.right).offset(4)
            make.width.height.equalTo(16)
        }
        networkingViewAllStack.snp.makeConstraints { make in
            make.top.equalTo(networkingTitleLabel.snp.top)
            make.right.equalToSuperview().inset(16)
        }

        networkingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(networkingViewAllStack.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(140)
        }
    }
    
    
}

extension HomeEventInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return dataList.count
        }
        else {
            return dataList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeEventCollectionViewCell.identifier, for: indexPath) as? HomeEventCollectionViewCell else {
            return UICollectionViewCell()
        }
        if collectionView.tag == 1{
            print("asdasd")
            cell.backgroundColor = .mainGray
            //cell.imageView = UIImageView(image: dataList[indexPath.row].image)
            cell.imageView.sizeToFit()
        }
        else if collectionView.tag == 2{
            cell.backgroundColor = .mainGray
            //cell.imageView = UIImageView(image: dataList[indexPath.row].image)
            cell.imageView.sizeToFit()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return CGSize(width: 334, height: 140)
        
        //셀사이즈
        //        return CGSize(width: 334, height: 140)
    }
}
