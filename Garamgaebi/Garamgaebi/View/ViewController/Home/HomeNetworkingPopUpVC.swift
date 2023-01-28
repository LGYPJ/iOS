//
//  HomeNetworkingPopUpVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/28.
//

import UIKit

class HomeNetworkingPopUpVC: UIViewController {

    lazy var networkingPopUpView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "NetworkingPopUp")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(networkingPopUpView)
        networkingPopUpView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(329)
            make.left.equalToSuperview().inset(67)
            make.width.equalTo(252)
            make.height.equalTo(73)
        }
       backgroundDismiss()
    }
    
    func backgroundDismiss(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(backgroundTap)))
    }
    
    @objc func backgroundTap(){
        self.dismiss(animated: false, completion: nil)
    }
}
