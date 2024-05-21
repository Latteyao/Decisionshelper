//
//  SelectItem.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/3/26.
//

import Foundation
import UIKit

///
struct SelectItem{
  var title:String
  
  init(title: String) {
    self.title = title
    
  }
  
  static var items:[SelectItem] = [
    SelectItem(title: "🍌"),
    SelectItem(title: "🍑"),
    SelectItem(title: "🍉"),
    SelectItem(title: "🍐"),
    SelectItem(title: "🍇")]
}
