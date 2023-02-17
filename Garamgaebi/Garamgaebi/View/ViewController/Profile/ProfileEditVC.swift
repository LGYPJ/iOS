//
//  ProfileEditVC.swift
//  Garamgaebi
//
//  Created by 김나현 on 2023/01/10.
//

import UIKit

import SnapKit
import Photos
import Alamofire
import PhotosUI


class ProfileEditVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var memberIdx: Int = 0
    var token = UserDefaults.standard.string(forKey: "BearerToken")
    
    private var scrollOffset : CGFloat = 0
    private var distance : CGFloat = 0
    
    // 유효성 검사
    var nickName = String()
    var isValidNickName = false {
        didSet {
            self.validNickname()
        }
    }
    var email = String()
    var isValidEmail = false {
        didSet {
            self.validEmail()
        }
    }
    
    // 뷰의 초기 y 값을 저장해서 뷰가 올라갔는지 내려왔는지에 대한 분기처리시 사용
    private var restoreFrameYValue = 0.0
    
    // MARK: - Subviews
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 71))
        view.backgroundColor = .systemBackground
        view.layer.addBorder([.bottom], color: .mainGray, width: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 편집"
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
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let imagePicker = UIImagePickerController()
    let profileImageView : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 50
        view.backgroundColor = .mainGray
        
        // 이미지 centerCrop
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "DefaultProfileImage")
        
        return view
    }()
    let profilePlusImageView = UIImageView().then {
        $0.image = UIImage(named: "ProfilePlus")
        $0.layer.cornerRadius = 11
    }
    
    let nickNameLabel = UILabel().then {
        $0.text = "닉네임 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    lazy var nickNameTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.placeholder = "8자 이내로 입력해주세요 (특수문자 불가)"
        $0.basicTextField()
        
        $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        $0.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
    }
    lazy var nickNameAlertLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 10)
        $0.text = "8자이내, 한/영문, 숫자만 사용 가능합니다"
        $0.textColor = .red
        $0.alpha = 0
    }
    
    let orgLabel = UILabel().then {
        $0.text = "한 줄 소개 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    lazy var orgTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.placeholder = "18자 이내로 입력해주세요 (예: 프리랜서 백엔드 개발자)"
        $0.basicTextField()
        
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        $0.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
    }
    
    let emailLabel = UILabel().then {
        $0.text = "이메일 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    lazy var emailTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.placeholder = "이메일 주소를 입력해주세요"
        $0.basicTextField()
        
        $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
        $0.addTarget(self, action: #selector(allTextFieldFilledIn), for: .editingChanged)
    }
    lazy var emailAlertLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 10)
        $0.text = "이메일 형식이 올바르지 않습니다"
        $0.textColor = .red
        $0.alpha = 0
    }
    
    let introduceLabel = UILabel().then {
        $0.text = "자기소개"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    
    let textViewPlaceHolder = "100자 이내로 작성해주세요"
    lazy var introduceTextField = UITextView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor
        $0.layer.cornerRadius = 12
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.text = textViewPlaceHolder
        $0.textColor = .mainGray
        $0.delegate = self // <-
    }
    lazy var introduceLengthLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 12)
        $0.textColor = UIColor(hex: 0xAEAEAE)
        let count = introduceTextField.text.count
        $0.text = "\(count)/100"
    }
    
    lazy var editDoneBtn = UIButton().then {
        $0.basicButton()
        $0.setTitle("저장하기", for: .normal)
        
        $0.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
    }
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureLayouts()
        tapGesture()
        configureGestureRecognizer()
        
        // 엔터키 클릭시 키보드 내리기
        nickNameTextField.delegate = self
        orgTextField.delegate = self
        emailTextField.delegate = self
        introduceTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: orgTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        setKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setKeyboardObserverRemove()
    }
    
    // MARK: - Functions
    func configureLayouts() {
        
        // addSubview
        view.addSubview(headerView)
        [titleLabel, backButton]
            .forEach {headerView.addSubview($0)}
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        [profileImageView,profilePlusImageView, nickNameLabel, nickNameTextField, orgLabel, orgTextField, emailLabel, emailTextField,introduceLabel, introduceTextField, editDoneBtn]
            .forEach {contentView.addSubview($0)}
        
        [nickNameAlertLabel, emailAlertLabel].forEach {contentView.addSubview($0)}
        
        contentView.addSubview(introduceLengthLabel)
        
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
            $0.bottom.equalToSuperview()
        }
        
        // contentView
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        // layer
        profileImageView.snp.makeConstraints { /// 프로필 이미지
            $0.width.height.equalTo(100)
            $0.top.equalTo(scrollView).offset(16)
            $0.leading.equalTo(16)
        }
        profilePlusImageView.snp.makeConstraints { /// 플러스 버튼
            $0.trailing.equalTo(profileImageView).offset(-2)
            $0.bottom.equalTo(profileImageView).offset(-2)
            $0.height.equalTo(22)
        }
        
        /// 닉네임
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.equalTo(profileImageView)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(48)
        }
        nickNameAlertLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(nickNameTextField)
        }
        
        /// 소속
        orgLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(16)
            $0.leading.equalTo(nickNameLabel)
        }
        orgTextField.snp.makeConstraints {
            $0.top.equalTo(orgLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(nickNameTextField)
            $0.height.equalTo(nickNameTextField)
        }
        
        /// 이메일
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(orgTextField.snp.bottom).offset(16)
            $0.leading.equalTo(orgLabel)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(orgTextField)
            $0.height.equalTo(nickNameTextField)
        }
        emailAlertLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(emailTextField)
        }
        
        /// 별 처리
        contigureStarText()
        
        /// 자기소개
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.leading.equalTo(emailLabel)
        }
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(nickNameTextField)
            $0.height.equalTo(100)
        }
        introduceLengthLabel.snp.makeConstraints { /// 글자수 계산
            $0.trailing.bottom.equalTo(introduceTextField).inset(12)
        }
        
        // 저장 버튼
        editDoneBtn.snp.makeConstraints {
            $0.top.equalTo(introduceTextField.snp.bottom).offset(54)
            $0.bottom.equalTo(contentView).inset(16)
            $0.leading.trailing.equalTo(emailTextField)
        }
    }
    
    // 클릭 이벤트
    func tapGesture() {
        // 갤러리 클릭
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageDidTap))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    // SubTitle 별 처리
    private func contigureStarText() {
        // NSAttributedString 객체를 만들어서 프로퍼티에 대입
        let nameText = nickNameLabel.text ?? ""
        let attributedString1 = NSMutableAttributedString(string: nameText)
        // NSRange값을 이용해 대입 하기 전 특정 문자열에 color 속성값을 부여
        let range1 = (nameText as NSString).range(of: "*")
        // range값을 가지고 위에서 만든 attributedString객체에 color 속성값을 추가
        attributedString1.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: range1)
        // 기존 라벨에 attributedString 객체 속성 부여
        nickNameLabel.attributedText = attributedString1
        
        let orgText = orgLabel.text ?? ""
        let attributedString2 = NSMutableAttributedString(string: orgText)
        let range2 = (orgText as NSString).range(of: "*")
        attributedString2.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: range2)
        orgLabel.attributedText = attributedString2
        
        let emailText = emailLabel.text ?? ""
        let attributedString3 = NSMutableAttributedString(string: emailText)
        let range3 = (emailText as NSString).range(of: "*")
        attributedString3.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: range3)
        emailLabel.attributedText = attributedString3
    }
    
    @objc func textFieldActivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainBlack.cgColor
    }
    
    @objc func textFieldInactivated(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.mainGray.cgColor
    }
    
    @objc func profileImageDidTap() {
		var configuration = PHPickerConfiguration()
		// 선택할 수 있는 사진 개수
		configuration.selectionLimit = 1
		// 사진만 나오게 필터링
		configuration.filter = .images
		
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		
		self.present(picker, animated: true, completion: nil)
    }
    
    // 완료하기 버튼 did tap
    @objc private func doneButtonDidTap() {
        
        guard let editName = nickNameTextField.text else { return }
        guard let editOrg = orgTextField.text else { return }
        guard let editEmail = emailTextField.text else { return }
        guard let editIntroduce = introduceTextField.text else { return }
        guard let profileImage = profileImageView.image else { return }
        
        postMyInfo(memberIdx: memberIdx, nickName: editName, belong: editOrg, profileEmail: editEmail, content: editIntroduce, profileImage: profileImage) { result in
            if result {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - [POST] 유저 정보 수정
    func postMyInfo(memberIdx: Int, nickName: String, belong: String, profileEmail: String, content: String, profileImage: UIImage?, completion: @escaping ((Bool) -> Void)) {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/edit"
        
        // http 요청 헤더 지정
        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        let parameters: [String : Any] = [
            "memberIdx": String(memberIdx),
            "nickname": nickName,
            "belong" : belong,
            "profileEmail" : profileEmail,
            "content": content
        ]

        print(parameters)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters { // 요청 바디에 있는 key, value 값을 for문을 통해 각각 multipartFormData 에 추가해서 전송
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "application/json")
            }
            if let imageData = profileImage?.pngData() {
//                print("이미지 있음")
                multipartFormData.append(imageData, withName: "image", fileName: "\(imageData).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: header)
        .validate()
        .responseDecodable(of: ProfileEditResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    print("성공(프로필수정): \(response.message)")
                } else {
                    print("실패(프로필수정): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-프로필수정): \(error.localizedDescription)")
            }
        }
    }
    
    @objc func allTextFieldFilledIn() {
        
        /* 모든 textField가 채워졌으면 프로필 저장 버튼 활성화 */
        if self.isValidNickName,
           self.isValidEmail {
            buttonActivated()
        } else { // 프로필 저장버튼 비활성화
            buttonInactivated()
        }
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        switch sender {
        case nickNameTextField:
            self.isValidNickName = text.isValidNickName()
            self.nickName = text
        case emailTextField:
            self.isValidEmail = text.isValidEmail()
            self.email = text
        
        default:
            fatalError("Missing TextField...")
        }

    }

    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func buttonActivated() {
        editDoneBtn.isEnabled = true
        UIView.animate(withDuration: 0.33) { [weak self] in
            self?.editDoneBtn.backgroundColor = .mainBlue
        }
    }
    private func buttonInactivated() {
        editDoneBtn.isEnabled = false
        UIView.animate(withDuration: 0.33) { [weak self] in
            self?.editDoneBtn.backgroundColor = .mainGray
        }
    }
    
    // MARK: - validateUserInfo()
    private func validateUserInfo() {
        if isValidNickName &&  isValidEmail {
            buttonActivated()
        }
    }
    private func validNickname() {
        if isValidNickName {
            hideAlert(textField: self.nickNameTextField, alertLabel: self.nickNameAlertLabel)
        } else {
            showAlert(textField: self.nickNameTextField, alertLabel: self.nickNameAlertLabel, status: self.isValidNickName)
        }
    }
    
    private func validEmail() {
        if isValidEmail {
            hideAlert(textField: self.emailTextField, alertLabel: self.emailAlertLabel)
        } else {
            showAlert(textField: self.emailTextField, alertLabel: self.emailAlertLabel, status: self.isValidEmail)
        }
    }
    
    private func showAlert(textField: UITextField, alertLabel: UILabel, status: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.red.cgColor
            alertLabel.alpha = 1

        }
    }
    
    private func hideAlert(textField: UITextField, alertLabel: UILabel) {
        
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.mainBlack.cgColor
            alertLabel.alpha = 0
        }
    }
    
    @objc private func textDidChange(_ notification: Notification) {
            if let textField = notification.object as? UITextField {
                let maxLength = 18
                if let text = textField.text {
                    
                    if text.count > maxLength {
                        // 18글자 넘어가면 자동으로 키보드 내려감
                        textField.resignFirstResponder()
                    }
                    
                    // 초과되는 텍스트 제거
                    if text.count >= maxLength {
                        let index = text.index(text.startIndex, offsetBy: maxLength)
                        let newString = text[text.startIndex..<index]
                        textField.text = String(newString)
                    }
                }
            }
        }
    
//    // 갤러리 권한 체크
//    func checkAlbumPermission(){
//        PHPhotoLibrary.requestAuthorization( { status in
//            switch status{
//            case .authorized:
//                print("Album: 권한 허용")
//                DispatchQueue.main.async {
//                    // 이미지 피커 열기
//                    self.imagePicker.delegate = self
//                    self.imagePicker.sourceType = .photoLibrary
//                    self.imagePicker.modalPresentationStyle = .fullScreen
//
//                    self.present(self.imagePicker, animated: true, completion: nil)
//                }
//            case .denied:
//                print("Album: 권한 거부")
//            case .restricted, .notDetermined:
//                print("Album: 선택하지 않음")
//            default:
//                break
//            }
//        })
//    }
    
}

extension ProfileEditVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .mainBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.font = UIFont.NotoSansKR(type: .Regular, size: 14)
            textView.textColor = .mainGray
            //updateCountLabel(characterCount: 0)
        }
    }
    
    // TextView 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLenght = str.count + text.count - range.length

        introduceLengthLabel.text = "\(str.count)/100"
        return newLenght <= 100
    }
    
    // 키보드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // TextField 비활성화
        
        return true
    }
    
}

// MARK: - Extension
extension ProfileEditVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    // image 다루기
                    self.profileImageView.image = image as? UIImage
                }
            }
        }
    }
}

extension ProfileEditVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
//        let imageData = selectedImage.jpegData(compressionQuality: 0.5)
        self.dismiss(animated: false) {
            DispatchQueue.main.async {
                self.profileImageView.image = selectedImage
            }
        }
    }

    func PhotoAuth() -> Bool {
        // 포토 라이브러리 접근 권한
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        var isAuth = false
        
        switch authorizationStatus {
        case .authorized: return true // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
        case .denied: break // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
        case .limited: break // ?
        case .notDetermined: // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
            PHPhotoLibrary.requestAuthorization { (state) in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted: break // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
        default: break
        }
        
        return false;
    }

}


extension UILabel {
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}

extension ProfileEditVC {
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
extension ProfileEditVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var safeArea = self.view.frame
            safeArea.size.height -= view.safeAreaInsets.top * 1.5 // 이 부분 조절하면서 스크롤 올리는 정도 변경
            safeArea.size.height -= headerView.frame.height // scrollView 말고 view에 headerView가 있기때문에 제외
            safeArea.size.height += scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking
            // determine which UIView was selected and if it is covered by keyboard
            
            let activeField: UIView? = [nickNameTextField, orgTextField, emailTextField, introduceTextField].first { $0.isFirstResponder }
            if let activeField = activeField {
                if safeArea.contains(CGPoint(x: 0, y: activeField.frame.maxY)) {
                    //print("No need to Scroll")
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
