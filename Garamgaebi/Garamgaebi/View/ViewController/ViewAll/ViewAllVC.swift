//
//  ViewAllVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

class ViewAllVC: UIViewController {
    
    // MARK: - Variable
    var pageNumber = HomeEventInfoTableViewCell.viewAllpageIndex {
        didSet {
            segmentedControl.selectedSegmentIndex = pageNumber
            currentPage = pageNumber
        }
    }
    
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
    
    lazy var segmentUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainGray
        return view
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
        addChild(pageViewController)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushEventDetailVC(_:)), name: Notification.Name("pushEventDetailVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushApplyCancelVC(_:)), name: Notification.Name("pushEventApplyCancelVC"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(pushViewAllSeminar), name: Notification.Name("pushViewAllSeminar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushViewAllNetworking), name: Notification.Name("pushViewAllNetworking"), object: nil)
    }
    

    @objc func pushEventDetailVC(_ notification: NSNotification) {
        let detailInfo: MyEventToDetailInfo = notification.object as! MyEventToDetailInfo
        
        switch(detailInfo.type){
        case "SEMINAR":
			let vc = EventSeminarDetailVC(seminarId: detailInfo.programIdx)
			vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            print("seminarId: \(detailInfo.programIdx)")
        case "NETWORKING":
			let vc = EventNetworkingDetailVC(networkingId: detailInfo.programIdx)
			vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            print("networkingId: \(detailInfo.programIdx)")
        default:
            fatalError(">>> ERROR: ViewAllVC pushEventDetailVC detailInfo")
        }
    }
    
    @objc func pushApplyCancelVC(_ notification: NSNotification) {
        let detailInfo: MyEventToDetailInfo = notification.object as! MyEventToDetailInfo
		let type: ProgramType = {
			if detailInfo.type == "SEMINAR" {
				return .SEMINAR
			} else {
				return .NETWORKING
			}
		}()
		let vc = EventApplyCancelVC(type: type, programId: detailInfo.programIdx)
		vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        print("ApplyCancel// \(detailInfo.type) id -> \(detailInfo.programIdx)")
    }
    
    @objc func pushViewAllSeminar() {
        pageNumber = HomeEventInfoTableViewCell.viewAllpageIndex
        self.tabBarController?.selectedIndex = 1
    }
    @objc func pushViewAllNetworking() {
        pageNumber = HomeEventInfoTableViewCell.viewAllpageIndex
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - Functions
    
    func addSubViews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(segmentUnderLineView)
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
        
        // segmentUnderLineView
        segmentUnderLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
            make.centerY.equalTo(segmentedControl.snp.bottom)
        }
        
        // pageViewController
        pageViewController.view.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(segmentedControl.snp.bottom)
            make.bottom.equalToSuperview()
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
    // 현재 페이지 뷰의 이전 뷰를 미리 로드
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
    // 현재 페이지 뷰의 다음 뷰를 미리 로드
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
    // 현재 페이지 로드가 끝났을 때
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
