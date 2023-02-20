//
//  LoginViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/03.
//

import Alamofire

class LoginViewModel {
	
	public static func postLogin(socialEmail: String, completion: @escaping ((Result<LoginModelResponse, AFError>) -> Void)) {
		let url = "https://garamgaebi.shop/member/login"
		
		let body: [String: Any] = [
			"socialEmail": socialEmail,
		]
		
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
			.validate()
			.responseDecodable(of: LoginModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
//                        guard let passData = result.result else {return}
//                        completion(passData)
                        completion(response.result)
					} else {
						print("실패(로그인): \(result.message)")
                        completion(response.result)
					}
				case .failure(let error):
					print("실패(AF-로그인): \(error.localizedDescription)")
				}
			}
		
	}
}
