//
//  HomeSeminarPopUpVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/28.
//

import UIKit

class HomeSeminarPopUpVC: UIViewController {

    // MARK: Init Properties
    var x: CGFloat
    var y: CGFloat
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var seminarPopUpView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SeminarPopUp")
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(seminarPopUpView)
        seminarPopUpView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(y)
            make.left.equalToSuperview().inset(x)
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
