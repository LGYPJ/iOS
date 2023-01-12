//
//  SeminarPopUpVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/11.
//

import UIKit
import SnapKit

class SeminarPopUpVC: UIViewController {
	
	lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
		textView.isEditable = false
		textView.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		textView.textColor = .black
		
		return textView
	}()
	
	lazy var presentationLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var linkLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .link
		
		return label
	}()
	
	
	

    override func viewDidLoad() {
        super.viewDidLoad()

		
    }
    

    

}

extension SeminarPopUpVC {
	private func configureViews() {
		view.backgroundColor = .clear
		
		view.addSubview(contentView)
		
		[titleLabel, descriptionTextView, presentationLabel, linkLabel]
			.forEach {contentView.addSubview($0)}
	}
}
