//
//  ProfileInputEducationVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/16.
//

import UIKit

import SnapKit
import Alamofire

class ProfileInputEducationVC: UIViewController {

    // MARK: - Properties
    lazy var token = UserDefaults.standard.string(forKey: "BearerToken")
    lazy var memberIdx: Int = 0
    
    var currentYear: Int = 0 {
        didSet {
            yearArray = (1950...currentYear).reversed().map { String($0)}
        }
    }
    var currentYearMonth: Int = 0
    var yearArray: [String] = []
    
    private var monthArray = (1...12).map { String(format:"%02d", $0) }
    private var startYearValue = String()
    private var startMonthValue =  String()
    private var endYearValue = String()
    private var endMonthValue = String()
    private var isLearning: Bool = false
    
    
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
        label.text = "교육 추가하기"
        label.textColor = UIColor.mainBlack
        label.font = UIFont.NotoSansKR(type: .Bold, size: 20)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackward"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.tintColor = UIColor.mainBlack
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
        
        let cancelBtn = UIBarButtonItem()
        cancelBtn.title = "취소"
        cancelBtn.target = self
        cancelBtn.action = #selector(pickerCancel)
        cancelBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.NotoSansKR(type: .Regular, size: 16)!, NSAttributedString.Key.foregroundColor: UIColor(hex: 0xFF0000)], for: .normal)
        
        toolBar.setItems([cancelBtn, flexSpace, exitBtn], animated: true)
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
        
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
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

        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
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
        
        textField.dateTextField()
        textField.placeholder = "시작년월"

        textField.inputView = startDatePickerView
        textField.inputAccessoryView = toolbar
        
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
        
        textField.dateTextField()
        textField.placeholder = "종료년월"
        
        textField.inputView = endDatePickerView
        textField.inputAccessoryView = toolbar

        textField.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingDidEnd)

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
        button.addTarget(self, action: #selector(allTextFieldFilledIn), for: .touchUpInside)
        return button
    }()

    lazy var saveUserProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.basicButton()
        button.backgroundColor = .mainGray
        button.isEnabled = false
        button.clipsToBounds = true
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
        configureGestureRecognizer()

//        print(token) // 토큰 확인
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCurrentYear()
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
        // 값 저장
        guard let institution = institutionTextField.text else { return }
        guard let major = majorTextField.text else { return }
        //TODO: 서버에서 date 어떻게 받을지 모르겠음
        guard let startDate = startDateTextField.text else { return }
        guard let endDate = endDateTextField.text else { return }
        //TODO: 토글 체크상태에 따라서 처리. 근데 이거 왜 String임? -> 이거 True로 하면 endDate에 null이 온다
        let isLearning = "FALSE"
        
        // 서버 연동
        postEducation(memberIdx: memberIdx, institution: institution, major: major, isLearning: isLearning, startDate: startDate, endDate: endDate) { result in
            if result {
                // 서버 통신 후 profileVC reload 요청 notification 예시
                // NotificationCenter.default.post(name: Notification.Name("profileVCRefresh"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
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
    private func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.isSelected {
        case true:
            // cornerCase에서 토글시
            startDateTextField.layer.borderColor = UIColor.mainGray.cgColor
            endDateTextField.layer.borderColor = UIColor.mainGray.cgColor
            
            sender.setTitleColor(.mainBlack, for: .normal)
            endDateTextField.isEnabled = false
            endDateTextField.text = "현재"
            endYearValue = String(Int(yearArray[0])!+1)
            endMonthValue = monthArray[0]
        case false:
            sender.setTitleColor(UIColor(hex: 0x8A8A8A), for: .normal)
            endDateTextField.isEnabled = true
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
        sender.layer.borderWidth = 1
        if sender == startDateTextField || sender == endDateTextField {
            // pickerView 초기화
            switch(sender){
            case startDateTextField:
                endDateTextField.layer.borderColor = UIColor.mainGray.cgColor
                startYearValue = yearArray[startDatePickerView.selectedRow(inComponent: 0)]
                startMonthValue = monthArray[startDatePickerView.selectedRow(inComponent: 1)]
                sender.text = "\(startYearValue)/\(startMonthValue)"
            case endDateTextField:
                startDateTextField.layer.borderColor = UIColor.mainGray.cgColor
                endYearValue = yearArray[endDatePickerView.selectedRow(inComponent: 0)]
                endMonthValue = monthArray[endDatePickerView.selectedRow(inComponent: 1)]
                sender.text = "\(endYearValue)/\(endMonthValue)"
            default:
                print(">>>ERROR: InputCareerVC - pickerView error")
            }
        }
    }
    
    @objc
    func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
        sender.layer.borderWidth = 1
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
        }
        else if endDateTextField.isEditing {
            endDatePickerView.selectRow(0, inComponent: 0, animated: false)
            endDatePickerView.selectRow(0, inComponent: 1, animated: false)
            endDateTextField.text = ""
        }
        self.view.endEditing(true)
    }
    
    @objc
    func allTextFieldFilledIn() {
        
        /* 모든 textField가 채워졌으면 프로필 저장 버튼 활성화 */
        if self.institutionTextField.text?.count != 0,
           self.majorTextField.text?.count != 0,
           self.startDateTextField.text?.count != 0,
           self.endDateTextField.text?.count != 0 {
            
            // 교육중 버튼 활성화시 -> 무조건 활성화
            if isLearning {
                UIView.animate(withDuration: 0.33) { [weak self] in
                    self?.saveUserProfileButton.backgroundColor = .mainBlue
                }
                saveUserProfileButton.isEnabled = true
            }
            // 교육중 버튼 비활성화시
            else {
                // 반드시 [start < end] 만족해야함
                let startValue = Int(startMonthValue)! + 12*Int(startYearValue)!
                let endValue = Int(endMonthValue)! + 12*Int(endYearValue)!
                
                // 불만족시
                if startValue > endValue {
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
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
//        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - [POST] 교육 추가
    func postEducation(memberIdx: Int, institution: String, major: String, isLearning: String, startDate: String, endDate: String, completion: @escaping ((Bool) -> Void)) {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/education"
        
        // http 요청 헤더 지정
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token ?? "")"
        ]
        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "institution": institution,
            "major": major,
            "isLearning": isLearning,
            "startDate": startDate,
            "endDate": endDate
        ]
        
        // httpBody 에 parameters 추가
        AF.request(
            url,
            method: .post,
            parameters: bodyData,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: ProfilePostResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    print("성공(Education추가): \(response.message)")
                    completion(response.result)
                } else {
                    print("실패(Education추가): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-Education추가): \(error.localizedDescription)")
            }
        }
    }

}

extension ProfileInputEducationVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
extension ProfileInputEducationVC {
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
