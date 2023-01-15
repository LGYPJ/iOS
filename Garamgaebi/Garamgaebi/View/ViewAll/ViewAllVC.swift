//
//  ViewAllVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

class ViewAllVC: UIViewController {
    
    // MARK: - Variable
    
    
    
    // MARK: - Subviews
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모아보기"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 24)
        return label
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UnderlineSegmentedControl(items: ["세미나","네트워킹","내 모임"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        return control
    }()
    
    lazy var firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainGray
        return view
    }()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        //        configureTableView()
        addSubViews()
        configLayouts()
        
    }
    
    // MARK: - Functions
    
    func addSubViews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(firstView)
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
        
        segmentedControl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(36)
        }
        
        firstView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func pushNextView(_ sender: UIButton) {
        switch sender {
            //        case notificationViewButton:
            //            self.navigationController?.pushViewController(HomeNotificationVC(), animated: true)
            //
        default:
            print("error")
        }
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            firstView.backgroundColor = .mainGray
        case 1:
            firstView.backgroundColor = .mainLightBlue
        case 2:
            firstView.backgroundColor = .mainLightGray

        default:
            print("fatal error")
        }
    }
}

extension ViewAllVC {
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
}
