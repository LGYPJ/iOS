//
//  EventApplyCancelVC.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/12.
//

import UIKit
import SnapKit
import Combine

class EventApplyCancelVC: UIViewController {
	
    // MARK: - Subviews
    
	let headerView = HeaderView(title: "신청 취소")
	
	let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isScrollEnabled = true
		
		return scrollView
	}()
	
	let contentView = UIView()
	
	lazy var programInfoView = ProgramInfoView(showRegisterButton: false)
	
	lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.addLeftPadding()
		textField.addRightPadding()
//		textField.placeholder = "이름을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)

		return textField
	}()
	
	lazy var nicknameTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.addLeftPadding()
		textField.addRightPadding()
//		textField.placeholder = "닉네임을 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		textField.isEnabled = false
		textField.backgroundColor = UIColor(hex: 0xF5F5F5)
		
		return textField
	}()
	
	lazy var numberTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.addLeftPadding()
		textField.addRightPadding()
//		textField.placeholder = "전화번호를 입력해주세요"
		textField.attributedPlaceholder = NSAttributedString(string: "전화번호", attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
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
		imageView.tintColor = .mainBlack
		
		return imageView
	}()
	
	lazy var accountTextField: UITextField = {
		let textField = UITextField()
		textField.layer.borderColor = UIColor.mainGray.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 12
		textField.addLeftPadding()
		textField.addRightPadding()
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
	var type: ProgramType
	var programId: Int
	var memberId: Int
	
	private var programInfo: ProgramDetailInfo = .init(programIdx: 0, title: "", date: "", location: "", fee: 0, endDate: "", programStatus: "", userButtonStatus: "") {
		didSet {
			configureProgramData()
			if programInfo.fee == 0 {
				cancelButton.isEnabled = true
				cancelButton.backgroundColor = .mainBlue
			}
		}
	}
	
	private var distance : CGFloat = 0
	private var scrollOffset : CGFloat = 0
	
	private let viewModel = EventApplyCancelViewModel()
	private let input = PassthroughSubject<EventApplyCancelViewModel.Input, Never>()
	private var cancelBag = Set<AnyCancellable>()

    // MARK: - Life Cycle
	init(type: ProgramType, programId: Int) {
		self.type = type
		self.programId = programId
		self.memberId = UserDefaults.standard.integer(forKey: "memberIdx")
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		bind()
		input.send(.viewDidLoad(type: self.type, programId: self.programId))
		
		configureViews()
		configureAddTarget()
		configureTextField()
		configureGestureRecognizer()
        
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		cancelButton.isEnabled = false
		cancelButton.backgroundColor = .mainGray
        setKeyboardObserver()
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setKeyboardObserverRemove()
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		cancelBag.forEach {$0.cancel()}
		cancelBag.removeAll()
		print(cancelBag)
	}
	
	private func bind() {
		let output = viewModel.transform(input: input.eraseToAnyPublisher())
		
		output
			.receive(on: DispatchQueue.main)
			.sink { event in
				switch event {
				case .getProgramDataDidSucceed(let data):
					guard let data = data.result else {return}
					self.programInfo = data
					
				case .getProgramDataDidFail(let error):
					print(error.localizedDescription)
					self.presentErrorView()
					
				case .getUserApplyDataDidSucceed(let data):
					self.configureUserData(data: data)
					
				case .getUserApplyDataDidFail(let error):
					print(error.localizedDescription)
					self.presentErrorView()
					
				case .postProgramApplyCancelDidSucceed(let result):
					self.presentAlert(result: result)
					
				case .postProgramApplyCancelDidFail(let error):
					print(error.localizedDescription)
					self.presentErrorView()
				}
			}
			.store(in: &cancelBag)
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
//			$0.bottom.equalToSuperview().inset(48)
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(14)
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
		accountTextField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
		accountTextField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
	}
	
	private func configureUserData(data: EventUserApplyModelResponse) {
		self.nameTextField.attributedPlaceholder = NSAttributedString(string: data.result.name, attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		self.nicknameTextField.attributedPlaceholder = NSAttributedString(string: data.result.nickname, attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
		self.numberTextField.attributedPlaceholder = NSAttributedString(string: data.result.phone, attributes: [.foregroundColor : UIColor.mainGray, .font: UIFont.NotoSansKR(type: .Regular, size: 16)!])
	}
	
	private func presentErrorView() {
		let errorView = ErrorPageView()
		errorView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(errorView, animated: false)
	}
	
	private func configureProgramData() {
		programInfoView.programInfo = self.programInfo
		
		if programInfo.fee == 0 {
			bankButton.isHidden = true
			accountTextField.isHidden = true
		} else {
			bankButton.isHidden = false
			accountTextField.isHidden = false
		}
	}
	
	private func presentAlert(result: EventApplyModel) {
		if !result.isSuccess {
			let sheet = UIAlertController(title: nil, message: result.message, preferredStyle: .alert)
			let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: {[weak self] _ in
				self?.navigationController?.popViewController(animated: true)
			})
			sheet.addAction(closeAction)
			
			self.present(sheet, animated: true)
		} else {
			let sheet = UIAlertController(title: nil, message: "신청 취소가 완료되었습니다.", preferredStyle: .alert)
			let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: {[weak self] _ in
				self?.navigationController?.popViewController(animated: true)
			})
			sheet.addAction(closeAction)
			
			self.present(sheet, animated: true)
			NotificationCenter.default.post(name: NSNotification.Name("ReloadMyEvent"), object: nil)
		}

	}
	
	private func configureGestureRecognizer() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewDidTap))
		tapGestureRecognizer.numberOfTapsRequired = 1
		tapGestureRecognizer.isEnabled = true
		tapGestureRecognizer.cancelsTouchesInView = false
		
		scrollView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	@objc func textFieldActivated(_ sender: UITextField) {
		sender.layer.borderColor = UIColor.mainBlack.cgColor
	}
	
	@objc func textFieldInactivated(_ sender: UITextField) {
		sender.layer.borderColor = UIColor.mainGray.cgColor
	}
	
	@objc private func scrollViewDidTap() {
		self.view.endEditing(true)
	}
	
	// 은행 텍스트 필드 tap
	@objc private func didTapbankButton() {
		let vc = BankPopUpVC()
		vc.delegate = self
		self.present(vc, animated: true)
	}
	
	// 취소 버튼 tap
	@objc private func didTapRegisterCancelButton() {
		let bank = self.bankButton.title(for: .normal) ?? ""
		let account = self.accountTextField.text ?? ""
		input.send(.applyCancelButtondidTap(bank: bank, account: account))
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
		bankButton.setTitleColor(.mainBlack, for: .normal)

		textFieldDidChange(textField: accountTextField)
	}

}

extension EventApplyCancelVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

}

extension EventApplyCancelVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height -= view.safeAreaInsets.top // 이 부분 조절하면서 스크롤 올리는 정도 변경
            safeArea.size.height -= headerView.frame.height // scrollView 말고 view에 headerView가 있기때문에 제외
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking
            
            // determine which UIView was selected and if it is covered by keyboard
            let activeField: UIView? = [accountTextField].first { $0.isFirstResponder }
            if let activeField = activeField {
                //if safeArea.contains(CGPoint(x: 0, y: activeField.frame.maxY))
                if safeArea.contains(CGPoint(x: 0, y: accountStackView.frame.maxY))
                {
                    print("No need to Scroll")
                    return
                } else {
//                    distance = activeField.frame.maxY - safeArea.size.height
                    distance = accountStackView.frame.maxY - safeArea.size.height
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

extension EventApplyCancelVC: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
