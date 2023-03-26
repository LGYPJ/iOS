//
//  DeepLink.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/03/15.
//

import Foundation

// 예제 딥링크: my-app://main/first?message=deeplink-test-message&desc=test-desc
enum DeepLink {
    case login
    case main(message: String?, desc: String?)
    
    private static var scheme = "garamgaebi"
    private var host: String {
        switch self {
        case .login:
            return "login"
        case .main:
            return "main"
        }
    }
    private var path: String {
        switch self {
        case .login:
            return ""
        case .main:
            return "/first" // 주의: url.path값은 '/'로 시작하므로, path에도 '/'을 붙여주기
        }
    }
    
    init?(string: String) {
        guard
            let url = URL(string: string),
            let scheme = url.scheme,
            Self.scheme == scheme
        else { return nil }
        
        switch url {
        case .login:
            self = .login
        case .main(message: nil, desc: nil):
            self = .main(
                message: url.getQueryParameterValue(key: "message"),
                desc: url.getQueryParameterValue(key: "desc")
            )
        default:
            return nil
        }
    }
    
    static func ~= (lhs: Self, rhs: URL) -> Bool {
        lhs.host == rhs.host && lhs.path == rhs.path
    }
    
}

extension URL {
    func getQueryParameterValue(key: String) -> String? {
        URLComponents(url: self, resolvingAgainstBaseURL: true)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }
}
