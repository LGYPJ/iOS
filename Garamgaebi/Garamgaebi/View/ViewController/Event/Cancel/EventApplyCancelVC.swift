//
//  EventApplyCancelVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/12.
//

import UIKit
import SnapKit

class EventApplyCancelVC: UIViewController {
	
    // MARK: - Subviews
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "신청 취소"
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
	
	let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isScrollEnabled = true
		
		return scrollView
	}()
	
	let contentView: UIView = {
		let view = UIView()
		
		return view
	}()
    
	lazy var programInfoView: UIView = {
		let view = UIView()
		view.backgroundColor = .mainLightBlue
		view.layer.cornerRadius = 12
		
		return view
	}()

	lazy var programNameLabel: UILabel = {
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

	lazy var seminarInfoStackView: UIStackView = {
		let stackView = UIStackView()
		[dateStackView, locationStackView, costStackView, deadlineStackView]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.axis = .vertical
		stackView.alignment = .leading
		return stackView
	}()
	
	lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "이름을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "정현우", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)

		return textField
	}()
	
	lazy var nicknameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "닉네임을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "연현", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)
		
		return textField
	}()
	
	lazy var numberTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
//		textField.placeholder = "전화번호를 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "010-1234-5678", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)
		
		return textField
	}()
	
	lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setTitle("취소하기", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		button.backgroundColor = UIColor.mainBlue
		button.layer.cornerRadius = 12
		return button
	}()
	
	lazy var bankButton: UIButton = {
		let button = UIButton()
		button.setTitle("은행", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		button.backgroundColor = .white
		button.setTitleColor(.mainGray, for: .normal)
		button.contentHorizontalAlignment = .left
		// TODO: titleEdgeInsets은 iOS 15부터 deprecated됨 수정 예정
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
//		button.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
//		button.semanticContentAttribute = .forceRightToLeft
//		// TODO: deprecated
//		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: -30)
		
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.mainGray.cgColor
		button.layer.cornerRadius = 12
		
		return button
	}()

	
	lazy var downImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "chevron.down")
		imageView.tintColor = .black
		
		return imageView
	}()
	
	lazy var accountTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
		textField.leftViewMode = .always
		textField.attributedPlaceholder = NSAttributedString(string: "계좌번호를 입력해주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		
		return textField
	}()
	
	lazy var accountStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		[bankButton, accountTextField]
			.forEach {stackView.addArrangedSubview($0)}
		stackView.spacing = 8
		stackView.distribution = .fill

		return stackView
	}()
	
	// MARK: Properties
	var type: String
	var programId: Int
	var memberId: Int
	var seminarInfo = SeminarDetailInfo(programIdx: 0, title: "", date: "", location: "", fee: 0, endDate: "", programStatus: "", userButtonStatus: "") {
		didSet {
			configureSeminarData()
		}
	}
	var networkingInfo = NetworkingDetailInfo(programIdx: 0, title: "", date: "", location: "", fee: 0, endDate: "", programStatus: "", userButtonStatus: "") {
		didSet {
			configureNetworkingData()
		}
	}

    // MARK: - Life Cycle
	init(type: String, programId: Int, memberId: Int) {
		self.type = type
		self.programId = programId
		self.memberId = memberId
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureViews()
//		configureDummyData()
		configureAddTarget()
		configureTextField()
		configureGestureRecognizer()
        
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
		
		cancelButton.isEnabled = false
		cancelButton.backgroundColor = .mainGray
	}

	
	func configureDummyData() {
		programNameLabel.text = "2차 세미나"
		dateInfoLabel.text = "2023-02-10 오후 6시"
		locationInfoLabel.text = "가천대학교 비전타워 B201"
		costInfoLabel.text = "10000원"
		deadlineInfoLabel.text = "2023-01-09 오후 6시"
	}
    

    
}

// MARK: functions
extension EventApplyCancelVC: sendBankNameProtocol {
	
	private func configureViews() {
		view.backgroundColor = .white
		[headerView, scrollView,  cancelButton]
			.forEach {view.addSubview($0)}
		
		        
        //headerView
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
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
        
		scrollView.snp.makeConstraints {
			$0.top.equalTo(headerView.snp.bottom)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(cancelButton.snp.top).offset(-15)
//			$0.bottom.equalTo(cancelButton.snp.top)
		}
		
		scrollView.addSubview(contentView)
		contentView.snp.makeConstraints {
			$0.width.equalToSuperview()
			$0.edges.equalToSuperview()
		}
		
		[programInfoView, nameTextField, nicknameTextField, numberTextField, accountStackView, downImageView]
			.forEach {contentView.addSubview($0)}
		// seminarInfoView
		programInfoView.snp.makeConstraints {
//			$0.top.equalTo(headerView.snp.bottom).offset(16)
			$0.top.equalToSuperview().inset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
		}

        
		[programNameLabel, seminarInfoStackView]
			.forEach {programInfoView.addSubview($0)}
		
        // seminarNameLabel
		programNameLabel.snp.makeConstraints {
			$0.top.equalToSuperview().offset(12)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // seminarInfoStackView
		seminarInfoStackView.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(programNameLabel.snp.bottom).offset(8)
			$0.bottom.equalToSuperview().inset(12)
		}
		
       
		
        // nameTextField
		nameTextField.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(programInfoView.snp.bottom).offset(24)
			$0.height.equalTo(48)
		}
        
        // nicknameTextField
		nicknameTextField.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(nameTextField.snp.bottom).offset(12)
			$0.height.equalTo(48)
		}

        // numberTextField
		numberTextField.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(nicknameTextField.snp.bottom).offset(12)
			$0.height.equalTo(48)
		}
		
        // accountStackView
		accountStackView.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.top.equalTo(numberTextField.snp.bottom).offset(24)
			$0.height.equalTo(48)
			$0.bottom.equalToSuperview()
		}
		
        // bankButton
		bankButton.snp.makeConstraints {
			$0.width.equalTo(120)
		}

        // downImageView
		downImageView.snp.makeConstraints {
			$0.width.equalTo(18)
			$0.height.equalTo(18)
			$0.trailing.equalTo(bankButton.snp.trailing).offset(-8)
			$0.centerY.equalTo(bankButton)
		}
		
        // cancelButton
		cancelButton.snp.makeConstraints {
			$0.bottom.equalToSuperview().inset(48)
			$0.leading.trailing.equalToSuperview().inset(12)
			$0.height.equalTo(48)

		}
	}
	
	private func configureAddTarget() {
		cancelButton.addTarget(self, action: #selector(didTapRegisterCancelButton), for: .touchUpInside)
		bankButton.addTarget(self, action: #selector(didTapbankButton), for: .touchUpInside)
		accountTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
	}
	
	private func configureTextField() {
		accountTextField.delegate = self
		accountTextField.returnKeyType = .done
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func fetchProgramData() {
		switch self.type {
		case "SEMINAR":
			SeminarDetailViewModel.requestSeminarDetailInfo(memberId: self.memberId, seminarId: self.programId, completion: {[weak self] result in
				self?.seminarInfo = result
			})
		case "NETWORKING":
			NetworkingDetailViewModel.requestNetworkingDetailInfo(memberId: self.memberId, networkingId: self.programId, completion: {[weak self] result in
				self?.networkingInfo = result
			})
		default:
			return
		}
	}
	
	private func configureSeminarData() {
		programNameLabel.text = self.seminarInfo.title
		dateInfoLabel.text = self.seminarInfo.date
		locationInfoLabel.text = self.seminarInfo.location
		costInfoLabel.text = "\(self.seminarInfo.fee)"
		deadlineInfoLabel.text = self.seminarInfo.endDate
	}
	
	private func configureNetworkingData() {
		programNameLabel.text = self.networkingInfo.title
		dateInfoLabel.text = self.networkingInfo.date
		locationInfoLabel.text = self.networkingInfo.location
		costInfoLabel.text = "\(self.networkingInfo.fee)"
		deadlineInfoLabel.text = self.networkingInfo.endDate
	}
	
	private func configureGestureRecognizer() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewDidTap))
		tapGestureRecognizer.numberOfTapsRequired = 1
		tapGestureRecognizer.isEnabled = true
		tapGestureRecognizer.cancelsTouchesInView = false
		
		scrollView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	@objc private func scrollViewDidTap() {
		self.view.endEditing(true)
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo,
			  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
		
		let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
		scrollView.contentInset = contentInset
		scrollView.scrollIndicatorInsets = contentInset
		
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		let contentInset = UIEdgeInsets.zero
			scrollView.contentInset = contentInset
			scrollView.scrollIndicatorInsets = contentInset
	}
	
	// 은행 텍스트 필드 tap
	@objc private func didTapbankButton() {
		let vc = BankPopUpVC()
		vc.delegate = self
		self.present(vc, animated: true)
	}
	
	// 취소 완료 alert
	@objc private func didTapRegisterCancelButton() {
		guard let bank = self.bankButton.title(for: .normal),
			  let account = self.accountTextField.text else {return}
		
		EventApplyCancelViewModel.postBankAccount(memberId: self.memberId, programId: self.programId, bank: bank, account: account, completion: {[weak self] response in
			if !response.isSuccess {
				let sheet = UIAlertController(title: nil, message: response.message, preferredStyle: .alert)
				let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: {[weak self] _ in
					self?.navigationController?.popViewController(animated: true)
				})
				sheet.addAction(closeAction)
				
				self?.present(sheet, animated: true)
			} else {
				let sheet = UIAlertController(title: nil, message: "신청 취소가 완료되었습니다.", preferredStyle: .alert)
				let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: {[weak self] _ in
					self?.navigationController?.popViewController(animated: true)
				})
				sheet.addAction(closeAction)
				
				self?.present(sheet, animated: true)
			}
			
		})
		
		
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc private func textFieldDidChange(textField: UITextField) {
		if textField.text == "" || bankButton.currentTitle == "은행"  {
			cancelButton.isEnabled = false
			cancelButton.backgroundColor = .mainGray
		} else {
			cancelButton.isEnabled = true
			cancelButton.backgroundColor = .mainBlue
		}
		
	}
	
	func sendBankName(name: String) {
		bankButton.setTitle(name, for: .normal)
		bankButton.setTitleColor(.black, for: .normal)

		textFieldDidChange(textField: accountTextField)
	}

}

extension EventApplyCancelVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

}
