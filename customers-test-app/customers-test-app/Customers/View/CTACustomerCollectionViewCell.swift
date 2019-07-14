//
//  CTACustomerCollectionViewCell.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 14/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit

class CTACustomerCollectionViewCell: UICollectionViewCell {

    static let cellId = "customerListCellId"
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.5)
    }
    
    public func fill(_ customer: CTACustomerModel?) {
        let lastname = customer?.lastname ?? EMPTY_STRING
        let name = customer?.name ?? EMPTY_STRING
        
        label.text = String(format: "%@ %@", lastname, name)  
    }

}
