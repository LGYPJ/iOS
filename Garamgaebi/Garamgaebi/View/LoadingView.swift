//
//  LoadingView.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/02/26.
//

import UIKit
import SnapKit

// 네트워크 작업 대기 시에 띄우는 로딩 애니메이션 뷰 클래스
final class LoadingView: UIView {
    
    // MARK: - Properties
    
    static let shared = LoadingView()
    
    // MARK: - SubViews
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    private let loadingView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loadingImage")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: - Initialization
    
    private init() {
        super.init(frame: .zero)
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.loadingView)
        loadingView.frame = loadingView.superview!.bounds
        
        self.contentView.snp.makeConstraints { make in
            make.center.equalTo(self.safeAreaLayoutGuide)
        }
        self.loadingView.snp.makeConstraints { make in
            make.center.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func show() {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if scene.activationState == .foregroundActive {
                    guard let window = ((scene as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window else { fatalError() }
                    window?.addSubview(self)
                    window?.bringSubviewToFront(self)
                    window?.endEditing(true)
                    break
                }
            }
        } else {
            guard let appDelegate = UIApplication.shared.delegate else { fatalError() }
            guard let window = appDelegate.window else { fatalError() }
            window?.addSubview(self)
            window?.bringSubviewToFront(self)
            window?.endEditing(true)
        }
        
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
        
//        self.loadingView.play()
        self.loadingView.rotate360Degrees()
//        UIView.animate(withDuration: 5.0) {
//            //self.loadingView.transform = CGAffineTransform(rotationAngle: .pi)
//
//        }
        UIView.animate(
            withDuration: 0.7,
            animations: { self.contentView.alpha = 1 }
        )
    }
    
    func hide(completion: @escaping () -> () = {}) {
//        self.loadingView.stop()
        self.loadingView.stopRotating()
        self.removeFromSuperview()
        completion()
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }

    func stopRotating(){
        self.layer.sublayers?.removeAll()
        //or
//        self.layer.removeAllAnimations()
    }
}
