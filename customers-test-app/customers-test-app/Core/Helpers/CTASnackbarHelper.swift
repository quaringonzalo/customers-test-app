//
//  CTASnackbarHelper.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 13/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

public class CTASnackbarHelper {

    public static func showMessage(message: String) {
        let message = MDCSnackbarMessage(text: message)
        MDCSnackbarManager.show(message)
    }
    
}
