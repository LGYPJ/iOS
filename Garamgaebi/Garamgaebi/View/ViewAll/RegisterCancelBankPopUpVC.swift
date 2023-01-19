//
//  RegisterCancelBankPopUpVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/16.
//

import UIKit
import SnapKit

// 팝업 뷰 -> 신청 취소 뷰로 은행 이름을 보내기 위한 delegate 프로토콜
protocol sendBankNameProtocol {
	func sendBankName(name: String)
}

class RegisterCancelBankPopUpVC: UIViewController {
	
//	lazy var containerView: UIView = {
//		let view = UIView()
//		view.backgroundColor = .white
//		
//		return view
//	}()
	
	lazy var indicator: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		view.layer.cornerRadius = 2.5
		
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "은행을 선택해주세요"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 8
		layout.minimumInteritemSpacing = 8
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsVerticalScrollIndicator = false
		
		return collectionView
	}()
	
	let bankNameList: [String] = ["NH농협", "KB국민", "카카오뱅크", "신한", "우리", "IBK기업", "하나", "토스뱅크", "새마을", "부산" , "대구", "케이뱅크", "신협", "우체국", "SC제일", "경남", "수협", "광주", "전북", "저축은행", "시티", "제주", "KDB산업", "SBI저축은행", "산림조합", "BOA", "HSBC", "중국", "도이치", "중국공상", "JP모건", "BNP파리바", "중국건설"]
	
	var delegate: sendBankNameProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureCollectionView()
		
		if #available(iOS 15.0, *) {
			if let sheetVC = sheetPresentationController {
				sheetVC.detents = [.medium(), .large()]
			}
		} else {
		}
    }
    

    

}

extension RegisterCancelBankPopUpVC {
	private func configureView() {
//		view.backgroundColor = .black.withAlphaComponent(0.2)
//
//		view.addSubview(containerView)
//		containerView
		view.backgroundColor = .white
		[indicator, titleLabel, collectionView]
			.forEach {view.addSubview($0)}
		
		indicator.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.top.equalToSuperview().inset(10)
			$0.width.equalTo(60)
			$0.height.equalTo(5)
		}
		titleLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(25)
			$0.top.equalToSuperview().inset(40)
		}
		
		collectionView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview().inset(25)
			$0.bottom.equalToSuperview()
		}
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(BankListCollectionViewCell.self, forCellWithReuseIdentifier: BankListCollectionViewCell.identifier)
	}
}

extension RegisterCancelBankPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return bankNameList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankListCollectionViewCell.identifier, for: indexPath) as? BankListCollectionViewCell else {return UICollectionViewCell()}
		cell.imageView.image = UIImage(named: "BankIcon\(indexPath.row + 1)")
		cell.nameLabel.text = bankNameList[indexPath.row]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.frame.width - 8*2) / 3
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.sendBankName(name: bankNameList[indexPath.row])
		dismiss(animated: true)
	}
	
	
	
	
}
