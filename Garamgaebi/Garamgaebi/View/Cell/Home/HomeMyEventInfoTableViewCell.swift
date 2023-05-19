//
//  HomeMyEventInfoTableViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/15.
//

import UIKit
import Combine

class HomeMyEventInfoTableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    var models: [MyEventInfoReady] = []

    private let input = PassthroughSubject<HomeViewModel.Input, Never>()
    private var subscriptions = Set<AnyCancellable>()
    static let identifier = String(describing: HomeMyEventInfoTableViewCell.self)
    static var cellHeight = 190.0
    
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
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.isScrollEnabled = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        view.clipsToBounds = true
        view.register(HomeMyEventCollectionViewCell.self, forCellWithReuseIdentifier: HomeMyEventCollectionViewCell.identifier)
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
        img.image = UIImage(named: "warning")
        img.tintColor = .mainGray.withAlphaComponent(0.8)
        return img
    }()
    
    lazy var zeroDataDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "예정된 내 모임이 없습니다\n모임을 신청해주세요:)"
        label.numberOfLines = 2
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.textColor = .mainGray.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
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
        configSubViewLayouts()
        
        bind()
        input.send(.viewDidLoad)
        
        NotificationCenter.default.post(name: NSNotification.Name("ReloadMyEvent"), object: nil)
    }
    
    func bind(){
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .setHomeMyEventInfo:
                    self?.models = self?.viewModel.homeMyEventData ?? []
                    self?.configureZeroCell()
                    self?.collectionView.reloadData()
                    print(">>> Alert: get homeMyEvent (Succuess)")
                case .failHomeMyEventInfo:
                    self?.models = self?.viewModel.homeMyEventData ?? []
                    print(">>> Alert: get homeMyEvent (Fail)")
                case .setRecommendUsersInfo:
                    print("asd")
                case .failedRecommendUsersInfo:
                    print("asd")
                }
            }
            .store(in: &subscriptions)
    }
    
    override func layoutIfNeeded() {
        configureZeroCell()
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
        
        zeroDataBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        zeroDataImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(14)
        }
        zeroDataDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(zeroDataImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureZeroCell() {
        if models.count == 0 {
            // 부모 셀 높이 가변설정 (모임이 하나도 없을 때)
            HomeMyEventInfoTableViewCell.cellHeight = 190
            collectionView.isHidden = true
            zeroDataBackgroundView.isHidden = false
        } else {
            // 부모 셀 높이 가변설정 (모임이 하나이상 존재할때)
            HomeMyEventInfoTableViewCell.cellHeight = 54.0 + 88.0 * Double(models.count) - 8.0 + 16.0
            collectionView.isHidden = false
            zeroDataBackgroundView.isHidden = true
        }
    }
    
}

extension HomeMyEventInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMyEventCollectionViewCell.identifier, for: indexPath) as? HomeMyEventCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(models[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width-32, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postObject = models[indexPath.row]
        
        switch(postObject.type){
        case "SEMINAR":
            NotificationCenter.default.post(name: Notification.Name("pushSeminarDetailVC"), object: MyEventToDetailInfo(programIdx: postObject.programIdx, type: postObject.type))
        case "NETWORKING":
            NotificationCenter.default.post(name: Notification.Name("pushNetworkingDetailVC"), object: MyEventToDetailInfo(programIdx: postObject.programIdx, type: postObject.type))
        default:
            print(">>>ERROR: HomeMyEventInfoViewCell didSelectItemAt programType")
        }
    }
}
