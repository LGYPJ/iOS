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
    
    // MARK: - Subviews
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 24)
        return label
    }()
    
    lazy var notificationViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NotificationIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        
        //button.addTarget(self, action: #selector(presentNotificationView), for: .touchUpInside)
        
        return button
    }()
    
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        addSubViews()
        configLayouts()
        
        
    }
    
    // MARK: - Functions
    
    func addSubViews() {

        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(notificationViewButton)
 
    }
    
    func configLayouts() {
        
        //headerView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // notificationViewButton
        notificationViewButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
      
        
    }
    
     @objc private func buttonPressed(_ sender: Any) {
         if let button = sender as? UIBarButtonItem {
             switch button.tag {
             case 1:
                 // Change the background color to blue.
                 self.view.backgroundColor = .blue
             case 2:
                 // Change the background color to red.
                 self.view.backgroundColor = .red
             default:
                 print("error")
             }
         }
     }
     
}


extension HomeVC {
    
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


