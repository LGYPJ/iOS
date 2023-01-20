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
    
    
    private let seminarView: UIViewController = {
        let seminarView = ViewAllSeminarVC()
        return seminarView
    }()
    private let networkingView: UIViewController = {
        let networkingView = ViewAllNetworkingVC()
        return networkingView
    }()
    private let myEventView: UIViewController = {
        let myEventView = ViewAllMyEventVC()
        return myEventView
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.clipsToBounds = true
        vc.view.sizeToFit()
        return vc
    }()
    
    var dataViewControllers: [UIViewController] {
        [self.seminarView, self.networkingView, self.myEventView]
    }
    
    var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController 업데이트
            //print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()     
        configureViews()
        addSubViews()
        configLayouts()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(pushDetailVC), name: Notification.Name("didTapRegisterButton"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushDetailVC), name: Notification.Name("pushEventDetailVC"), object: nil)
    }
    
    @objc func pushDetailVC() {
        self.navigationController?.pushViewController(EventSeminarDetailVC(), animated: true)
    }
    
    
    // MARK: - Functions
    
    func addSubViews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(pageViewController.view)
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
        
        // segmentedControl
        segmentedControl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(36)
        }
        
        // pageViewController
        pageViewController.view.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
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
        self.currentPage = segment.selectedSegmentIndex
    }
}

extension ViewAllVC {
    private func configureViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
}


extension ViewAllVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }

}
