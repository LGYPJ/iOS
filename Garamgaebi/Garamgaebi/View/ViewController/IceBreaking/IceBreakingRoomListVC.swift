//
//  IceBreakingRoomListVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//  아이스브레이킹 게임 방들의 리스트 VC

import UIKit
import SnapKit

class IceBreakingRoomListVC: UIViewController {
	
	// MARK: 헤더 뷰
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "아이스브레이킹"
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor(hex: 0x000000,alpha: 0.8)
        button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        
        return button
    }()
    
	// MARK: - Subviews
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = 16
		layout.minimumLineSpacing = 16
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		return collectionView
	}()
	
	// MARK: Properties
	var programId: Int
	var roomList: [GameRoomListModel] = [] {
		didSet {
			collectionView.reloadData()
		}
	}
	let roomNameList: [String] = ["이길여 총장님", "AI 공학관", "비전타워", "스타덤 광장", "바람개비 동산", "무당이", "가천관", "무한대 동상"]

    // MARK: - Life Cycle
	init(programId: Int) {
		self.programId = programId
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		cofigureViews()
		configureCollectionView()
		fetchGameRoomData()
    }
}

extension IceBreakingRoomListVC {
	// MARK: Configure
	// 뷰 속성 및 레이아웃
	private func cofigureViews() {
		view.backgroundColor = .white
        view.addSubview(headerView)
		view.addSubview(collectionView)
        
        // headerView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
		// subViews
		collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(IceBreakingRoomCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingRoomCollectionViewCell.identifier)
	}
	
	// 게임 방 리스트 fetch
	private func fetchGameRoomData() {
		IceBreakingRoomListViewModel.getGameRoomList(programId: self.programId, completion: {[weak self] result in
			self?.roomList = result
		})
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
}

extension IceBreakingRoomListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return roomList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingRoomCollectionViewCell.identifier, for: indexPath) as? IceBreakingRoomCollectionViewCell else {return UICollectionViewCell()}
		
		let cellData = roomNameList[indexPath.row]
		cell.roomTitleLabel.text = cellData
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.frame.width - 16) / 2
		let height = (collectionView.frame.height - (16*3)) / 4
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let roomId = roomList[indexPath.row].roomId
		
		
		IcebreakingViewModel.getGameIsStartedWithPost(roomId: roomId, completion: { result in
			let vc = IceBreakingRoomVC(programId: self.programId, roomId: roomId, roomName: self.roomNameList[indexPath.row], isStart: result)
			if result {
				// 진행중인 게임이라 alert
				let alert = UIAlertController(title: "이미 진행중인 게임입니다.", message: "참가하시겠습니까?", preferredStyle: .alert)
				let cancelAction = UIAlertAction(title: "취소", style: .destructive)
				let enterAction = UIAlertAction(title: "참가", style: .default) { _ in
					self.navigationController?.pushViewController(vc, animated: true)
				}
				
				alert.addAction(cancelAction)
				alert.addAction(enterAction)
				self.present(alert, animated: true)
			} else {
				self.navigationController?.pushViewController(vc, animated: true)
			}
		})
	}
	
	
}
