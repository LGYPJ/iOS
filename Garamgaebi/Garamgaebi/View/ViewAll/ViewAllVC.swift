//
//  ViewAllVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

class ViewAllVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
	}
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.navigationController?.pushViewController(NetworkingGameRoomVC(), animated: true)
	}
    
}
