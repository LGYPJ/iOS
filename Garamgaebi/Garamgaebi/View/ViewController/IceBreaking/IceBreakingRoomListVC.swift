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
	let headerView = HeaderView(title: "아이스브레이킹")
    
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
