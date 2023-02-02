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


protocol EditProfileDataDelegate: AnyObject {
    func editData(image: String, nickname: String, organization: String, email: String, introduce: String)
}

class ProfileEditVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    weak var delegate: EditProfileDataDelegate?
    
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
    
    let imagePicker = UIImagePickerController()
    let profileImageView : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 50
        view.backgroundColor = .mainGray
        view.clipsToBounds = true
        
        return view
    }()
    let profilePlusImageView = UIImageView().then {
        $0.image = UIImage(named: "ProfilePlus")
        $0.layer.cornerRadius = 11
    }
    
    let nameLabel = UILabel().then {
        $0.text = "닉네임 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let nameTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.placeholder = "닉네임을 입럭해주세요 (최대 8글자)"
        $0.basicTextField()
        
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
    }
    
    let orgLabel = UILabel().then {
        $0.text = "소속 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let orgTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.placeholder = "소속을 입럭해주세요"
        $0.basicTextField()
        
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
    }
    
    let emailLabel = UILabel().then {
        $0.text = "이메일 *"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    let emailTextField = UITextField().then {
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14)
        $0.placeholder = "이메일을 입럭해주세요"
        $0.basicTextField()
        
        $0.addTarget(self, action: #selector(textFieldActivated), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(textFieldInactivated), for: .editingDidEnd)
    }
    
    let introduceLabel = UILabel().then {
        $0.text = "자기소개"
        $0.font = UIFont.NotoSansKR(type: .Bold, size: 16)
    }
    
    let textViewPlaceHolder = "100자 이내로 작성해주세요"
    lazy var introduceTextField = UITextView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainGray.cgColor // UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 12
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        $0.font = UIFont.NotoSansKR(type: .Regular, size: 14) // .systemFont(ofSize: 18)
        $0.text = textViewPlaceHolder
        $0.textColor = .mainGray
        $0.delegate = self // <-
    }
    
    let editDoneBtn = UIButton().then {
        $0.basicButton()
        $0.setTitle("완료하기", for: .normal)
    }
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureLayouts()
        tapGesture()
        
        // 엔터키 클릭시 키보드 내리기
        nameTextField.delegate = self
        orgTextField.delegate = self
        emailTextField.delegate = self
        introduceTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Functions
    func configureLayouts() {
        
        // addSubview
        [headerView, profileImageView,profilePlusImageView, nameLabel, nameTextField, orgLabel, orgTextField, emailLabel, emailTextField,introduceLabel, introduceTextField, editDoneBtn]
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
        
        // layer
        profileImageView.snp.makeConstraints { /// 프로필 이미지
            $0.width.height.equalTo(100)
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.equalTo(16)
        }
        profilePlusImageView.snp.makeConstraints { /// 플러스 버튼
            $0.trailing.equalTo(profileImageView).offset(-2)
            $0.bottom.equalTo(profileImageView).offset(-2)
            $0.height.equalTo(22)
        }
        
        /// 닉네임
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.equalTo(profileImageView)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(48)
        }
        
        /// 소속
        orgLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.leading.equalTo(nameLabel)
        }
        
        orgTextField.snp.makeConstraints {
            $0.top.equalTo(orgLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(nameTextField)
            $0.height.equalTo(nameTextField)
        }
        
        /// 이메일
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(orgTextField.snp.bottom).offset(16)
            $0.leading.equalTo(orgLabel)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(orgTextField)
            $0.height.equalTo(nameTextField)
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
            $0.leading.trailing.equalTo(nameTextField)
            $0.height.equalTo(100)
        }
        
        
        editDoneBtn.snp.makeConstraints {
            $0.bottom.equalTo(-48)
            $0.leading.trailing.equalTo(emailTextField)
        }
        editDoneBtn.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
    }
    
    // 클릭 이벤트
    func tapGesture() {
        // 갤러리 클릭
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageDidTap))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
        
//        // 키보드 처리 -> 텍스트필드 입력시 뷰 올리기
//        restoreFrameYValue = self.view.frame.origin.y
//
//        // UIResponder.keyboardWillShowNotification : 키보드가 해제되기 직전에 post 된다.
//        NotificationCenter.default.addObserver(self, selector: #selector(setKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        // UIResponder.keyboardWillHideNotificationdcdc : 키보드가 보여지기 직전에 post 된다.
//        NotificationCenter.default.addObserver(self, selector: #selector(setKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // SubTitle 별 처리
    private func contigureStarText() {
        // NSAttributedString 객체를 만들어서 프로퍼티에 대입
        let nameText = nameLabel.text ?? ""
        let attributedString1 = NSMutableAttributedString(string: nameText)
        // NSRange값을 이용해 대입 하기 전 특정 문자열에 color 속성값을 부여
        let range1 = (nameText as NSString).range(of: "*")
        // range값을 가지고 위에서 만든 attributedString객체에 color 속성값을 추가
        attributedString1.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: range1)
        // 기존 라벨에 attributedString 객체 속성 부여
        nameLabel.attributedText = attributedString1
        
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
    
    // 키보드 업
    @objc func setKeyboardShow(_ notification: Notification) {
        // 키보드가 내려왔을 때만 올리기
        if self.view.frame.origin.y == restoreFrameYValue {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y -= keyboardHeight
                print("show keyboard")
            }
        }
    }

    // 키보드 다운
    @objc private func setKeyboardHide(_ notification: Notification) {
        // 키보드가 올라갔을 때만 내리기
        if self.view.frame.origin.y != restoreFrameYValue {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y += keyboardHeight
                print("hide keyboard")
            }
        }
    }
    
    @objc func profileImageDidTap() {
        // 갤러리 권한 설정
        checkAlbumPermission()
        
        // 앨범 허용 상태 체크
        PHPhotoLibrary.requestAuthorization { (state) in
            print(state)
        }
        
        print("프로필 이미지 클릭")
        
    }
    
    // 완료하기 버튼 did tap
    @objc private func doneButtonDidTap() {
        print("완료하기 버튼 클릭")
        
        // 텍스트값 가져오기
        guard let editName = nameTextField.text else { return }
        guard let editOrg = orgTextField.text else { return }
        guard let editEmail = emailTextField.text else { return }
        guard let editIntroduce = introduceTextField.text else { return }
        
        // 임시
        let profileUrl = "ExProfileImage"
        let memberIdx: Int = 1
        
        // 변경된 이름값 담기
        self.delegate?.editData(image: profileUrl, nickname: editName, organization: editOrg, email: editEmail, introduce: editIntroduce)
        
        patchMyInfo(memberIdx: memberIdx, nickName: editName, belong: editOrg, profileEmail: editEmail, content: editIntroduce, profileUrl: profileUrl)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 유저 정보 수정
    func patchMyInfo(memberIdx: Int, nickName: String, belong: String, profileEmail: String, content: String, profileUrl: String) {
        
        // http 요청 주소 지정
        let url = "https://garamgaebi.shop/profile/edit/\(memberIdx)"
        
        // http 요청 헤더 지정
        let header : HTTPHeaders = [
            "Content-Type" : "application/json",
        ]
        let bodyData: Parameters = [
            "memberIdx": memberIdx,
            "nickName": nickName,
            "belong" : belong,
            "profileEmail" : profileEmail,
            "content": content,
            "profileUrl": profileUrl
        ]
//        print(nickName, profileEmail)
        
        // httpBody 에 parameters 추가
        AF.request(
            url,
            method: .post,
            parameters: bodyData,
            encoding: JSONEncoding.default,
            headers: header
        )
        .validate()
        .responseDecodable(of: ProfileEditResponse.self) { response in
            switch response.result {
            case .success(let response):
                if response.isSuccess {
                    print(response.message)
                } else {
                    print("실패(프로필수정): \(response.message)")
                }
            case .failure(let error):
                print("실패(AF-프로필수정: \(error.localizedDescription)")
            }
        }
    }
    
    // 뒤로가기 버튼 did tap
    @objc private func didTapBackBarButton() {
        print("뒤로가기 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    // 갤러리 권한 체크
    func checkAlbumPermission(){
        PHPhotoLibrary.requestAuthorization( { status in
            switch status{
            case .authorized:
                print("Album: 권한 허용")
                DispatchQueue.main.async {
                    // 이미지 피커 열기
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .photoLibrary
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            case .denied:
                print("Album: 권한 거부")
            case .restricted, .notDetermined:
                print("Album: 선택하지 않음")
            default:
                break
            }
        })
    }
    
}

extension ProfileEditVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.font = UIFont.NotoSansKR(type: .Regular, size: 14)
            textView.textColor = .systemGray5
            //updateCountLabel(characterCount: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 100 else { return false }
        //updateCountLabel(characterCount: characterCount)
        
        return true
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
extension ProfileEditVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: false, completion: {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            })
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
