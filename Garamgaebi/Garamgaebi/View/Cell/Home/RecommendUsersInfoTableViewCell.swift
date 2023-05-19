//
//  RecommendUsersTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit
import Combine

class RecommendUsersInfoTableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    public var models: [RecommendUsersInfo] = []
    
    private let input = PassthroughSubject<HomeViewModel.Input, Never>()
    private var subscriptions = Set<AnyCancellable>()
    static let identifier = String(describing: RecommendUsersInfoTableViewCell.self)
    static var cellHeight = 254.0
    
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
        layout.minimumInteritemSpacing = 0
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
        view.register(RecommendUsersCollectionViewCell.self, forCellWithReuseIdentifier: RecommendUsersCollectionViewCell.identifier)
        
        return view
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
        img.image = UIImage(named: "warning")?.withTintColor(UIColor.mainGray.withAlphaComponent(0.8))
        return img
    }()
    
    lazy var zeroDataDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "가람개비 유저가 없습니다."
        label.numberOfLines = 1
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = .mainGray.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    lazy var interSpcace: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xEBF0F6)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(collectionView)
        
        self.contentView.addSubview(zeroDataBackgroundView)
        zeroDataBackgroundView.addSubview(zeroDataImage)
        zeroDataBackgroundView.addSubview(zeroDataDescriptionLabel)
        
        self.contentView.addSubview(interSpcace)
        
        configSubViewLayouts()

        bind()
        input.send(.viewDidLoad)
        
        NotificationCenter.default.post(name: NSNotification.Name("ReloadMyEvent"), object: nil)
    }

    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .setRecommendUsersInfo:
                    self?.models = self?.viewModel.recommendUsersData ?? []
                    self?.configureZeroCell()
                    self?.collectionView.reloadData()
                    print(">>> Alert: get recommendUsersInfo (Succuess)")
                    print(self?.models)
                case .failedRecommendUsersInfo:
                    self?.models = self?.viewModel.recommendUsersData ?? []
                    print(">>> Alert: get recommendUsersInfo (Fail)")
                default:
                    print("RecommendUsersInfoTableViewCell bind anything")
                }
            }
            .store(in: &subscriptions)
    }
    
    func configSubViewLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(174)
        }
        
        zeroDataBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        zeroDataImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
        }
        zeroDataDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(zeroDataImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
                
        interSpcace.snp.makeConstraints { make in
            make.top.equalTo(zeroDataBackgroundView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    private func configureZeroCell() {
//        if recommendUsersList.count == 0 {
        if models.count == 0 {
            // 부모 셀 높이 가변설정 (유저가 하나도 없을 때)
            RecommendUsersInfoTableViewCell.cellHeight = 190
            interSpcace.snp.removeConstraints()
            interSpcace.snp.updateConstraints { make in
                make.top.equalTo(zeroDataBackgroundView.snp.bottom).offset(16)
                make.left.right.equalToSuperview()
                make.height.equalTo(8)
            }
            collectionView.isHidden = true
            zeroDataBackgroundView.isHidden = false
        } else {
            // 부모 셀 높이 가변설정 (유저 1명이상 존재할 때)
            RecommendUsersInfoTableViewCell.cellHeight = 254.0
            interSpcace.snp.removeConstraints()
            interSpcace.snp.updateConstraints { make in
                make.top.equalTo(collectionView.snp.bottom).offset(26)
                make.left.right.equalToSuperview()
                make.height.equalTo(8)
            }
            collectionView.isHidden = false
            zeroDataBackgroundView.isHidden = true
        }
    }
    
}

extension RecommendUsersInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 174)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendUsersCollectionViewCell.identifier, for: indexPath) as? RecommendUsersCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        cell.configure(recommendUsersList[indexPath.row])
        cell.configure(models[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        NotificationCenter.default.post(name: Notification.Name("postOtherProfileMemberIdx"), object: recommendUsersList[indexPath.row].memberIdx)
        NotificationCenter.default.post(name: Notification.Name("postOtherProfileMemberIdx"), object: models[indexPath.row].memberIdx)
    }

}
