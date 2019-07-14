//
//  CustomerModel.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 13/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit

public struct CTACustomerModel : Codable {
    let name: String
    let lastname: String
    let age: Int
    let birthdate: String
}
