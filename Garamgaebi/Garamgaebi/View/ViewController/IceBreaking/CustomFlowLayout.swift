//
//  CustomFlowLayout.swift
//  Garamgaebi
//
//  Created by 정현우 on 2023/01/15.
//

import Foundation
import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
	
	public var sideItemScale: CGFloat = 0.85
	public var sideItemAlpha: CGFloat = 0.5
	public var spacing: CGFloat = 0  // setupLayout에서 설정

	public var isPagingEnabled: Bool = true
	
	private var isSetup: Bool = false
	
	// prepare은 처음 호출될 때, 사용자가 스크롤 할 때마다 호출 되는데,
	// setupLayout은 init처음 한번만 필요하므로 isSetUp이라는 flag를 둠
	override public func prepare() {
		super.prepare()
		if isSetup == false {
			setupLayout()
			isSetup = true
		}
	}
	
	private func setupLayout() {
		guard let collectionView = self.collectionView else {return}
				
		let collectionViewSize = collectionView.bounds.size
		
		// MARK: cell itemSize, spacing 커스텀
//		self.itemSize.width = collectionViewSize.width - (42*2)  // 42는 collectionview와 cell이 떨어진 거리
		self.itemSize.width = collectionViewSize.width - (30*2)
//		self.itemSize.height = self.itemSize.width * 1.5
		self.itemSize.height = self.itemSize.width * 0.85
		spacing = (-(self.itemSize.width) + 64)  // 64는 현재 셀과 다음 셀이 떨어진 거리(-로)
		
		let xInset = (collectionViewSize.width - self.itemSize.width) / 2
//		let yInset = (collectionViewSize.height - self.itemSize.height) / 2
		
		// 처음 시작할때, 마지막일때 가운데 위치하게 inset을 줌
		self.sectionInset = UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset)
		
		let itemWidth = self.itemSize.width
		
		let scaledItemOffset =  (itemWidth - itemWidth*self.sideItemScale) / 2
		self.minimumLineSpacing = spacing - scaledItemOffset

		self.scrollDirection = .horizontal
	}
	// 스크롤 시 레이아웃 업데이트 가능하게
	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
	// 모든 셀에 대한 레이아웃 속성의 리스트를 return
	// 아래의 transformLayoutAttributes함수로 맵핑하여 레이아웃이 적용된 상태로 return
	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let superAttributes = super.layoutAttributesForElements(in: rect),
			let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
			else { return nil }
		
		return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
	}
	
	// 각 셀의 레이아웃 속성 변화 함수
	private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		
		guard let collectionView = self.collectionView else {return attributes}
		
		// 컬렉션 뷰의 중앙값
		let collectionCenter = collectionView.frame.size.width / 2
		// 스크롤 시 x축에서 이동한 거리
		let contentOffset = collectionView.contentOffset.x
		// 각 셀들의 중앙 값
		let center = attributes.center.x - contentOffset
		
		// 한 셀의 중앙값과 다른 셀의 중앙 값 사이의 거리
		let maxDistance = self.itemSize.width + self.minimumLineSpacing
		// 중앙에서 스크롤한 거리 (0...maxDistnace)
		let distance = min(abs(collectionCenter - center), maxDistance)
		
		// 비율 범위는 0...1
		let ratio = (maxDistance - distance)/maxDistance
		
		// ratio가 1이면 distance가 0(중앙지점) -> 알파와 스케일은 1(원값)
		// ratio가 0이면 distance가 1(최대로 스크롤) -> 알파와 스케일은 설정한 값
		let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
		let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
		
		attributes.alpha = alpha
		
		let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
		let dist = attributes.frame.midX - visibleRect.midX
		
		// cell의 xy 스케일 변경
		var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
		// spacing이 음수여서 셀이 겹칠때 다른 셀들을 뒤로
		// CATransform3DTranslate(CATransform3D, tx, ty, tz)
		transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))
		attributes.transform3D = transform
		
		return attributes
	}
}
