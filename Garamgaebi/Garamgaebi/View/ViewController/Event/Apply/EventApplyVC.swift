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
        label.text = "세미나 신청하기"
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
		scrollView.showsVerticalScrollIndicator = false
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
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var dateTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "일시"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var dateInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var locationTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "장소"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var locationInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var costTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "참가비"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var costInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var deadlineTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "신청 마감"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var deadlineInfoLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		label.textColor = .mainBlack
		
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
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.addLeftPadding()
		textField.addRightPadding()
//		textField.placeholder = "이름을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 14)!])


		return textField
	}()
	
	lazy var nameAlertLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red
		label.font = UIFont.NotoSansKR(type: .Regular, size: 10)
		label.text = "이름 형식을 확인해주세요."
//		label.isHidden = true
		label.alpha = 0
		
		return label
	}()
	
	lazy var nicknameTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "닉네임"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var nicknameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.addLeftPadding()
		textField.addRightPadding()
//		textField.placeholder = "닉네임을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "가입 시 닉네임을 적어주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 14)!])

		
		return textField
	}()
	
	lazy var nicknameAlertLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red
		label.font = UIFont.NotoSansKR(type: .Regular, size: 10)
		label.text = "닉네임이 일치하지 않습니다."
//		label.isHidden = true
		label.alpha = 0
		
		return label
	}()
	
	lazy var numberTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "전화번호"
		label.font = UIFont.NotoSansKR(type: .Bold, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var numberTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.addLeftPadding()
		textField.addRightPadding()
//		textField.placeholder = "전화번호를 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "숫자만 입력해주세요", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 14)!])

		
		return textField
	}()
	
	lazy var numberAlertLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red
		label.font = UIFont.NotoSansKR(type: .Regular, size: 10)
		label.text = "번호 형식이 올바르지 않습니다."
//		label.isHidden = true
		label.alpha = 0
		
		return label
	}()
	
	lazy var accountLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.NotoSansKR(type: .Medium, size: 14)
		label.textColor = .mainBlack
		
		return label
	}()
	
	lazy var clipBoardImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "ClipBoardImage")
		imageView.contentMode = .scaleAspectFit
		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	lazy var descriptionTextView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.NotoSansKR(type: .Medium, size: 14)
		textView.textColor = .mainBlack
		textView.backgroundColor = .clear
		textView.layer.cornerRadius = 12
		textView.textContainer.lineFragmentPadding = 0
		textView.textContainerInset = .zero
		textView.isEditable = false
		textView.isScrollEnabled = false
		
		return textView
	}()
	
	lazy var descriptionContainerView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 12
		view.backgroundColor = UIColor(hex: 0xF5F5F5)
		view.clipsToBounds = true
		return view
	}()
	
	lazy var registerButton: UIButton = {
		let button = UIButton()
		button.setTitle("신청하기", for: .normal)
		button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
		button.backgroundColor = UIColor.mainGray
		button.layer.cornerRadius = 10
		button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
		button.isEnabled = false
		
		
		return button
	}()
	
	// MARK: Properties
	let account = "카카오뱅크 3333-22-5500352"
	
	var isValidName = false {
		didSet {
			validName()
		}
	}
	var isValidNickname = false {
		didSet {
			validNickname()
		}
	}
	var isValidNumber = false {
		didSet {
			validNumber()
		}
	}
	
	var type: String
	var memberId: Int
	var programId: Int
	private var distance : CGFloat = 0
	private var scrollOffset : CGFloat = 0
	
	var seminarInfo: SeminarDetailInfo = .init(programIdx: 0, title: "", date: "", location: "", fee: 0, endDate: "", programStatus: "", userButtonStatus: "") {
		didSet {
			configureWithSeminarData()
		}
	}
	var networkingInfo: NetworkingDetailInfo = .init(programIdx: 0, title: "", date: "", location: "", fee: 0, endDate: "", programStatus: "", userButtonStatus: "") {
		didSet {
			configureWithNetworkingData()
		}
	}
	
    // MARK: - Life Cycle
	
	init(type: String, programId: Int) {
		self.type = type
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
		self.programId = programId
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureViews()
		configureTextField()
		configureGestureRecognizer()
		fetchProgramData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
        
        setKeyboardObserver()
        
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setKeyboardObserverRemove()
    }
    
	// view를 터치했을때 editing 끝나게, 하지만 scrollview touch는 안먹음
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

extension EventApplyVC {
	
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
	
	private func configureWithSeminarData() {
		titleLabel.text = "세미나 신청"
		eventNameLabel.text = seminarInfo.title
		dateInfoLabel.text = seminarInfo.date.formattingDetailDate()
		locationInfoLabel.text = seminarInfo.location
		if seminarInfo.fee == 0 {
//			costStackView.isHidden = true
			costInfoLabel.text = "무료"
			accountLabel.isHidden = true
			clipBoardImageView.isHidden = true
			descriptionTextView.isHidden = true
			descriptionContainerView.isHidden = true
		} else {
//			costStackView.isHidden = false
			accountLabel.isHidden = false
			clipBoardImageView.isHidden = false
			descriptionTextView.isHidden = false
			descriptionContainerView.isHidden = false
			costInfoLabel.text = "\(seminarInfo.fee)원"
			accountLabel.text = "\(account)"
			descriptionTextView.text = "입금자명을 닉네임/이름(예시: 찹도/민세림)으로 해주셔야 합니다.\n\n신청 확정은 신청 마감 이후에 일괄 처리됩니다.\n신청취소는 일주일 전까지 가능합니다.(이후로는 취소 불가)\n환불은 모임 당일부터 7일 이내에 순차적으로 진행됩니다.\n\n입금이 완료되지 않으면 신청이 자동적으로 취소됩니다."
		}
		
		deadlineInfoLabel.text = seminarInfo.endDate.formattingDetailDate()
	}
	
	private func configureWithNetworkingData() {
		self.titleLabel.text = "네트워킹 신청"
		eventNameLabel.text = networkingInfo.title
		dateInfoLabel.text = networkingInfo.date.formattingDetailDate()
		locationInfoLabel.text = networkingInfo.location
		if networkingInfo.fee == 0 {
//			costStackView.isHidden = true
			costInfoLabel.text = "무료"
			accountLabel.isHidden = true
			clipBoardImageView.isHidden = true
			descriptionTextView.isHidden = true
			descriptionContainerView.isHidden = true
		} else {
//			costStackView.isHidden = false
			accountLabel.isHidden = false
			clipBoardImageView.isHidden = false
			descriptionTextView.isHidden = false
			descriptionContainerView.isHidden = false
			costInfoLabel.text = "\(networkingInfo.fee)원"
			accountLabel.text = "\(account)"
			descriptionTextView.text = "입금자명을 닉네임/이름(예시: 찹도/민세림)으로 해주셔야 합니다.\n\n신청 확정은 신청 마감 이후에 일괄 처리됩니다.\n신청취소는 일주일 전까지 가능합니다.(이후로는 취소 불가)\n환불은 모임 당일부터 7일 이내에 순차적으로 진행됩니다.\n\n입금이 완료되지 않으면 신청이 자동적으로 취소됩니다."
		}
		
		deadlineInfoLabel.text = networkingInfo.endDate.formattingDetailDate()
	}
	
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
		
		[eventInfoBackgroundView, nameTitleLabel, nameTextField, nameAlertLabel, nicknameTitleLabel, nicknameTextField, nicknameAlertLabel, numberTitleLabel, numberTextField, numberAlertLabel, descriptionContainerView]
			.forEach {contentView.addSubview($0)}
		
        // eventInfoBackgroundView
		eventInfoBackgroundView.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview().inset(16)
		}
		
        // nameTitleLabel
		nameTitleLabel.snp.makeConstraints {
			$0.top.equalTo(eventInfoBackgroundView.snp.bottom).offset(16)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // nameTextField
		nameTextField.snp.makeConstraints {
			$0.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
		nameAlertLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(nameTextField.snp.bottom).offset(2)
		}
		
        // nicknameTitleLabel
		nicknameTitleLabel.snp.makeConstraints {
			$0.top.equalTo(nameAlertLabel.snp.bottom).offset(16)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // nicknameTextField
		nicknameTextField.snp.makeConstraints {
			$0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
		nicknameAlertLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(nicknameTextField.snp.bottom).offset(2)
		}
		
        // numberTitleLabel
		numberTitleLabel.snp.makeConstraints {
			$0.top.equalTo(nicknameAlertLabel.snp.bottom).offset(16)
			$0.leading.equalToSuperview().inset(16)
		}
		
        // numberTextField
		numberTextField.snp.makeConstraints {
			$0.top.equalTo(numberTitleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(48)
		}
		
		numberAlertLabel.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(16)
			$0.top.equalTo(numberTextField.snp.bottom).offset(2)
		}
		
		descriptionContainerView.snp.makeConstraints {
			$0.top.equalTo(numberTextField.snp.bottom).offset(44)
			$0.leading.trailing.equalToSuperview().inset(16)
			$0.bottom.equalToSuperview().inset(16)
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
		
		[accountLabel, clipBoardImageView, descriptionTextView]
			.forEach {descriptionContainerView.addSubview($0)}
		accountLabel.snp.makeConstraints {
			$0.top.equalToSuperview().inset(12)
			$0.leading.equalToSuperview().inset(12)
		}
		clipBoardImageView.snp.makeConstraints {
			$0.width.equalTo(11.3)
			$0.height.equalTo(13.3)
			$0.leading.equalTo(accountLabel.snp.trailing).offset(4)
			$0.centerY.equalTo(accountLabel)
		}
		
		// descriptionTextView
		descriptionTextView.snp.makeConstraints {
			$0.top.equalTo(accountLabel.snp.bottom).offset(12)
			$0.leading.trailing.equalToSuperview().inset(12)
			$0.bottom.equalToSuperview().inset(12)
		}
		
		
	}
	
	// textField delegate 등록
	private func configureTextField() {
		nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		numberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		
//		nameTextField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
//		nameTextField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
//
//		nicknameTextField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
//		nicknameTextField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
//
//		numberTextField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
//		numberTextField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
		
		nameTextField.delegate = self
		nicknameTextField.delegate = self
		numberTextField.delegate = self
		
		nameTextField.returnKeyType = .done
		nicknameTextField.returnKeyType = .done
		numberTextField.returnKeyType = .done

	}
	
	// 3개의 textField가 모두 조건을 만족했을때 버튼 활성화
	private func validateUserInfo() {
		if isValidName && isValidNickname && isValidNumber {
			UIView.animate(withDuration: 0.3) {[weak self] in
				self?.registerButton.backgroundColor = .mainBlue
				self?.registerButton.isEnabled = true
			}
		}
	}
	
	private func validName() {
		if isValidName {
			HideAlert(textField: self.nameTextField, alertLabel: self.nameAlertLabel)
		} else {
			showAlert(textField: self.nameTextField, alertLabel: self.nameAlertLabel, status: self.isValidName)
		}
	}
	
	private func validNickname() {
		if isValidNickname {
			HideAlert(textField: self.nicknameTextField, alertLabel: self.nicknameAlertLabel)
		} else {
			showAlert(textField: self.nicknameTextField, alertLabel: self.nicknameAlertLabel, status: self.isValidNickname)
		}
	}
	
	private func validNumber() {
		if isValidNumber {
			HideAlert(textField: self.numberTextField, alertLabel: self.numberAlertLabel)
		} else {
			showAlert(textField: self.numberTextField, alertLabel: self.numberAlertLabel, status: self.isValidNumber)
		}
	}
	
	private func showAlert(textField: UITextField, alertLabel: UILabel, status: Bool) {
		
		UIView.animate(withDuration: 0.3) {[weak self] in
			textField.layer.borderColor = UIColor.red.cgColor
			self?.registerButton.backgroundColor = .mainGray
			alertLabel.alpha = 1

		}
	}
	
	private func HideAlert(textField: UITextField, alertLabel: UILabel) {
		
		UIView.animate(withDuration: 0.3) {
			textField.layer.borderColor = UIColor.mainBlack.cgColor
//			alertLabel.isHidden = true
			alertLabel.alpha = 0
		}
	}
	
	private func configureGestureRecognizer() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewDidTap))
		tapGestureRecognizer.numberOfTapsRequired = 1
		tapGestureRecognizer.isEnabled = true
		tapGestureRecognizer.cancelsTouchesInView = false
		
		scrollView.addGestureRecognizer(tapGestureRecognizer)
		
		let tapClipBoard = UITapGestureRecognizer(target: self, action: #selector(clipBoardImageViewDidTap))
		tapClipBoard.numberOfTapsRequired = 1
		tapClipBoard.isEnabled = true
		
		clipBoardImageView.addGestureRecognizer(tapClipBoard)
	}
	
//	@objc func textFieldActivated(_ sender: UITextField) {
//		switch sender {
//		case nameTextField:
//			if isValidName {
//				sender.layer.borderColor = UIColor.mainBlack.cgColor
//			}
//		case nicknameTextField:
//			if isValidNickname {
//				sender.layer.borderColor = UIColor.mainBlack.cgColor
//			}
//		case numberTextField:
//			if isValidNumber {
//				sender.layer.borderColor = UIColor.mainBlack.cgColor
//			}
//		default:
//			return
//		}
//
//
//	}
//
//	@objc func textFieldInactivated(_ sender: UITextField) {
//		switch sender {
//		case nameTextField:
//			if isValidName {
//				sender.layer.borderColor = UIColor.mainGray.cgColor
//			}
//		case nicknameTextField:
//			if isValidNickname {
//				sender.layer.borderColor = UIColor.mainGray.cgColor
//			}
//		case numberTextField:
//			if isValidNumber {
//				sender.layer.borderColor = UIColor.mainGray.cgColor
//			}
//		default:
//			return
//		}
//	}
	
	@objc private func clipBoardImageViewDidTap() {
		UIPasteboard.general.string = self.account
		
		// 복사됐다고 토스트 메세지
		let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-100, width: 180, height: 35))
		toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		toastLabel.textColor = UIColor.white
		toastLabel.font = UIFont.NotoSansKR(type: .Regular, size: 14)
		toastLabel.textAlignment = .center;
		toastLabel.text = "클립보드에 복사되었습니다"
		toastLabel.alpha = 0.8
		toastLabel.layer.cornerRadius = 10;
		toastLabel.clipsToBounds  =  true
		self.view.addSubview(toastLabel)
		UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveEaseIn, animations: {
			 toastLabel.alpha = 0.0
		}, completion: {(isCompleted) in
			toastLabel.removeFromSuperview()
		})
	}
	
	@objc private func scrollViewDidTap() {
		self.view.endEditing(true)
	}
	
	// 뒤로가기 버튼 did tap
	@objc private func didTapBackBarButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc private func textFieldDidChange(_ sender: UITextField) {
		
		let text = sender.text ?? ""
		
		switch sender {
		case nameTextField:
			let nameRegEx =  "[가-힣A-Za-z]{1,20}"
			let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
			let result = nameTest.evaluate(with: text)
			
			self.isValidName = result
			
			// 이름 받는 property에 저장
		case nicknameTextField:
			if text == UserDefaults.standard.string(forKey: "nickname") {
				self.isValidNickname = true
			} else {
				self.isValidNickname = false
			}
			
			//저장
		case numberTextField:
			let numberRegEx = "[0-9]{11}"
			let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
			
			self.isValidNumber = numberTest.evaluate(with: text)
			//저장
		default:
			print("error")
		}
		validateUserInfo()
		
	}
	
	@objc private func didTapRegisterButton() {
		// alert and dismiss
		guard let name = nameTextField.text,
			  let nickname = nicknameTextField.text,
			  let number = numberTextField.text else {return}
		
		EventApplyViewModel.postApplyProgram(memberId: self.memberId, programId: self.programId, name: name, nickname: nickname, phone: number, completion: {[weak self] result in
			
			if result.isSuccess {
				let alert = UIAlertController(title: "신청이 완료되었습니다!", message: nil, preferredStyle: .alert)
				let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
					self?.navigationController?.popViewController(animated: true)
				}
				alert.addAction(confirmAction)
				self?.present(alert, animated: true)
			} else {
				let alert = UIAlertController(title: result.message, message: nil, preferredStyle: .alert)
				let confirmAction = UIAlertAction(title: "확인", style: .default)
				alert.addAction(confirmAction)
				self?.present(alert, animated: true)
			}
		})
	}

}

extension EventApplyVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		switch textField {
		case nameTextField:
			if isValidName {
				textField.layer.borderColor = UIColor.mainBlack.cgColor
			}
		case nicknameTextField:
			if isValidNickname {
				textField.layer.borderColor = UIColor.mainBlack.cgColor
			}
		case numberTextField:
			if isValidNumber {
				textField.layer.borderColor = UIColor.mainBlack.cgColor
			}
		default:
			return
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		switch textField {
		case nameTextField:
			if isValidName {
				textField.layer.borderColor = UIColor.mainGray.cgColor
			}
		case nicknameTextField:
			if isValidNickname {
				textField.layer.borderColor = UIColor.mainGray.cgColor
			}
		case numberTextField:
			if isValidNumber {
				textField.layer.borderColor = UIColor.mainGray.cgColor
			}
		default:
			return
		}
		
	}

}

extension EventApplyVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height -= view.safeAreaInsets.top // 이 부분 조절하면서 스크롤 올리는 정도 변경
            safeArea.size.height -= headerView.frame.height // scrollView 말고 view에 headerView가 있기때문에 제외
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking
            
            // determine which UIView was selected and if it is covered by keyboard
            let activeField: UIView? = [nameTextField, nicknameTextField, numberTextField].first { $0.isFirstResponder }
            if let activeField = activeField {
                if safeArea.contains(CGPoint(x: 0, y: activeField.frame.maxY)) {
                    print("No need to Scroll")
                    return
                } else {
                    distance = activeField.frame.maxY - safeArea.size.height
                    scrollOffset = scrollView.contentOffset.y
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset + distance), animated: true)
                }
            }
            // prevent scrolling while typing
            scrollView.isScrollEnabled = false
        }
    }
    
    @objc private func keyboardWillHide() {
        
        if distance == 0 {
            return
        }
        // return to origin scrollOffset
//        self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        scrollOffset = 0
        distance = 0
        scrollView.isScrollEnabled = true
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func setKeyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

