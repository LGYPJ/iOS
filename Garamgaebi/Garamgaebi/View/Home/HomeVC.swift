//
//  HomeVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit
import Then
import SnapKit

class HomeVC: UIViewController {

    lazy var label = UILabel().then {
        $0.text = "123"
        $0.font = UIFont.NotoSansKR(type: .Thin, size: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.backgroundColor = .mainLightBlue
        
        // Do any additional setup after loading the view.
    }
    

}
