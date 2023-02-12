//
//  WebSocketTestVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/11.
//

import SnapKit
import UIKit
import StompClientLib

class WebSocketTestVC: UIViewController {
	lazy var headerView: UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
		view.backgroundColor = .systemBackground
		view.layer.addBorder([.bottom], color: .mainGray, width: 1)
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "웹 소켓 테스트"
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
	
	lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.text = "placeholder"
		label.textColor = .black
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		return label
	}()
	
	lazy var inputTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.mainBlack.cgColor
		
		return textField
	}()
	
	lazy var sendButton: UIButton = {
		let button = UIButton()
		button.setTitle("전송", for: .normal)
		button.backgroundColor = .mainBlue
		button.setTitleColor(.white, for: .normal)
		
		return button
	}()
	
	private var socketClient = StompClientLib()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViews()
		disconnectSocket()
		connectSocket()
		sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
		subscribeSocket()
	}
}

extension WebSocketTestVC {
	private func configureViews() {
		view.backgroundColor = .white
		[headerView, messageLabel, inputTextField, sendButton]
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
		
		messageLabel.snp.makeConstraints {
			$0.top.equalTo(headerView.snp.bottom).offset(100)
			$0.centerX.equalToSuperview()
		}
		
		inputTextField.snp.makeConstraints {
			$0.top.equalTo(messageLabel.snp.bottom).offset(20)
			$0.centerX.equalToSuperview()
			$0.width.equalTo(200)
			$0.height.equalTo(30)
		}
		
		sendButton.snp.makeConstraints {
			$0.top.equalTo(inputTextField.snp.bottom).offset(20)
			$0.centerX.equalToSuperview()
			$0.width.equalTo(100)
			$0.height.equalTo(30)
		}
	}
	
	private func connectSocket() {
		let url = URL(string: "ws://garamgaebi.shop:8080/ws/game/websocket")!
		socketClient.openSocketWithURLRequest(
			request: NSURLRequest(url: url),
			delegate: self)
	}
	
	private func subscribeSocket() {
		socketClient.subscribe(destination: "/topic/game/room/12")
//		socketClient.subscribe(destination: "/topic/game/room/12")
//
//		socketClient.subscribeToDestination(destination: "/topic/game/room/2978cc36-90b5-43a0-b371-64beb69f218e", ackMode: .AutoMode)
//		socketClient.subscribeToDestination(destination: "/topic/game/room/2978cc36-90b5-43a0-b371-64beb69f218e", ackMode: .ClientIndividualMode)
//		socketClient.subscribeToDestination(destination: "/topic/game/room/2978cc36-90b5-43a0-b371-64beb69f218e", ackMode: .ClientMode)
//		socketClient.subscribeToDestination(destination: "/topic/game/room/12", ackMode: .AutoMode)
//		socketClient.subscribeToDestination(destination: "/topic/game/room/12", ackMode: .ClientIndividualMode)
//		socketClient.subscribeToDestination(destination: "/topic/game/room/12", ackMode: .ClientMode)
		
	}
	
	private func sendMessageWithSocket(message: String) {
		var payloadObject : [String : Any] = [
			"type" : "TALK",
			"roomId": "12",
			"sender": "연현",
			"message": "\(message)"
		]
		
		socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/app/game/message")
//		socketClient.sendMessage(message: "Test입니다", toDestination: "/app/game/message", withHeaders: nil, withReceipt: "Receipt가 머지")
	}
	
	private func disconnectSocket() {
		socketClient.disconnect()
	}
	
	
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		disconnectSocket()
		self.navigationController?.popViewController(animated: true)
	}
	
	// 전송 버튼 tap
	@objc private func didTapSendButton() {
		guard let message = inputTextField.text else {
			print("입력 오류")
			return
		}
		print("전송됨: \(message)")
		sendMessageWithSocket(message: message)
	}
}

extension WebSocketTestVC: StompClientLibDelegate {
	func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
		print("jsonBody: \(String(describing: jsonBody))")
		print("stringBody: \(String(describing: stringBody))")
		print("header: \(String(describing: header))")
		
		guard let JSON = jsonBody as? [String : AnyObject] else { return }
		print(JSON["message"])
		messageLabel.text = JSON["message"] as? String
	}
	
	func stompClientDidDisconnect(client: StompClientLib!) {
		print("Stomp socket is disconnected")
	}
	
	func stompClientDidConnect(client: StompClientLib!) {
		print("Stomp socket is connected")
			
		subscribeSocket()
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
