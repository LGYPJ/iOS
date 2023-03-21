//
//  RequestInterceptor.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/17.
//

import Foundation
import Alamofire

let retryLimit = 3

final class MyRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("https://garamgaebi.shop/") == true,
              let accessToken = UserDefaults.standard.string(forKey: "BearerToken") else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error))
            return
        }
        // retry 최대 개수 정해줄수있음
        switch response.statusCode {
        case 401:
            let url = "https://garamgaebi.shop/member/login/auto"
            let body: [String: Any] = [
                "refreshToken": UserDefaults.standard.string(forKey: "refreshToken")!,
            ]
            AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: LoginModelResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess,
                           request.retryCount < retryLimit
                        {
                            guard let passData = result.result else {return}
                            UserDefaults.standard.set(passData.tokenInfo?.accessToken, forKey: "BearerToken")
                            UserDefaults.standard.set(passData.tokenInfo?.refreshToken, forKey: "refreshToken")
                            UserDefaults.standard.set(passData.tokenInfo?.memberIdx, forKey: "memberIdx")
                            UserDefaults.standard.set(result.result?.uniEmail, forKey: "uniEmail")
                            UserDefaults.standard.set(result.result?.nickname, forKey: "nickname")
                            completion(.retryWithDelay(1))
                        } else {
                            print("실패 : Token Refresh Fail : \(error)")
                        }
                    case .failure(let error):
                        print("실패: AF - Token Refresh Fail : \(error)")
                        completion(.doNotRetryWithError(error))
                    }
                }
        default:
            completion(.doNotRetry)
        }
        
    }
}
