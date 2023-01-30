//
//  OnboardingCollectionViewCell.swift
//  Garamgaebi
//
//  Created by 홍승완 on 2023/01/10.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let cellId = String(describing: OnboardingCollectionViewCell.self)
    
    lazy var onboardingImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Onboarding1"))
        img.contentMode = .scaleAspectFill
//        img.backgroundColor = .mainGray
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가천대생 개발자들의\n모임 참여를 보다 간편하게"
        label.font = UIFont.NotoSansKR(type: .Bold, size: 22)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임의 시작에서 끝까지 개가천선으로 확인해요"
        label.font = UIFont.NotoSansKR(type: .Regular, size: 18)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubViews()
        setLayouts()
    }
    
    override func prepareForReuse() {
        // 해당 처리를 해준 이유가 계속 로티 이미지가 겹쳐서 생성되는 문제가 있었기 때문
//        lottieName = ""
//        animationView.stop()
    }
    // MARK: - Config Methods
    func addSubViews(){
        contentView.addSubview(onboardingImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
    }
    func setLayouts(){
        onboardingImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview().offset(-15) // 이미지 중앙정렬 맞으면 고쳐야함
        }
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subTitleLabel.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
    }
    // MARK: - Custom Functions
//    func setOnboardingSlides(_ slides: OnboardingDataModel) {
//        onboardingTitleLabel.text = slides.title
//        onboardingDescriptionLabel.text = slides.subTitle
//    }

}
