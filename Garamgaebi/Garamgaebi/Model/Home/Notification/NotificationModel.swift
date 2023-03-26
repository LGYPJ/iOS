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
    let result: NotificationInfo?
}

struct NotificationUnreadInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: NotificationUnreadInfo?
}

struct NotificationInfo: Codable {
    let result: [NotificationDetailInfo]?
    let hasNext: Bool
}

struct NotificationDetailInfo: Codable {
    let notificationIdx: Int
    let notificationType: String
    let content: String
    let resourceIdx: Int
    let resourceType: String
    let isRead: Bool
}

struct NotificationUnreadInfo: Codable {
    let isUnreadExist: Bool
}
