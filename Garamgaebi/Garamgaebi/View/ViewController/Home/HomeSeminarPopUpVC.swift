//
//  HomeSeminarPopUpVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/28.
//

import UIKit

class HomeSeminarPopUpVC: UIViewController {

    lazy var seminarPopUpView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SeminarPopUp")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(seminarPopUpView)
        seminarPopUpView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(111)
            make.left.equalToSuperview().inset(50)
            make.width.equalTo(252)
            make.height.equalTo(51)
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
