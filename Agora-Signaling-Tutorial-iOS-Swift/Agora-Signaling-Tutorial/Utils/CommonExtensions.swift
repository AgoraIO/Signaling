//
//  CommonExtensions.swift
//  OpenVideoCall
//
//  Created by ZhangJi on 22/08/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        func transform(_ input: Int, offset: Int = 0) -> CGFloat {
            let value = (input >> offset) & 0xff
            return CGFloat(value) / 255
        }
        
        self.init(red: transform(hex, offset: 16),
                  green: transform(hex, offset: 8),
                  blue: transform(hex),
                  alpha: alpha)
    }
    
    static func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        
        let color = UIColor.init(red:red, green:green, blue:blue , alpha: 1)
        
        return color
    }
}

extension CGSize {
    func fixedSize(with reference: CGSize) -> CGSize {
        if reference.width > reference.height {
            return fixedLandscapeSize()
        } else {
            return fixedPortraitSize()
        }
    }
    
    func fixedLandscapeSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width < height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }
    
    func fixedPortraitSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width > height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }
    
    func fixedSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width < height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }
}
