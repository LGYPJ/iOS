//
//  WebSocketManager.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/18.
//

import StompClientLib

class WebSocketManager {
	static var shared = WebSocketManager()
	var socketClient = StompClientLib()
}
