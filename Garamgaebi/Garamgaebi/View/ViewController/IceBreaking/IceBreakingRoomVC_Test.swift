//
//  IceBreakingRoomVC_Test.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/15.
//

import UIKit
import SnapKit
import Alamofire
import StompClientLib
import Kingfisher

class IceBreakingRoomVC_Test: UIViewController {
	
	// MARK: - Subviews
	
	lazy var headerView: UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
		view.backgroundColor = .mainBlue
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
//        label.text = "가천관"
		label.textColor = UIColor(hex: 0xFFFFFF,alpha: 0.8)
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		return label
	}()
	
	lazy var backButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "arrowBackward")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		button.clipsToBounds = true
//		button.tintColor = UIColor(hex: 0xFFFFFF,alpha: 0.8)
		button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
		
		return button
	}()
	
	lazy var userCollectionview: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 24
		layout.itemSize = CGSize(width: 44, height: 68)
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.layer.cornerRadius = 12
		
		return collectionView
	}()
	
	lazy var separator: UIView = {
		let view = UIView()
		view.backgroundColor = .mainGray
		
		return view
	}()
	
	lazy var cardCollectionView: UICollectionView = {
//		let layout = UICollectionViewFlowLayout()
		let layout = CustomFlowLayout()
		layout.itemSize = CGSize(width: cardWidth, height: cardHeight)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
//		collectionView.isUserInteractionEnabled = false
		collectionView.isScrollEnabled = false
		collectionView.decelerationRate = .fast
		collectionView.backgroundColor = .clear
		
		
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
	
	private var isStart = false {
		didSet {
			userCollectionview.reloadData()
		}
	}
	private let cardWidth: CGFloat = UIScreen.main.bounds.width - 60
//	private let cardWidth: CGFloat = UIScreen.main.bounds.width - 84
	private let cardHeight: CGFloat = (UIScreen.main.bounds.width - 60) * 0.85
//	private let cardHeight: CGFloat = (UIScreen.main.bounds.width - 60) * 1.5
	private var cardCount = 10
	private var currentIndex = 0
	private let programId: Int
	private let roomId: String
	private let roomName: String
	private let memberId: Int
	private let nickname: String
	private var socketClient = StompClientLib()
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
	
	// MARK: - Life Cycle
	
	init(programId: Int ,roomId: String, roomName: String) {
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx") + 2
		self.nickname = UserDefaults.standard.string(forKey: "nickname")!
		self.programId = programId
		self.roomId = roomId
		self.roomName = roomName
		super.init(nibName: nil, bundle: nil)
//		self.cardWidth = UIScreen.main.bounds.width - 60
//		self.cardHeight = cardWidth * 0.85
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		IcebreakingViewModel.deleteGameUser(roomId: self.roomId, memberId: self.memberId, completion: {
			self.disconnectSocket()
			self.connectSocket()
		})
		
		configureCollectionView()
		configureViews()
		configureButtonTarget()
		fetchGameImage()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		currentIndex = 0
		nextButton.isHidden = true
		nextButton.alpha = 0

	}
	

	

	
}

extension IceBreakingRoomVC_Test {

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
		view.backgroundColor = UIColor(hex: 0xCBE2F7)
		
		[headerView, userCollectionview, separator, cardCollectionView, nextButton]
			.forEach {view.addSubview($0)}
		
		//headerView
		let window = UIApplication.shared.windows.first
		let top = window?.safeAreaInsets.top ?? 0
		headerView.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.height.equalTo(71 + top)
//			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.top.equalToSuperview()
		}
		
		[titleLabel, backButton]
			.forEach {headerView.addSubview($0)}
		
		// titleLabel
		titleLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
//			make.centerY.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
		}
		
		// backButton
		backButton.snp.makeConstraints { make in
			make.left.equalToSuperview().inset(16)
//			make.centerY.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
		}
		
		// userCollectionview
		userCollectionview.snp.makeConstraints {
			$0.top.equalTo(headerView.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(68)
		}
		
		// separator
		separator.snp.makeConstraints {
			$0.height.equalTo(1)
			$0.leading.trailing.equalToSuperview()
			$0.top.equalTo(userCollectionview.snp.bottom).offset(16)
		}
		
		// cardCollectionView
		cardCollectionView.snp.makeConstraints {
//			$0.top.equalTo(separator.snp.bottom).offset(36)
			$0.top.equalTo(separator.snp.bottom).offset(25)
			$0.leading.trailing.equalToSuperview()
			$0.height.equalTo(cardHeight)
//			$0.bottom.equalTo(view.safeAreaLayoutGuide)
		}

		// nextButton
		nextButton.snp.makeConstraints {
			$0.centerY.equalTo(cardCollectionView)
			$0.width.height.equalTo(36)
			$0.trailing.equalTo(cardCollectionView).offset(-58)
		}
		nextButton.layer.cornerRadius = 36/2
	}
	
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
	
	private func fetchGameImage() {
		IcebreakingViewModel.getGameImage(programId: self.programId, completion: { result in
			self.imageList = result
		})
	}
	
	private func connectSocket() {
		let url = URL(string: "ws://garamgaebi.shop:8080/ws/game/websocket")!
		socketClient.openSocketWithURLRequest(
			request: NSURLRequest(url: url),
			delegate: self)
	}
	
	private func subscribeSocket() {
		socketClient.subscribe(destination: "/topic/game/room/\(self.roomId)")
//		socketClient.subscribe(destination: "/topic/game/room/1")
	}

	private func sendMessageWithSocket(type: String, message: String, profileUrl: String) {
		let payloadObject : [String : Any] = [
			"type" : type,
			"roomId": self.roomId,
			"sender": self.nickname,
			"message": message,
			"profileUrl": profileUrl
		]
			
		socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/app/game/message")
//		socketClient.sendMessage(message: "Test입니다", toDestination: "/app/game/message", withHeaders: nil, withReceipt: "Receipt가 머지")
	}
	
	private func disconnectSocket() {
		userList = []
		sendMessageWithSocket(type: "EXIT", message: "", profileUrl: "")
		socketClient.disconnect()
	}
	
	private func scrollToNextItem() {
		currentIndex += 1
//		if currentIndex < (imageList.count - 1) {
		if currentIndex < (cardCount) {
			// 해당 인덱스로 스크롤
			cardCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
			userCollectionview.scrollToItem(at: IndexPath(row: currentIndex % userList.count, section: 0), at: .centeredHorizontally, animated: true)
			
			cardCollectionView.reloadData()
			userCollectionview.reloadData()
		}
		// 다음 버튼 서서히 사라지는 애니메이션
//		if currentIndex == (imageList.count - 1) {
		if currentIndex == (cardCount) {
			configureNextButtonStatus(true)
		}
		
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		IcebreakingViewModel.deleteGameUser(roomId: self.roomId, memberId: self.memberId, completion: {
			self.disconnectSocket()
		})
		self.navigationController?.popViewController(animated: true)
	}
	
	// 다음 카드 버튼 did tap
	@objc private func didTapNextButton() {
		sendMessageWithSocket(type: "TALK", message: "NEXT", profileUrl: "")
	}
}

// MARK: CollectionView
extension IceBreakingRoomVC_Test: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
			case 1: return cardCount
//			case 1: return imageList.count
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
			cell.nameLabel.text = cellData.nickname.maxLength(length: 5)
			cell.profileImageView.kf.setImage(with: URL(string: cellData.profileUrl ?? ""), placeholder: UIImage(named: "ExProfileImage"))
			if indexPath.row == currentIndex % userList.count && isStart {
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
				cell.contentImageView.image = UIImage(named: "ExIceBreakingCardText")
//				let url = URL(string: imageList[indexPath.row])
//				cell.contentImageView.kf.setImage(with: url)
				
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
				if !userList.isEmpty {
					if userList[currentIndex % userList.count].memberIdx == self.memberId && (currentIndex != (cardCount - 1)) {
						configureNextButtonStatus(true)
					} else {
						configureNextButtonStatus(false)
					}
				}
				
				
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
			UIView.transition(with: cell.contentView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
				cell.contentView.alpha = 0
				cell.titleLabel.alpha = 0
			}, completion: { [weak self] _ in
				self?.cardCollectionView.scrollToItem(at: IndexPath(row: self!.currentIndex, section: 1), at: .centeredHorizontally, animated: false)
				self?.isStart = true
				self?.nextButton.alpha = 1
				self?.nextButton.isHidden = false
			})
		}
	}
}

// MARK: StompClientLibDelegate
extension IceBreakingRoomVC_Test: StompClientLibDelegate {
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
		case "ENTER":
			print("socket: \(jsonNickname)님이 입장하셨습니다!")
			IcebreakingViewModel.getCurrentGameUserWithPost(roomId: self.roomId, completion: { result in
				self.userList = result
			})
			
		case "TALK":
			if jsonMessage == "NEXT" {
				scrollToNextItem()
			} else {
				
			}
		case "EXIT":
			print("socket: \(jsonNickname)님이 퇴장하셨습니다!")
			IcebreakingViewModel.getCurrentGameUserWithPost(roomId: self.roomId, completion: { result in
				self.userList = result
			})
			
		default:
			return
		}
		
		
	}
	
	func stompClientDidDisconnect(client: StompClientLib!) {
		print("Stomp socket is disconnected")
	}
	
	func stompClientDidConnect(client: StompClientLib!) {
		print("Stomp socket is connected")
		subscribeSocket()
//		self.sendMessageWithSocket(type: "ENTER", message: "", profileUrl: "")
		IcebreakingViewModel.postGameUser(roomId: self.roomId, memberId: self.memberId, completion: {
			// TODO: 나의 이미지 Url 얻어올 방법?
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
