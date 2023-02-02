//
//  HomeEventInfoTabelViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/14.
//

import UIKit

class HomeEventInfoTableViewCell: UITableViewCell {
    public static var viewAllpageIndex = 0
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    static let identifier = String(describing: HomeEventInfoTableViewCell.self)
    static let cellHeight = 428.0
    
    var seminarList: [HomeSeminarInfo] = []
    var networkingList: [HomeNetworkingInfo] = []
    
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
        button.addTarget(self, action: #selector(presentPopUpView), for: .touchUpInside)
        return button
    }()
    
    lazy var seminarViewAllLabel: UIButton = {
        let button = UIButton()
        button.setTitle("세미나 모아보기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        button.addTarget(self, action: #selector(presentViewAll), for: .touchUpInside)
        return button
    }()
    
    lazy var seminarViewAllButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: "arrowForward"), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(presentViewAll), for: .touchUpInside)
        return button
    }()
    
    lazy var seminarViewAllStack: UIStackView = {
        let stackView = UIStackView()
        [seminarViewAllLabel,seminarViewAllButton]
            .forEach {stackView.addArrangedSubview($0)}
        stackView.spacing = 15
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
        button.addTarget(self, action: #selector(presentPopUpView), for: .touchUpInside)
        return button
    }()
    
    lazy var networkingViewAllLabel: UIButton = {
        let button = UIButton()
        button.setTitle("네트워킹 모아보기", for: .normal)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        button.addTarget(self, action: #selector(presentViewAll), for: .touchUpInside)
        return button
    }()
    
    lazy var networkingViewAllButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: "arrowForward"), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(presentViewAll), for: .touchUpInside)
        return button
    }()
    
    lazy var networkingViewAllStack: UIStackView = {
        let stackView = UIStackView()
        [networkingViewAllLabel,networkingViewAllButton]
            .forEach {stackView.addArrangedSubview($0)}
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var seminarCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            return layout
        }()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            return layout
        }()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(HomeEventCollectionViewCell.self, forCellWithReuseIdentifier: HomeEventCollectionViewCell.identifier)

        return view
    }()
    
    lazy var interSpcace: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.seminarCollectionView.dataSource = self
        self.seminarCollectionView.delegate = self
        self.seminarCollectionView.tag = 0
        
        self.networkingCollectionView.dataSource = self
        self.networkingCollectionView.delegate = self
        self.networkingCollectionView.tag = 1
        
        self.contentView.addSubview(seminarTitleLabel)
        self.contentView.addSubview(seminarPopUpButton)
//        self.contentView.addSubview(seminarViewAllButton)
        self.contentView.addSubview(seminarViewAllStack)
        self.contentView.addSubview(seminarCollectionView)
        
        self.contentView.addSubview(networkingTitleLabel)
        self.contentView.addSubview(networkingPopUpButton)
//        self.contentView.addSubview(networkingViewAllButton)
        self.contentView.addSubview(networkingViewAllStack)
        self.contentView.addSubview(networkingCollectionView)
        
        self.contentView.addSubview(interSpcace)
        configSubViewLayouts()
        configNotificationCenter()
        
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
            make.centerY.equalTo(seminarTitleLabel.snp.centerY)
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
            make.height.equalTo(140)
        }
        
        interSpcace.snp.makeConstraints { make in
            make.top.equalTo(networkingCollectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    
    func configNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentHomeSeminarInfo(_:)), name: Notification.Name("presentHomeSeminarInfo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentHomeNetworkingInfo(_:)), name: Notification.Name("presentHomeNetworkingInfo"), object: nil)
        
    }
    
    @objc func presentPopUpView(_ sender: UIButton) {
        switch sender {
        case seminarPopUpButton:
            let vc = HomeSeminarPopUpVC()
            vc.modalPresentationStyle = .overFullScreen
            self.window?.rootViewController?.present(vc, animated: false)
        case networkingPopUpButton:
            let vc = HomeNetworkingPopUpVC()
            vc.modalPresentationStyle = .overFullScreen
            self.window?.rootViewController?.present(vc, animated: false)
        default:
            fatalError("HomeInfoTableViewCell presentPopUpView error")
        }
    }
    
    @objc func presentViewAll(_ sender: UIButton) {
        switch sender {
        case seminarViewAllButton, seminarViewAllLabel:
            HomeEventInfoTableViewCell.viewAllpageIndex = 0
            NotificationCenter.default.post(name: Notification.Name("pushViewAllSeminar"), object: nil)
        case networkingViewAllButton, networkingViewAllLabel:
            HomeEventInfoTableViewCell.viewAllpageIndex = 1
            NotificationCenter.default.post(name: Notification.Name("pushViewAllNetworking"), object: nil)
        default:
            fatalError("HomeInfoTableViewCell presentViewAll error")
        }
    }
    
    @objc func presentHomeSeminarInfo(_ notification: NSNotification) {
    
        guard let seminarListBase = notification.object as? [HomeSeminarInfo] else { return }
        
        // 초기화
        seminarList.removeAll()
        
        // TODO: - 서버 정상화 이후 수정
        
        // 홈 화면 세미나 리스트 필터링 - 수정 후
        if let value = seminarListBase.filter({$0.status == "THIS_MONTH"}).compactMap({$0}).first {
            seminarList.append(value)
        }
        if let value = seminarListBase.filter({$0.status == "READY"}).compactMap({$0}).first {
            seminarList.append(value)
        }
        seminarListBase.filter{$0.status == "CLOSED"}.compactMap{$0}.forEach{seminarList.append($0)}
        
        // 컬렉션뷰 reload
        seminarCollectionView.reloadData()
        
        NotificationCenter.default.post(name: Notification.Name("HomeTableViewReload"), object: nil)
        
    }
    
    @objc func presentHomeNetworkingInfo(_ notification: NSNotification) {
        
        guard let networkingListBase = notification.object as? [HomeNetworkingInfo] else { return }
       
        // 초기화
        networkingList.removeAll()
        
        // 홈 화면 네트워킹 리스트 필터링
        if let value = networkingListBase.filter({$0.status == "THIS_MONTH"}).compactMap({$0}).first {
            networkingList.append(value)
        }
        
        if let value = networkingListBase.filter({$0.status == "READY"}).compactMap({$0}).first {
            networkingList.append(value)
        }
        
        networkingListBase.filter{$0.status == "CLOSED"}.compactMap{$0}.forEach{networkingList.append($0)}
 
        // 컬렉션뷰 reload
        networkingCollectionView.reloadData()
        
        NotificationCenter.default.post(name: Notification.Name("HomeTableViewReload"), object: nil)
        
    }
    
}

extension HomeEventInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == seminarCollectionView {
            return seminarList.count
        }
        
        else {
            return networkingList.count
        }
        
//        switch section {
//        case 0:
//            print("section 개수: \(seminarList.count)")
//            return seminarList.count
//        case 1:
//            print("section 개수: \(networkingList.count)")
//            return networkingList.count
//        default:
//            print(fatalError())
//            return 0
//        }
        
//        if collectionView.tag == 0{
////            print("seminarList -> \(seminarList.count)")
//            return seminarList.count
//        }
//        else if collectionView.tag == 1 {
////            print("networkingList -> \(networkingList.count)")
//            return networkingList.count
//        }
//        print(fatalError("error"))
        
        //return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width/390*334
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem/334*140
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeEventCollectionViewCell.identifier, for: indexPath) as? HomeEventCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch collectionView.tag {
        case 0:
            cell.configureSeminarInfo(self.seminarList[indexPath.row])
        case 1:
            cell.configureNetworkingInfo(self.networkingList[indexPath.row])
        default:
            print("dataList Count Error")
        }
        
//        if collectionView.tag == 1{
////            cell.configure(seminarList[indexPath.row])
//            cell.configure(seminarList[indexPath.row])
//        }
//        else if collectionView.tag == 2{
//            cell.configure(networkingList[indexPath.row])
//        }
        return cell
    }
    
    // TODO: Notification Object 구조 만들어야함
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 0:
            NotificationCenter.default.post(name: Notification.Name("pushSeminarDetailVC"), object: seminarList[indexPath.row].programIdx)
        case 1:
            NotificationCenter.default.post(name: Notification.Name("pushNetworkingDetailVC"), object: networkingList[indexPath.row].programIdx)
        default:
            print(">>>error: HomeEventInfoTableViewCell didSelectRowAt")
        }
        
    }
    
}

