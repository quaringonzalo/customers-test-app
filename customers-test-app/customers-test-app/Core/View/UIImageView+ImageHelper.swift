//
//  UIImageView+ImageHelper.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 13/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func setImage(imageUrl: String){
        
        if let url = URL(string: imageUrl){
            
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                guard error == nil else {
                    print("error load image")
                    return
                }
                
                DispatchQueue.main.async() {
                    self?.image = UIImage(data: data!)
                }                
            }).resume()
        }
    }
    
    public func setCornerRadiusAndBorder(){
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
    }
}
