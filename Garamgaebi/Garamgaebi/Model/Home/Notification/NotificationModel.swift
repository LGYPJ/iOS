//
//  NotificationModel.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/07.
//

import Foundation

struct NotificationInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [NotificationInfo]?
}

struct NotificationInfo: Codable {
    let notificationIdx: Int
    let notificationType: String
    let content: String
    let resourceIdx: Int
    let resourceType: String
    let isRead: Bool
}
