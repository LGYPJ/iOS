//
//  LoginViewModel.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/02/03.
//

import Alamofire

class LoginViewModel {
	
	public static func postLogin(uniEmail: String, password: String, completion: @escaping ((LoginModel) -> Void)) {
		let url = "https://garamgaebi.shop/member/login"
		
		let body: [String: Any] = [
			"uniEmail": uniEmail,
			"password": password
		]
		
		AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
			.validate()
			.responseDecodable(of: LoginModelResponse.self) { response in
				switch response.result {
				case .success(let result):
					if result.isSuccess {
                        guard let passData = result.result else {return}
                        completion(passData)
					} else {
						print("실패(로그인): \(result.message)")
					}
				case .failure(let error):
					print("실패(AF-로그인): \(error.localizedDescription)")
				}
			}
		
	}
}
