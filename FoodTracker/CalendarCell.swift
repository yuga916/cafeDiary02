//
//  CalendarCell.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/08.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    var textLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.frame.width, height: self.frame.height)))
        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        textLabel.textAlignment = NSTextAlignment.center
        
        self.layer.cornerRadius = 10
        
        // Cellに追加
        self.addSubview(textLabel!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
//    @IBDesignable class CustomButton: UIButton {
//        
//        // 角丸の半径(0で四角形)
//        @IBInspectable var cornerRadius: CGFloat = 0.0
//        
//        // 枠
//        @IBInspectable var borderColor: UIColor = UIColor.clear
//        @IBInspectable var borderWidth: CGFloat = 0.0
//        
//        override func draw(_ rect: CGRect) {
//            // 角丸
//            self.layer.cornerRadius = cornerRadius
//            self.clipsToBounds = (cornerRadius > 0)
//            
//            // 枠線
//            self.layer.borderColor = borderColor.cgColor
//            self.layer.borderWidth = borderWidth
//            
//            super.draw(rect)
//        }
//    }
    
}
