//
//  InputCareerVC.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/12.
//

import UIKit
import SnapKit

class InputCareerVC: UIViewController {
    private var currentYear: Int = 0 {
        didSet {
            yearArray = (1950...currentYear).reversed().map { String($0) }
        }
    }
    private var currentYearMonth: Int = 0
    private var yearArray: [String] = []
    private var monthArray = (1...12).map { String(format:"%02d", $0) }
    private let maxTextCount = 22
    private var companyTextCount = 0 {
        didSet {
            if companyTextCount > maxTextCount {
                companyTextCount -= 1
            }
            companyTextCountLabel.text = "\(companyTextCount)/\(maxTextCount)"
        }
    }
    private var positionTextCount = 0 {
        didSet{
            if positionTextCount > maxTextCount {
                positionTextCount -= 1
            }
            positionTextCountLabel.text = "\(positionTextCount)/\(maxTextCount)"
        }
    }
    private var startYearValue =  "0"
    private var startMonthValue = "0"
    private var endYearValue =  "0"
    private var endMonthValue = "0"
    private var isWorking: Bool = false
    private var scrollOffset : CGFloat = 0
    private var distance : CGFloat = 0
    
    // MARK: - Subviews
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0, width:100, height:35))
        toolBar.tintColor = .mainBlack
        toolBar.backgroundColor = .mainLightGray
        
        let exitBtn = UIBarButtonItem()
        exitBtn.title = "확인"
        exitBtn.target = self
        exitBtn.action = #selector(pickerExit)
        exitBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.NotoSansKR(type: .Regular, size: 16)!], for: .normal)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelBtn = UIBarButtonItem()
        cancelBtn.title = "취소"
        cancelBtn.target = self
        cancelBtn.action = #selector(pickerCancel)
        cancelBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.NotoSansKR(type: .Regular, size: 16)!, NSAttributedString.Key.foregroundColor: UIColor(hex: 0xFF0000)], for: .normal)
        toolBar.setItems([cancelBtn,flexSpace,exitBtn], animated: true)
        return toolBar
    }()
    
    lazy var startDatePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 0
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var endDatePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 1
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var pagingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PagingImage4"))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "경력"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필에 기재할\n본인의 경력을 알려주세요"
        label.numberOfLines = 0
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        label.textColor = UIColor(hex: 0x8A8A8A)
        return label
    }()
    
    lazy var subtitleCompanyLabel: UILabel = {
        let label = UILabel()
        label.text = "회사"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var companyTextCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xAEAEAE)
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.text = "\(companyTextCount)/\(maxTextCount)"
        return label
    }()

    lazy var companyTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.addRightPadding()
        textField.placeholder = "회사명을 입력해주세요"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .mainBlack
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        textField.autocapitalizationType = .none
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        return textField
    }()
    
    lazy var subtitlePositionLabel: UILabel = {
        let label = UILabel()
        label.text = "직함"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var positionTextCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xAEAEAE)
        label.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        label.text = "\(positionTextCount)/\(maxTextCount)"
        return label
    }()
    
    lazy var positionTextField: UITextField = {
        let textField = UITextField()
        
        textField.addLeftPadding()
        textField.addRightPadding()
        textField.placeholder = "직함을 입력해주세요 (예: 백엔드 개발자)"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .mainBlack
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        textField.autocapitalizationType = .none
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        return textField
    }()
    
    lazy var subtitleWorkingDateLabel: UILabel = {
        let label = UILabel()
        label.text = "재직 기간"
        label.textColor = .mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 18)
        return label
    }()
    
    lazy var startDateTextField: UITextField = {
        let textField = UITextField()
        
        let calenderImg = UIImageView(image: UIImage(named: "calendarIcon"))
        textField.addSubview(calenderImg)
        calenderImg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(18)
        }
        
        textField.addLeftPadding()
        textField.placeholder = "시작년월"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .mainBlack
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        textField.autocapitalizationType = .none
        
        textField.inputView = startDatePickerView
        textField.inputAccessoryView = toolbar
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingDidEnd)
        
        return textField
    }()
    
    lazy var betweenTildLabel: UIButton = {
        let button = UIButton()
        button.setTitle("~", for: .normal)
        button.setTitleColor(.mainGray, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.isEnabled = false
        return button
    }()
    
    lazy var endDateTextField: UITextField = {
        let textField = UITextField()
        
        let calenderImg = UIImageView(image: UIImage(named: "calendarIcon"))
        textField.addSubview(calenderImg)
        calenderImg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(18)
        }
        
        textField.addLeftPadding()
        textField.placeholder = "종료년월"
        textField.setPlaceholderColor(.mainGray)
        textField.layer.cornerRadius = 12
        textField.textColor = .mainBlack
        textField.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        textField.autocapitalizationType = .none
        
        textField.inputView = endDatePickerView
        textField.inputAccessoryView = toolbar
        
        textField.layer.borderColor = UIColor.mainGray.cgColor
        textField.layer.borderWidth = 1
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingDidEnd)
        
        return textField
    }()
    
    lazy var checkIsWorkingButton: UIButton = {
        let button = UIButton()
        button.setTitle("재직 중", for: .normal)
        button.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square")?.withRenderingMode(.automatic), for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(allTextFieldFilledIn), for: .touchUpInside)
        return button
    }()
    
    lazy var subDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 경력이 없으신가요?"
        label.textColor = UIColor(hex: 0x8A8A8A)
        label.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        return label
    }()
    
    lazy var inputEducationButton: UIButton = {
        let button = UIButton()
        button.setTitle("교육 입력하기", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(inputEducationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.isEnabled = false
        button.backgroundColor = .mainGray
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configLayouts()
        configureGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCurrentYear()
        setKeyboardObserver()
        setObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setKeyboardObserverRemove()
    }
    
    // MARK: - Functions
    
    func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(pagingImage)
        contentView.addSubview(companyTextField)
        contentView.addSubview(positionTextField)
        contentView.addSubview(startDateTextField)
        contentView.addSubview(endDateTextField)
        contentView.addSubview(betweenTildLabel)
        contentView.addSubview(checkIsWorkingButton)
        contentView.addSubview(companyTextCountLabel)
        contentView.addSubview(positionTextCountLabel)
        
        view.addSubview(subDescriptionLabel)
        view.addSubview(inputEducationButton)
        view.addSubview(saveUserProfileButton)
        /* Labels */
        [titleLabel,descriptionLabel,subtitleCompanyLabel,subtitlePositionLabel,subtitleWorkingDateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configLayouts() {
        //scrollView
        scrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(saveUserProfileButton.snp.top)
        }
        
        //contentView
        contentView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        //pagingImage
        pagingImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(72)
            make.height.equalTo(12)
            make.top.equalToSuperview().inset(28)
        }
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(pagingImage.snp.left)
            make.top.equalTo(pagingImage.snp.bottom).offset(28)
        }
        
        // descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        
        // subtitleCompanyLabel
        subtitleCompanyLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
        }
        
        // companyTextCountLabel
        companyTextCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(subtitleCompanyLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
        }
        
        // companyTextField
        companyTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleCompanyLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitlePositionLabel
        subtitlePositionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(companyTextField.snp.bottom).offset(28)
        }
        
        // positionTextCountLabel
        positionTextCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(subtitlePositionLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
        }
        
        // positionTextField
        positionTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitlePositionLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // subtitleWorkingDateLabel
        subtitleWorkingDateLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(positionTextField.snp.bottom).offset(28)
        }
        
        // betweenTildLabel
        betweenTildLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(38)
            make.height.equalTo(48)
            make.top.equalTo(subtitleWorkingDateLabel.snp.bottom).offset(4)
        }
        
        // startDateTextField
        startDateTextField.snp.makeConstraints { make in
            make.centerY.equalTo(betweenTildLabel.snp.centerY)
            make.height.equalTo(48)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(betweenTildLabel.snp.left)
        }
        
        // endDateTextField
        endDateTextField.snp.makeConstraints { make in
            make.centerY.equalTo(betweenTildLabel.snp.centerY)
            make.height.equalTo(48)
            make.left.equalTo(betweenTildLabel.snp.right)
            make.right.equalToSuperview().inset(16)
        }
        
        // checkIsWorkingButton
        checkIsWorkingButton.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.bottom).offset(12)
            make.height.equalTo(23)
            make.left.equalTo(titleLabel.snp.left)
        }
        
        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(14)
            make.height.equalTo(48)
        }
        
        //subDescriptionLabel
        subDescriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(saveUserProfileButton.snp.left)
            make.bottom.equalTo(saveUserProfileButton.snp.top).offset(-8)
        }
        
        //inputEducationButton
        inputEducationButton.snp.makeConstraints { make in
            make.left.equalTo(subDescriptionLabel.snp.right).offset(8)
            make.centerY.equalTo(subDescriptionLabel.snp.centerY)
        }
    }
    
    func setCurrentYear() {
        let currentYearFormatter = DateFormatter()
        currentYearFormatter.dateFormat = "yyyy"
        currentYear = Int(currentYearFormatter.string(from: Date())) ?? 0
        
        let currentYearMonthFormatter = DateFormatter()
        currentYearMonthFormatter.dateFormat = "MM"
        currentYearMonth = Int(currentYearMonthFormatter.string(from: Date())) ?? 0
    }
    
    @objc
    private func nextButtonTapped(_ sender: UIButton) {
        let myCareerInfo = RegisterCareerInfo(memberIdx: 0, company: companyTextField.text!, position: positionTextField.text!, isWorking: String(isWorking), startDate: startDateTextField.text!, endDate: endDateTextField.text!)
        
        let nextVC = CompleteRegisterVC(myCareer: myCareerInfo, myEducation: nil)
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }

    @objc
    private func inputEducationButtonTapped(_ sender: UIButton) {
        let nextVC = InputEducationVC()
        nextVC.modalTransitionStyle = .crossDissolve // .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    @objc
    private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        checkButtonValid(sender)
    }
    
    private func checkButtonValid(_ sender: UIButton){
        switch sender.isSelected {
        case true:
            // cornerCase에서 토글시
            startDateTextField.layer.borderColor = UIColor.mainGray.cgColor
            endDateTextField.layer.borderColor = UIColor.mainGray.cgColor
            
            sender.setTitleColor(.mainBlack, for: .normal)
            endDateTextField.text = "현재"
            endYearValue = String(Int(yearArray[0])!+1)
            endMonthValue = monthArray[0]
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
            endDatePickerView.selectRow(0, inComponent: 0, animated: false)
            endDatePickerView.selectRow(0, inComponent: 1, animated: false)
            endYearValue = yearArray[0]
            endMonthValue = monthArray[0]
            endDateTextField.text = ""
        }
    }
    
    @objc
    func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainBlack.cgColor
        switch sender {
        case startDateTextField:
            let startValue = Int(startMonthValue)! + 12*Int(startYearValue)!
            let endValue = Int(endMonthValue)! + 12*Int(endYearValue)!
            if !(startValue > endValue
                && !(startValue == 0 || endValue == 0)) {
                startYearValue = yearArray[startDatePickerView.selectedRow(inComponent: 0)]
                startMonthValue = monthArray[startDatePickerView.selectedRow(inComponent: 1)]
                sender.text = "\(startYearValue)/\(startMonthValue)"
            } else {
                sender.layer.borderColor = UIColor.mainBlack.cgColor
                sender.layer.borderWidth = 1
            }
        case endDateTextField:
            if checkIsWorkingButton.isSelected {
                checkIsWorkingButton.isSelected = false
                checkButtonValid(checkIsWorkingButton)
            }
            let startValue = Int(startMonthValue)! + 12*Int(startYearValue)!
            let endValue = Int(endMonthValue)! + 12*Int(endYearValue)!
            if !(startValue > endValue
                 && !(startValue == 0 || endValue == 0)) {
                endYearValue = yearArray[endDatePickerView.selectedRow(inComponent: 0)]
                endMonthValue = monthArray[endDatePickerView.selectedRow(inComponent: 1)]
                sender.text = "\(endYearValue)/\(endMonthValue)"
            } else {
                sender.layer.borderColor = UIColor.mainBlack.cgColor
                sender.layer.borderWidth = 1
            }
        default:
            print(">>>Front: textFieldActivated")
        }
    }
    
    @objc
    func textFieldInactivated(_ sender: UITextField) {
        switch sender{
        case startDateTextField, endDateTextField:
            // 반드시 [start < end] 만족해야함
            let startValue = Int(startMonthValue)! + 12*Int(startYearValue)!
            let endValue = Int(endMonthValue)! + 12*Int(endYearValue)!
            
            // 불만족시
            if startValue > endValue
                && !(startValue == 0 || endValue == 0) {
                // shake 애니메이션 + borderColor: 0xFF0000
                startDateTextField.shake()
                endDateTextField.shake()
            } else {
                startDateTextField.layer.borderColor = UIColor.mainGray.cgColor
                endDateTextField.layer.borderColor = UIColor.mainGray.cgColor
            }
        default:
            sender.layer.borderColor = UIColor.mainGray.cgColor
            sender.layer.borderWidth = 1
        }
    }
    
    @objc
    func pickerExit() {
        if startDateTextField.isEditing {
            let yearRow = startDatePickerView.selectedRow(inComponent: 0)
            let monthRow = startDatePickerView.selectedRow(inComponent: 1)
            startDateTextField.text = "\(yearArray[yearRow])/\(monthArray[monthRow])"
            startYearValue = yearArray[yearRow]
            startMonthValue = monthArray[monthRow]
        }
        else if endDateTextField.isEditing {
            let yearRow = endDatePickerView.selectedRow(inComponent: 0)
            let monthRow = endDatePickerView.selectedRow(inComponent: 1)
            endDateTextField.text = "\(yearArray[yearRow])/\(monthArray[monthRow])"
            endYearValue = yearArray[yearRow]
            endMonthValue = monthArray[monthRow]
        }
        self.view.endEditing(true)
    }
    
    @objc
    func pickerCancel() {
        if startDateTextField.isEditing {
            startDatePickerView.selectRow(0, inComponent: 0, animated: false)
            startDatePickerView.selectRow(0, inComponent: 1, animated: false)
            startDateTextField.text = ""
            startYearValue =  "0"
            startMonthValue = "0"
        }
        else if endDateTextField.isEditing {
            endDatePickerView.selectRow(0, inComponent: 0, animated: false)
            endDatePickerView.selectRow(0, inComponent: 1, animated: false)
            endDateTextField.text = ""
            endYearValue =  "0"
            endMonthValue = "0"
        }
        self.view.endEditing(true)
    }
    
    @objc
    func allTextFieldFilledIn() {
        
        /* 모든 textField가 채워졌으면 프로필 저장 버튼 활성화 */
        if self.companyTextField.text?.count != 0,
           self.positionTextField.text?.count != 0,
           self.startDateTextField.text?.count == 7,
           (self.endDateTextField.text?.count == 7 || self.endDateTextField.text?.count == 2) {
            
            // 재직중 버튼 활성화시 -> 무조건 활성화
            if isWorking {
                UIView.animate(withDuration: 0.33) { [weak self] in
                    self?.saveUserProfileButton.backgroundColor = .mainBlue
                }
                saveUserProfileButton.isEnabled = true
            }
            // 재직중 버튼 비활성화시
            else {
                // 반드시 [start < end] 만족해야함
                let startValue = Int(startMonthValue)! + 12*Int(startYearValue)!
                let endValue = Int(endMonthValue)! + 12*Int(endYearValue)!
                
                // 불만족시
                if (startValue > endValue
                    && !(startValue == 0 || endValue == 0)) {
                    // shake 애니메이션 + borderColor: 0xFF0000
                    startDateTextField.shake()
                    endDateTextField.shake()
                    // 프로필 저장버튼 애니메이션
                    saveUserProfileButton.isEnabled = false
                    UIView.animate(withDuration: 0.33) { [weak self] in
                        self?.saveUserProfileButton.backgroundColor = .mainGray
                    }
                } else { // 만족시
                    // 프로필 저장버튼 애니메이션
                    UIView.animate(withDuration: 0.33) { [weak self] in
                        self?.saveUserProfileButton.backgroundColor = .mainBlue
                    }
                    saveUserProfileButton.isEnabled = true
                }
            }
        } else {
            saveUserProfileButton.isEnabled = false
            UIView.animate(withDuration: 0.33) { [weak self] in
                self?.saveUserProfileButton.backgroundColor = .mainGray
            }
        }
    }
    
    @objc
    private func textDidChange(_ sender: UITextField) {
        switch sender {
        case companyTextField:
            companyTextCount = companyTextField.text?.count ?? 0
            NotificationCenter.default.post(name: Notification.Name("textDidChange"), object: sender)
        case positionTextField:
            positionTextCount = positionTextField.text?.count ?? 0
            NotificationCenter.default.post(name: Notification.Name("textDidChange"), object: sender)
        default:
            print(">>>ERROR: typeText InputCareerVC")
        }
    }
}

extension InputCareerVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            if component == 0 {
                return yearArray.count
            } else {
                switch(startYearValue){
                case String(currentYear):
                    // currentYearMonth까지
                    return monthArray[0..<currentYearMonth].count
                default:
                    return monthArray.count
                }
                
            }
        } else if pickerView.tag == 1 {
            if component == 0 {
                return yearArray.count
            } else {
                switch(endYearValue){
                case String(currentYear):
                    // currentYearMonth까지
                    return monthArray[0..<currentYearMonth].count
                default:
                    return monthArray.count
                }
                
            }
        }
        print(">>>ERROR: pickerView numberOfRowsInComponent")
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            if component == 0 {
                switch(startYearValue){
                // 선택한 년도가 올해였을 때
                case String(currentYear):
                    startYearValue = yearArray[row]
                    startDateTextField.text = "\(startYearValue)/\(startMonthValue)"
                    pickerView.reloadAllComponents()
                // 선택한 년도가 올해가 아니었을 때
                default:
                    startYearValue = yearArray[row]
                    if startYearValue == String(currentYear){
                        pickerView.selectRow(0, inComponent: 1, animated: true)
                        startDateTextField.text = "\(startYearValue)/\(monthArray[0])"
                        startMonthValue = monthArray[0]
                    } else {
                        startDateTextField.text = "\(startYearValue)/\(startMonthValue)"
                    }
                    pickerView.reloadAllComponents()
                }
            } else {
                startMonthValue = monthArray[row]
                startDateTextField.text = "\(startYearValue)/\(startMonthValue)"
            }
        }
        else if pickerView.tag == 1 {
            if component == 0 {
                switch(endYearValue){
                // 선택한 년도가 올해였을 때
                case String(currentYear):
                    endYearValue = yearArray[row]
                    endDateTextField.text = "\(endYearValue)/\(endMonthValue)"
                    pickerView.reloadAllComponents()
                // 선택한 년도가 올해가 아니었을 때
                default:
                    endYearValue = yearArray[row]
                    if endYearValue == String(currentYear){
                        pickerView.selectRow(0, inComponent: 1, animated: true)
                        endDateTextField.text = "\(endYearValue)/\(monthArray[0])"
                        endMonthValue = monthArray[0]
                    } else {
                        endDateTextField.text = "\(endYearValue)/\(endMonthValue)"
                    }
                    pickerView.reloadAllComponents()
                }
            } else {
                endMonthValue = monthArray[row]
                endDateTextField.text = "\(endYearValue)/\(endMonthValue)"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return yearArray[row]
        } else {
            return monthArray[row]
        }
    }
}

extension InputCareerVC {
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewDidTap() {
        self.view.endEditing(true)
    }
}

extension InputCareerVC {
    func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(validTextCount(_:)), name: Notification.Name("textDidChange"), object: nil)
    }
    
    @objc private func validTextCount(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.count > maxTextCount {
                    // 22글자 넘어가면 자동으로 키보드 내려감
                    textField.resignFirstResponder()
                }
                // 초과되는 텍스트 제거
                if text.count >= maxTextCount {
                    let index = text.index(text.startIndex, offsetBy: maxTextCount)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
            }
        }
    }
}

extension InputCareerVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height -= view.safeAreaInsets.top * 1.5 // 이 부분 조절하면서 스크롤 올리는 정도 변경
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking
            
            // determine which UIView was selected and if it is covered by keyboard
            let activeField: UIView? = [companyTextField, positionTextField, startDateTextField, endDateTextField].first { $0.isFirstResponder }
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
