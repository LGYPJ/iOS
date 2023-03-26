//
//  HomeNetworkingPopUpVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/28.
//

import UIKit

class HomeNetworkingPopUpVC: UIViewController {

    // MARK: Init Properties
    var x: CGFloat
    var y: CGFloat
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var networkingPopUpView: UIImageView = {
        let view = UIImageView()
        let img = UIImage(named: "NetworkingPopUp")
        let transparentImage = img?.image(alpha: 0.94)
        transparentImage?.withTintColor(.white, renderingMode: .alwaysOriginal)
        view.image = transparentImage
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.mainBlack.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 12
//
//        /// shadow가 있으려면 layer.borderWidth 값이 필요
//        emptyView.layer.borderWidth = 1
//        /// 테두리 밖으로 contents가 있을 때, 마스킹(true)하여 표출안되게 할것인지 마스킹을 off(false)하여 보일것인지 설정
//        emptyView.layer.masksToBounds = false
//        /// shadow 색상
//        emptyView.layer.shadowColor = UIColor.black.cgColor
//        /// 현재 shadow는 view의 layer 테두리와 동일한 위치로 있는 상태이므로 offset을 통해 그림자를 이동시켜야 표출
//        emptyView.layer.shadowOffset = CGSize(width: 0, height: 20)
//        /// shadow의 투명도 (0 ~ 1)
//        emptyView.layer.shadowOpacity = 0.8
//        /// shadow의 corner radius
//        emptyView.layer.shadowRadius = 5.0
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(networkingPopUpView)
        networkingPopUpView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(y)
            make.left.equalToSuperview().inset(x)
            make.width.equalTo(252)
            make.height.equalTo(71)
        }
       backgroundDismiss()
    }
    
    func backgroundDismiss(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(backgroundTap)))
    }
    
    @objc func backgroundTap(){
        self.dismiss(animated: true, completion: nil)
    }
}
