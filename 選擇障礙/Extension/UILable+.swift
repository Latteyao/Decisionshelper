//
//  UILable+.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/5/21.
//

import Foundation
import UIKit

extension UILabel {
  func labelAnimation(text:String?){
    let animation:CATransition = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
    animation.type = CATransitionType.push
    animation.subtype = CATransitionSubtype.fromTop
    self.text = text
    animation.duration = 0.25
    self.layer.add(animation, forKey: CATransitionType.push.rawValue)
  }
}
