//
//  IceBreakingRoomVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit
import Alamofire
import StompClientLib
import Kingfisher

class IceBreakingRoomVC: UIViewController {
	
	// MARK: 헤더 뷰
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
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
	lazy var userCollectionview: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 24
		layout.itemSize = CGSize(width: 44, height: 68)
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		
		return collectionView
	}()
	
	lazy var separator: UIView = {
		let view = UIView()
		view.backgroundColor = .mainGray
		
		return view
	}()
	
	lazy var cardCollectionView: UICollectionView = {
		let layout = CustomFlowLayout()
				
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.isScrollEnabled = false
		collectionView.decelerationRate = .fast
		
		
		return collectionView
	}()
	
	lazy var nextButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		button.tintColor = .white
		button.backgroundColor = .mainBlue
		
		return button
	}()
	
	lazy var startView: UIView = {
		let view = UIView()
		view.backgroundColor = .mainLightBlue
		view.layer.borderColor = UIColor.mainBlue.cgColor
		view.layer.borderWidth = 2
		view.layer.cornerRadius = 20
		
		return view
	}()
	
	lazy var startLabel: UILabel = {
		let label = UILabel()
		label.text = "시작하기"
		label.textColor = .mainBlue
		label.font = UIFont.NotoSansKR(type: .Bold, size: 24)
		
		
		return label
	}()
	
	// MARK: Properties
	private var isStart = false {
		didSet {
			userCollectionview.reloadData()
		}
	}
	private var currentIndex = 0
	private let programId: Int
	private let roomId: String
	private let roomName: String
	private let memberId: Int
	private let nickname: String
//	private var socketClient = StompClientLib()
	private var userList: [IceBrakingCurrentUserModel] = [] {
		didSet {
			self.userCollectionview.reloadData()
			self.cardCollectionView.reloadData()
		}
	}
	private var imageList: [String] = [] {
		didSet {
			self.cardCollectionView.reloadData()
		}
	}
	private var currentUserId: Int = 0
	private var currentUserIndex: Int = 0
	
    // MARK: - Life Cycle
	init(programId: Int ,roomId: String, roomName: String) {
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
		self.nickname = UserDefaults.standard.string(forKey: "nickname")!
		self.programId = programId
		self.roomId = roomId
		self.roomName = roomName
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		 view load 후 아미 연결된 상태일수도 있으니 delete 후 재연결
		IcebreakingViewModel.deleteGameUser(roomId: self.roomId, nextMemberIdx: -1, completion: {
			self.disconnectSocket()
			self.connectSocket()
		})
	
		
		// 앱 백그라운드 전환 시 disconnect
		NotificationCenter.default.addObserver(self, selector: #selector(didTapBackBarButton), name: UIApplication.didEnterBackgroundNotification, object: nil)
		
		UserDefaults.standard.setValue(roomId, forKey: "roomId")
		
		configureCollectionView()
		configureViews()
		configureButtonTarget()
		fetchGameImage()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		currentIndex = 0
		nextButton.alpha = 0
		
	}
	
}

extension IceBreakingRoomVC {
	// MARK: Configure
	private func configureCollectionView() {
		userCollectionview.delegate = self
		userCollectionview.dataSource = self
		userCollectionview.register(IceBreakingUserCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingUserCollectionViewCell.idetifier)
		cardCollectionView.delegate = self
		cardCollectionView.dataSource = self
		cardCollectionView.register(IceBreakingCardCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingCardCollectionViewCell.identifier)
		cardCollectionView.register(IceBreakingStartCardCollectionViewCell.self, forCellWithReuseIdentifier: IceBreakingStartCardCollectionViewCell.identifier)
	}
	
	private func configureViews() {
		self.titleLabel.text = self.roomName
		view.backgroundColor = .white
        [headerView, userCollectionview, separator, cardCollectionView, nextButton]
			.forEach {view.addSubview($0)}
        
        //headerView
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
        
        // subviews
		userCollectionview.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
			$0.leading.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.height.equalTo(68)
		}
        
		separator.snp.makeConstraints {
			$0.height.equalTo(1)
			$0.leading.trailing.equalToSuperview()
			$0.top.equalTo(userCollectionview.snp.bottom).offset(16)
		}
		
		cardCollectionView.snp.makeConstraints {
			$0.top.equalTo(separator.snp.bottom)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide)
		}
		
		nextButton.snp.makeConstraints {
			$0.centerY.equalTo(cardCollectionView)
			$0.width.height.equalTo(36)
			$0.trailing.equalTo(cardCollectionView).offset(-58)
		}
		nextButton.layer.cornerRadius = 36/2  // width(heitght)의 절반, 원 모양을 위해서
	}
	// Enable 상태에 따른 버튼 상태 조절
	private func configureNextButtonStatus(_ isEnable: Bool) {
		if isEnable {
			UIView.animate(withDuration: 0.5, animations: {
				self.nextButton.alpha = 1
			}, completion: { [weak self] _ in
				self?.nextButton.isEnabled = true
			})
		} else {
			UIView.animate(withDuration: 0.5, animations: {
				self.nextButton.alpha = 0
			}, completion: { [weak self] _ in
				self?.nextButton.isEnabled = false
			})
		}
	}
	
	private func configureButtonTarget() {
		nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
	}
	// 게임 이미지 리스트 get
	private func fetchGameImage() {
		IcebreakingViewModel.getGameImage(programId: self.programId, completion: { result in
			self.imageList = result
		})
	}
	// socket 연결
	private func connectSocket() {
		let url = URL(string: "ws://garamgaebi.shop:8080/ws/game/websocket")!
		WebSocketManager.shared.socketClient.openSocketWithURLRequest(
			request: NSURLRequest(url: url),
			delegate: self)
//		socketClient.openSocketWithURLRequest(
//			request: NSURLRequest(url: url),
//			delegate: self)
	}
	// socket 구독
	private func subscribeSocket() {
		WebSocketManager.shared.socketClient.subscribe(destination: "/topic/game/room/\(self.roomId)")
//		socketClient.subscribe(destination: "/topic/game/room/\(self.roomId)")
	}
	// socket 메세지 전송
	private func sendMessageWithSocket(type: String, message: String, profileUrl: String) {
		let payloadObject : [String : Any] = [
			"type" : type,
			"roomId": self.roomId,
			"sender": self.nickname,
			"message": message,
			"profileUrl": profileUrl
		]
		WebSocketManager.shared.socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/app/game/message")
//		socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/app/game/message")
	}
	// 소켓 연결해제
	private func disconnectSocket() {
		
		sendMessageWithSocket(type: "EXIT", message: "\(self.memberId)", profileUrl: "")
		WebSocketManager.shared.socketClient.disconnect()
//		socketClient.disconnect()
	}
	// 다음 아이템으로 스크롤
	private func scrollToNextItem() {
		currentIndex += 1
		if currentIndex < (imageList.count) {
			// 해당 인덱스로 스크롤
			cardCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
			cardCollectionView.reloadData()
		}
		
		let index = findCurrentUserIndex()
		scrollUserTo(index: index)
	}
	
	private func findNextUserIndex() -> Int {
		currentUserIndex = 0
		for user in userList {
			currentUserIndex += 1
			if user.memberIdx == currentUserId {
				break
			}
		}
		if currentUserIndex == userList.count {
			currentUserIndex -= userList.count
		}
		
		return currentUserIndex
	}
	
	private func findCurrentUserIndex() -> Int {
		currentUserIndex = 0
		for user in userList {
			if user.memberIdx == currentUserId {
				break
			}
			currentUserIndex += 1
		}
		if currentUserIndex == userList.count {
			currentUserIndex -= userList.count
		}
		
		return currentUserIndex
	}
	
	private func scrollUserTo(index: Int) {
		userCollectionview.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
		userCollectionview.reloadData()
		
		// 자신 차례이고, 마지막 카드가 아니라면 다음 버튼 활성화
		if userList[index].memberIdx == self.memberId && index != imageList.count && isStart {
			configureNextButtonStatus(true)
		} else {
			configureNextButtonStatus(false)
		}
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		if memberId != currentUserId || userList.count == 1 {
			IcebreakingViewModel.deleteGameUser(roomId: self.roomId, nextMemberIdx: -1, completion: {
				self.disconnectSocket()
			})
		} else {
			let nextMemberIndex = findNextUserIndex()
			let nextMemberIdx = userList[nextMemberIndex].memberIdx
			
			IcebreakingViewModel.deleteGameUser(roomId: self.roomId, nextMemberIdx: nextMemberIdx, completion: {
				self.disconnectSocket()
			})
		}
		
		self.navigationController?.popViewController(animated: true)
	}
	
	// 다음 카드 버튼 did tap
	@objc private func didTapNextButton() {
		let nextMemberIndex = findNextUserIndex()
		let nextMemberIdx = userList[nextMemberIndex].memberIdx
		
		IcebreakingViewModel.patchCurrentIndex(roomId: self.roomId, nextMemberIdx: nextMemberIdx, completion: {
			self.sendMessageWithSocket(type: "NEXT", message: "\(nextMemberIdx)", profileUrl: "")
		})
	}
}

// MARK: CollectionView
extension IceBreakingRoomVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == userCollectionview {
			switch section {
			case 0: return userList.count
			default: return 0
			}
		} else if collectionView == cardCollectionView {
			switch section {
			case 0: return 1
			case 1: return imageList.count
			default: return 0
			}
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == userCollectionview {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingUserCollectionViewCell.idetifier, for: indexPath) as? IceBreakingUserCollectionViewCell else {return UICollectionViewCell()}
			let cellData = userList[indexPath.row]
			
			cell.nameLabel.text = cellData.nickname.maxLength(length: 5)  // 5글자 이후 ...으로
			cell.profileImageView.kf.setImage(with: URL(string: cellData.profileUrl ?? ""), placeholder: UIImage(named: "DefaultProfileImage"), options: [.forceRefresh])
			
			// userCollectionView에서 차례인 유저 파란 테두리로 표시
			if userList[indexPath.row].memberIdx == currentUserId && isStart {
				cell.profileImageView.layer.borderWidth = 2
			}
			return cell
		} else if collectionView == cardCollectionView {
			switch indexPath.section {
			case 0:
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingStartCardCollectionViewCell.identifier, for: indexPath) as? IceBreakingStartCardCollectionViewCell else {return UICollectionViewCell()}
				
				return cell
			case 1:
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceBreakingCardCollectionViewCell.identifier, for: indexPath) as? IceBreakingCardCollectionViewCell else {return UICollectionViewCell()}
				
				let url = URL(string: imageList[indexPath.row])
				cell.contentImageView.kf.setImage(with: url)
				
				// 현재 셀, 앞 뒤 셀들만 보여지고 나머지는 숨김
				if (currentIndex-1)...(currentIndex+1) ~= (indexPath.row) {
					cell.isHidden = false
				} else {
					cell.isHidden = true
				}
				
				// 현재 셀만 내용이 보이도록
				if indexPath.row == currentIndex {
					cell.contentImageView.isHidden = false
				} else{
					cell.contentImageView.isHidden = true
				}
				
				// 자신 차례일 경우만 다음버튼 보이게
//				if !userList.isEmpty {
//					if userList[currentIndex % userList.count].memberIdx == self.memberId && (currentIndex != (imageList.count - 1)) {
//						configureNextButtonStatus(true)
//					} else {
//						configureNextButtonStatus(false)
//					}
//				}
				
				
				return cell
			default:
				return UICollectionViewCell()
			}
			
		} else {
			return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == cardCollectionView && indexPath.section == 0 {
			guard let cell = collectionView.cellForItem(at: indexPath) as? IceBreakingStartCardCollectionViewCell  else {return}
			// 시작하기 눌렀을때
				UIView.transition(with: cell.contentView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
					cell.contentView.alpha = 0
					cell.titleLabel.alpha = 0
				}, completion: { _ in
					if self.currentIndex < self.imageList.count {
						self.cardCollectionView.scrollToItem(at: IndexPath(row: self.currentIndex, section: 1), at: .centeredHorizontally, animated: false)
					} else {
						// index 초과인경우 마지막카드 표시
						self.cardCollectionView.scrollToItem(at: IndexPath(row: self.imageList.count - 1, section: 1), at: .centeredHorizontally, animated: false)
					}
					
					self.isStart = true
					
					if self.currentUserId == self.memberId {
						self.configureNextButtonStatus(true)
					} else {
						self.configureNextButtonStatus(false)
					}
					
					
				})
			
		}
	}
}

// MARK: StompClientLibDelegate
extension IceBreakingRoomVC: StompClientLibDelegate {
	// 메세지를 받았을때 호출
	func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
		guard let json = jsonBody as? [String: String] else { // type, sender, roomId, profileUrl, message
			print("error in decode jsonBody")
			return
		}
		// 빈 값 전송할 경우 빈 문자열로 전송(nil X -> "" O)
		guard let jsonType = json["type"], // ENTER, TALK, EXIT
			  let jsonNickname = json["sender"],
			  let jsonMessage = json["message"],
			  let jsonProfileUrl = json["profileUrl"]
		else {
			print("error(socket): json decode error")
			return
		}
		
		switch jsonType{
		// 유저가 입장했을때 전송
		case "ENTER":
			print("socket: \(jsonNickname)님이 입장하셨습니다!")
			// 서버에 유저 등록
			IcebreakingViewModel.getCurrentGameUserWithPost(roomId: self.roomId, completion: { result in
				self.userList = result
				
				let index = self.findCurrentUserIndex()
				self.scrollUserTo(index: index)
			})
		// 다음 버튼 눌렀을때 전송
		case "NEXT":
			self.currentUserId = Int(jsonMessage) ?? 0
			
			scrollToNextItem()
		// 유저가 퇴장했을때 전송
		case "EXIT":
			print("socket: \(jsonNickname)님이 퇴장하셨습니다!")
			
			// 자신 차례에 나간 유저라면 다음으로 스크롤
			if currentUserId == Int(jsonMessage) ?? 0 {
				let index = findNextUserIndex()
				scrollUserTo(index: index)
				currentUserId = userList[index].memberIdx
			}
			
			// 유저가 퇴장하면 기존 유저들이 다시 유저목록을 받아옴
			IcebreakingViewModel.getCurrentGameUserWithPost(roomId: self.roomId, completion: { result in
				print("Succes get currentgameuser")
				print(result)
				self.userList = result
			})
			
			
		default:
			return
		}
		
		
	}
	// 연결해제 후 전송
	func stompClientDidDisconnect(client: StompClientLib!) {
		print("Stomp socket is disconnected")
	}
	// 연결 후 전송
	func stompClientDidConnect(client: StompClientLib!) {
		print("Stomp socket is connected")
		subscribeSocket()
		// 연결 후 서버에 자신 등록
		IcebreakingViewModel.postGameUser(roomId: self.roomId, memberId: self.memberId, completion: { result in
			self.currentIndex = result.currentImgIdx
			self.currentUserId = result.currentMemberIdx
			
			
			// enter 메세지 전송
			self.sendMessageWithSocket(type: "ENTER", message: "", profileUrl: "")
		})
	}
	
	func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
		print("Receipt : \(receiptId)")
	}
	
	func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
		disconnectSocket()
		connectSocket()
	}
	
	func serverDidSendPing() {
		print("Server ping")
	}
	
	
	
}

