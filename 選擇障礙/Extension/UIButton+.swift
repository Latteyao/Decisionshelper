//
//  UIButton+.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/3/20.
//

import Foundation
import UIKit

extension UIButton{
  
  ///configurationSet
  func configurationSet() -> UIButton.Configuration{
    var configuration = UIButton.Configuration.plain()
    configuration.cornerStyle = .large
    configuration.buttonSize = .medium
    configuration.baseForegroundColor = .white
    return configuration
  }
  
  ///buttonCurcleSet
  func buttonCurcleSet(image:UIImage?,color:UIColor?){
    self.setImage(image, for: .normal)
    self.backgroundColor = color
    self.translatesAutoresizingMaskIntoConstraints = false
    self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    self.layer.cornerRadius = 0.5 * self.bounds.size.width
    self.clipsToBounds = true
  }
  
  func animateButton(){
    UIView.animate(withDuration: 0.3) {
      self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    } completion: { _ in
      UIView.animate(withDuration: 0.3) {
        self.transform = CGAffineTransform.identity
      }
    }
  }
}
