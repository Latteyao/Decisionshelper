//
//  String+.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/5/3.
//

import Foundation

extension String {
  func maxLength(length:Int) -> String{
    var string = self
    let nsString = string as NSString
    if nsString.length >= length{
      string = nsString.substring(
        with: NSRange(
        location: 0,
        length: nsString.length > length ? length : nsString.length)
      )
    }
    return string
  }
}
