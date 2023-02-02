//
//  ProfileInputEducationVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/16.
//

import UIKit

class ProfileInputEducationVC: UIViewController {

    // MARK: - Properties
    
    private let yearArray = (1901...2023).reversed().map { String($0) }
    private let monthArray = (1...12).map { String(format:"%02d", $0) }
    private var yearValue =  String()
    private var monthValue = String()
    
    
    // MARK: - Subviews
    
    // 네비게이션바
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "교육"
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
    
    // 데이트 피커
    private var toolbar: UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0, width:100, height:35))
        toolBar.tintColor = .mainBlack
        toolBar.backgroundColor = .mainLightGray
        
        let exitBtn = UIBarButtonItem()
        exitBtn.title = "확인"
        exitBtn.target = self
        exitBtn.action = #selector(pickerExit)
        exitBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.NotoSansKR(type: .Regular, size: 16)!], for: .normal)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexSpace,exitBtn], animated: true)
        return toolBar
    }
    
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
    
    // 내용
    lazy var subtitleInstitutionLabel: UILabel = {
        let label = UILabel()
        label.text = "교육 기관"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()
    
    lazy var institutionTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "교육기관을 입력해주세요"
        textField.basicTextField()
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        
        return textField
    }()

    lazy var subtitleMajorLabel : UILabel = {
        let label = UILabel()
        label.text = "전공/과정"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        
        return label
    }()

    lazy var majorTextField: UITextField = {
        let textField = UITextField()

        textField.placeholder = "전공/과정을 입력해주세요 (예: 웹 개발 과정)"
        textField.basicTextField()

        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)


        return textField
    }()

    lazy var subtitleLearningDateLabel: UILabel = {
        let label = UILabel()
        label.text = "교육 기간"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.NotoSansKR(type: .Bold, size: 16)
        return label
    }()

    lazy var startDateTextField: UITextField = {
        let textField = UITextField()

        let calenderImg = UIImageView(image: UIImage(named: "CalendarMonth"))
        textField.addSubview(calenderImg)
        calenderImg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(18)
        }
        
        textField.placeholder = "시작년월"
        textField.basicTextField()

        textField.inputView = startDatePickerView
        textField.inputAccessoryView = toolbar
        
        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)

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
        
        let calenderImg = UIImageView(image: UIImage(named: "CalendarMonth"))
        textField.addSubview(calenderImg)
        calenderImg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(18)
        }

        textField.placeholder = "종료년월"
        textField.basicTextField()
        
        textField.inputView = endDatePickerView
        textField.inputAccessoryView = toolbar

        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)

        return textField
    }()
    
    lazy var checkIsLearningButton: UIButton = {
        let button = UIButton()
        button.setTitle("교육 중", for: .normal)
        button.setImage(UIImage(systemName: "square")?.withTintColor(UIColor(hex: 0xAEAEAE), renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square")?.withRenderingMode(.automatic), for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -7)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        button.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansKR(type: .Regular, size: 16)

        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        return button
    }()

    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        button.basicButton()
        button.setTitle("저장하기", for: .normal)
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()


    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        addSubViews()
        configLayouts()

    }


    // MARK: - Functions

    func addSubViews() {
        
        /* HeaderView */
        view.addSubview(headerView)
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
        /* Buttons */
        view.addSubview(institutionTextField)
        view.addSubview(majorTextField)
        view.addSubview(startDateTextField)
        view.addSubview(endDateTextField)
        view.addSubview(betweenTildLabel)
        view.addSubview(checkIsLearningButton)
        view.addSubview(saveUserProfileButton)


        /* Labels */
        [subtitleInstitutionLabel,subtitleMajorLabel,subtitleLearningDateLabel].forEach {
            view.addSubview($0)
        }
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
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // backButton
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // subtitleCompanyLabel
        subtitleInstitutionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(headerView.snp.bottom).offset(16)
        }

        // companyTextField
        institutionTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleInstitutionLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(16)
        }

        // subtitlePositionLabel
        subtitleMajorLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
            make.top.equalTo(institutionTextField.snp.bottom).offset(28)
        }

        // positionTextField
        majorTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleMajorLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
            make.left.right.equalTo(institutionTextField)
        }

        // subtitleWorkingDateLabel
        subtitleLearningDateLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
            make.top.equalTo(majorTextField.snp.bottom).offset(28)
        }

        // betweenTildLabel
        betweenTildLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(38)
            make.height.equalTo(48)
            make.top.equalTo(subtitleLearningDateLabel.snp.bottom).offset(4)
        }

        // startDateTextField
        startDateTextField.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.top)
            make.height.equalTo(48)
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
            make.right.equalTo(betweenTildLabel.snp.left)
        }

        // endDateTextField
        endDateTextField.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.top)
            make.height.equalTo(48)
            make.left.equalTo(betweenTildLabel.snp.right)
            make.right.equalToSuperview().inset(16)
        }

        //checkIsWorkingButton
        checkIsLearningButton.snp.makeConstraints { make in
            make.top.equalTo(betweenTildLabel.snp.bottom).offset(12)
            make.height.equalTo(23)
            make.left.equalTo(subtitleInstitutionLabel.snp.left)
        }

        // saveUserProfileButton
        saveUserProfileButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
        }
    }

    @objc private func saveButtonDidTap(_ sender: UIButton) {
//        print("저장하기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.isSelected {
        case true:
            sender.setTitleColor(UIColor.mainBlack, for: .normal)
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
        }
    }

    @objc func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainBlack.cgColor
        sender.layer.borderWidth = 1
    }

    @objc func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
//        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    // 데이트 피커 나가기
    @objc func pickerExit() {
        self.view.endEditing(true)
    }

}

extension ProfileInputEducationVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearArray.count
        } else {
            return monthArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            if component == 0 {
                yearValue = yearArray[row]
                startDateTextField.text = "\(yearValue)/\(monthValue)"
            } else {
                monthValue = monthArray[row]
                startDateTextField.text = "\(yearValue)/\(monthValue)"
            }
        }
        else if pickerView.tag == 1 {
            if component == 0 {
                yearValue = yearArray[row]
                endDateTextField.text = "\(yearValue)/\(monthValue)"
            } else {
                monthValue = monthArray[row]
                endDateTextField.text = "\(yearValue)/\(monthValue)"
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
