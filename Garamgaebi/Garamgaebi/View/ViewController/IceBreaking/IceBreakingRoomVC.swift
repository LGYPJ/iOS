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
	
    // MARK: - Subviews
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "가천관"
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
//		let layout = UICollectionViewFlowLayout()
		let layout = CustomFlowLayout()
				
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
//		collectionView.isUserInteractionEnabled = false
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
	
	private var isStart = false {
		didSet {
			userCollectionview.reloadData()
		}
	}
	private var cardCount = 10
	private var currentIndex = 0
	private let roomId: String
	private let roomName: String
	private let memberId: Int
	private let nickname: String
	private var socketClient = StompClientLib()
	private var userList: [IceBrakingCurrentUserModel] = [] {
		didSet {
			self.userCollectionview.reloadData()
			print(userList)
		}
	}
	
    // MARK: - Life Cycle
	
	init(roomId: String, roomName: String) {
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
		self.nickname = UserDefaults.standard.string(forKey: "nickname")!
		self.roomId = roomId
		self.roomName = roomName
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		disconnectSocket()
		configureCollectionView()
		configureViews()
		configureButtonTarget()
		connectSocket()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		currentIndex = 0
		nextButton.isHidden = true
		nextButton.alpha = 0
		
	}
	
}

extension IceBreakingRoomVC {

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
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // backButton
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // userCollectionview
		userCollectionview.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
			$0.leading.equalToSuperview()
			$0.trailing.equalToSuperview()
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
			$0.top.equalTo(separator.snp.bottom)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide)
		}
		
        // nextButton
		nextButton.snp.makeConstraints {
			$0.centerY.equalTo(cardCollectionView)
			$0.width.height.equalTo(36)
			$0.trailing.equalTo(cardCollectionView).offset(-58)
		}
		nextButton.layer.cornerRadius = 36/2
	}
	
	private func configureButtonTarget() {
		nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
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
		var payloadObject : [String : Any] = [
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
		if currentIndex < cardCount {
			// 해당 인덱스로 스크롤
			cardCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
			userCollectionview.scrollToItem(at: IndexPath(row: currentIndex % userList.count, section: 0), at: .centeredHorizontally, animated: true)
			
			cardCollectionView.reloadData()
			userCollectionview.reloadData()
		}
		// 다음 버튼 서서히 사라지는 애니메이션
		if currentIndex == (cardCount - 1) {
			UIView.animate(withDuration: 0.5, animations: {
				self.nextButton.alpha = 0
			}, completion: { [weak self] _ in
				self?.nextButton.isEnabled = false
			})
		}
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		IcebreakingViewModel.deleteGameUser(roomId: self.roomId, memberId: self.memberId+2, completion: {
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
			case 1: return cardCount
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
			cell.nameLabel.text = cellData.nickname
//			cell.profileImageView.kf.setImage(with: URL(string: cellData.profileUrl ?? ""), placeholder: UIImage(named: "ExProfileImage"))
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
extension IceBreakingRoomVC: StompClientLibDelegate {
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
				currentIndex += 1
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
		IcebreakingViewModel.postGameUser(roomId: self.roomId, memberId: self.memberId+2, completion: {
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

