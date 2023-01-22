//
//  ServiceBottomSheetVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/22.
//

import UIKit

import SnapKit

class ServiceBottomSheetVC: UIViewController {
    
    // MARK: - Subviews
    // 기존 화면을 흐려지게 만들기 위한 뷰
    private let dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    // 바텀 시트 뷰
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 28
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    // dismiss Indicator View UI 구성 부분
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    // 바텀시트 내부 구성
    let titleLabel = UILabel().then {
        $0.text = "질문 유형을 선택해주세요"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        $0.textColor = .mainBlack
    }
    
    let type1Label = UILabel().then {
        $0.text = "이용문의"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 18)
        $0.textColor = .mainBlack
    }
    
    let type2Label = UILabel().then {
        $0.text = "오류신고"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 18)
        $0.textColor = .mainBlack
    }
    
    let type3Label = UILabel().then {
        $0.text = "서비스 제안"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 18)
        $0.textColor = .mainBlack
    }
    
    let etcLabel = UILabel().then {
        $0.text = "기타"
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 18)
        $0.textColor = .mainBlack
    }
    
    // MARK: - Properties
    // 바텀 시트 높이
    let bottomHeight: CGFloat = 359
    
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    // 선택된 텍스트
    var selectedType : String = ""
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    // MARK: - Functions
    // UI 세팅 작업
    private func configureUI() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        view.addSubview(dismissIndicatorView)
        
        [titleLabel, type1Label, type2Label, type3Label, etcLabel]
            .forEach { bottomSheetView.addSubview($0) }
        
        dimmedBackView.alpha = 0.0
        configureLayout()
    }
    
    // 레이아웃 세팅
    private func configureLayout() {
        dimmedBackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedBackView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            bottomSheetViewTopConstraint
        ])
        
        dismissIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 102),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 7),
            dismissIndicatorView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 12),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
        // 바텀시트 내부
        // 타이틀
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(25)
        }
        // 이용문의
        type1Label.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.equalTo(titleLabel)
        }
        // 오류 신고
        type2Label.snp.makeConstraints {
            $0.top.equalTo(type1Label.snp.bottom).offset(11)
            $0.leading.equalTo(type1Label)
        }
        // 서비스 제안
        type3Label.snp.makeConstraints {
            $0.top.equalTo(type2Label.snp.bottom).offset(11)
            $0.leading.equalTo(type1Label)
        }
        // 기타
        etcLabel.snp.makeConstraints {
            $0.top.equalTo(type3Label.snp.bottom).offset(11)
            $0.leading.equalTo(type1Label)
        }
    }
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
}