//
//  CTACustomerListDelegateAndDataSource.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 14/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit

public class CTACustomerListDelegateAndDataSource: NSObject {
    static let sections = 1
    static let collectionCellHeight = 50
    
    public var customerList: [CTACustomerModel]?
}

// MARK: UICollectionViewDataSource

extension CTACustomerListDelegateAndDataSource: UICollectionViewDataSource {
    public func numberOfSections(in _: UICollectionView) -> Int {
        return CTACustomerListDelegateAndDataSource.sections
    }
    
    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customerList?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CTACustomerCollectionViewCell.cellId, for: indexPath) as? CTACustomerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let customer: CTACustomerModel = customerList?[indexPath.row] {
            cell.fill(customer)
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CTACustomerListDelegateAndDataSource: UICollectionViewDelegateFlowLayout {
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if ((collectionViewLayout as? UICollectionViewFlowLayout) == nil) {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.frame.width, height: CGFloat(CTACustomerListDelegateAndDataSource.collectionCellHeight))
    }
}
