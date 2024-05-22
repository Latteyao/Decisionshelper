//
//  tableView.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/5/22.
//

import Foundation
import UIKit

protocol tableViewController:UITableViewDataSource, UITableViewDelegate{
  var array:[String] {get set}
  var arrayDidChange: (([String]) -> Void)? {get set}
  var tableView:UITableView {get}
  
//  func setNavigation()
  func setTableView()
  func addItem()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
}

