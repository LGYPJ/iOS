//
//  EventApplyVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/13.
//

import UIKit
import SnapKit


class EventApplyVC: UIViewController {
	
    // MARK: - Subviews
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "세미나"
        label.textColor = UIColor(hex: 0x000000,alpha: 0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor(hex: 0x000000,alpha: 0.8)
        button.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        
        return button
    }()
    
	lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		
		scrollView.isScrollEnabled = true
		return scrollView
	}()
	// 스크롤 뷰 내의 content를 표시할 view(필수임)
	lazy var contentView: UIView = {
		let view = UIView()
		
		return view
	}()
	
	lazy var eventInfoBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(hex: 0xEBF0FF)
		view.layer.cornerRadius = 12
		
		return view
	}()
	
	lazy var eventNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
		label.textColor = .black
		
		return label
	}()
	
	lazy var dateTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "일시"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var dateInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var locationTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "장소"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var locationInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var costTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "참가비"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var costInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var deadlineTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "신청 마감"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var deadlineInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .black
		
		return label
	}()
	
	lazy var dateStackView: UIStackView = {
		let stackView = UIStackView()
		[dateTitleLabel, dateInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()
	
	lazy var locationStackView: UIStackView = {
		let stackView = UIStackView()
		[locationTitleLabel, locationInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()

	lazy var costStackView: UIStackView = {
		let stackView = UIStackView()
		[costTitleLabel, costInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()

	lazy var deadlineStackView: UIStackView = {
		let stackView = UIStackView()
		[deadlineTitleLabel, deadlineInfoLabel]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .horizontal
		stackView.spacing = 8
		
		return stackView
	}()

	lazy var eventInfoStackView: UIStackView = {
		let stackView = UIStackView()
		[dateStackView, locationStackView, costStackView, deadlineStackView]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .vertical
		stackView.alignment = .leading
		return stackView
	}()
	
	lazy var nameTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "이름"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
		label.textColor = .black
		
		return label
	}()
	
	lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 10
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "이름을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])


		return textField
	}()
	
	lazy var nicknameTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "닉네임"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
		label.textColor = .black
		
		return label
	}()
	
	lazy var nicknameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 10
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "닉네임을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])

		
		return textField
	}()
	
	lazy var numberTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "전화번호"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
		label.textColor = .black
		
		return label
	}()
	
	lazy var numberTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 10
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "전화번호를 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "전화번호를 입력해주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])

		
		return textField
	}()
	
	lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
//		textView.layer.borderWidth = 0
		textView.font = UIFont.NotoSansKR(type: .Medium, size: 14)
		textView.textColor = .black
		textView.backgroundColor = UIColor(hex: 0xF5F5F5)
		textView.layer.cornerRadius = 12
		textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		textView.isEditable = false
		textView.isScrollEnabled = false
		
		return textView
	}()
	
	lazy var registerButton: UIButton = {
		let button = UIButton()
		button.setTitle("신청하기", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		button.backgroundColor = UIColor.mainBlue
		button.layer.cornerRadius = 10
		return button
	}()
	
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureViews()
		configureDummyData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
	}
	
	// TODO: API연동 후 삭제
	func configureDummyData() {
//		descriptionTextView.isHidden = true
//		costStackView.isHidden = true
		eventNameLabel.text = "2차 세미나"
		dateInfoLabel.text = "2023-02-10 오후 6시"
		locationInfoLabel.text = "가천대학교 비전타워 B201"
		costInfoLabel.text = "10000원"
		deadlineInfoLabel.text = "2023-01-09 오후 6시"
		
		descriptionTextView.text = "카카오뱅크 3333-22-5500352\n입금자명을 닉네임/이름(예시: 찹도/민세림)으로 해주셔야 합니다.\n\n신청 확정은 신청 마감 이후에 일괄 처리됩니다.\n신청취소는 일주일 전까지 가능합니다.(이후로는 취소 불가)\n환불은 모임 당일부터 7일 이내에 순차적으로 진행됩니다.\n\n입금이 완료되지 않으면 신청이 자동적으로 취소됩니다."
	}
}

extension EventApplyVC {
	
	private func configureViews() {
		view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(backButton)
        
		[headerView, scrollView, registerButton]
			.forEach {view.addSubview($0)}
        
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
		
        //headerView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // backButton
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // scrollView
		scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(registerButton.snp.top).offset(-15)
		}
        
        // registerButton
		registerButton.snp.makeConstraints {
			$0.bottom.equalToSuperview().inset(48)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
		[contentView]
			.forEach {scrollView.addSubview($0)}
		
        // contentView
		contentView.snp.makeConstraints {
			$0.width.equalToSuperview()
			$0.edges.equalToSuperview()
		}
		
		[eventInfoBackgroundView, nameTitleLabel, nameTextField, nicknameTitleLabel, nicknameTextField, numberTitleLabel, numberTextField, descriptionTextView]
			.forEach {contentView.addSubview($0)}
		
        // eventInfoBackgroundView
		eventInfoBackgroundView.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview().inset(16)
		}
		
        // nameTitleLabel
		nameTitleLabel.snp.makeConstraints {
			$0.top.equalTo(eventInfoBackgroundView.snp.bottom).offset(24)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // nameTextField
		nameTextField.snp.makeConstraints {
			$0.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
        // nicknameTitleLabel
		nicknameTitleLabel.snp.makeConstraints {
			$0.top.equalTo(nameTextField.snp.bottom).offset(16)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // nicknameTextField
		nicknameTextField.snp.makeConstraints {
			$0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
        // numberTitleLabel
		numberTitleLabel.snp.makeConstraints {
			$0.top.equalTo(nicknameTextField.snp.bottom).offset(16)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // numberTextField
		numberTextField.snp.makeConstraints {
			$0.top.equalTo(numberTitleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
        // descriptionTextView
		descriptionTextView.snp.makeConstraints {
			$0.top.equalTo(numberTextField.snp.bottom).offset(44)
			$0.leading.trailing.equalToSuperview().inset(18)
			$0.bottom.equalToSuperview()
		}
		
		
		[eventNameLabel,eventInfoStackView]
			.forEach {eventInfoBackgroundView.addSubview($0)}
		
        // eventNameLabel
		eventNameLabel.snp.makeConstraints {
			$0.top.equalToSuperview().offset(5.5)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // eventInfoStackView
		eventInfoStackView.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(eventNameLabel.snp.bottom).offset(8)
			$0.bottom.equalToSuperview().inset(12)
		}
		
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
}
