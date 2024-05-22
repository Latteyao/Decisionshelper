//
//  itemViewController.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/5/22.
//

import Foundation
import UIKit

class ElementViewController:UIViewController,UITableViewDataSource, UITableViewDelegate{
  var category:String
  var array: [String]
  var fakedata:[String] = ["1","2","3"]

  
  var arrayDidChange: (([String]) -> Void)?
  
  var tableView: UITableView = UITableView()
  
  init(category:String, array: [String]) {
    self.category = category
    self.array = array
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: nil)
    setTableView()
    setNavigation()
    
  }
  
  func setNavigation() {
    let navBar = UINavigationBar()
    navBar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(navBar)
    let navItem = UINavigationItem(title: category)
    let doneItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    navItem.rightBarButtonItem = doneItem
    navBar.setItems([navItem], animated: false)
    NSLayoutConstraint.activate([
                navBar.topAnchor.constraint(equalTo: view.topAnchor),
                navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
  }
  
  func setTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "element")
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
          tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
  }
  
  @objc func addItem() {
    let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
    alert.addTextField()
    let ok = UIAlertAction(title: "Ok", style: .default){ _ in
      let textField = alert.textFields![0]

      self.array.append(textField.text!)
      self.tableView.reloadData()

      print("New Data: \(self.array.last ?? "")")
      self.arrayDidChange?(self.array)
    } // set alert ok
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) // set alert cancel
    alert.addAction(ok)
    alert.addAction(cancel)
    self.present(alert, animated: true,completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return fakedata.count
    return array.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let array = fakedata[indexPath.row]
    let array = array[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "element", for: indexPath)
    cell.textLabel?.text = array
    return cell
  }
  

  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: "Delete") { (action , view, success) in
      print("Delete : \(self.array[indexPath.row])")
      self.array.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .right)

      self.arrayDidChange?(self.array)
    }
    
    let swipeActions = UISwipeActionsConfiguration(actions: [delete])
    return swipeActions
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let edit = UIContextualAction(style: .normal, title: "Edit") { action, view, success in
      let alert = UIAlertController(title: "Edit", message: "Edit TableView Row", preferredStyle: .alert)
      alert.addTextField()
      let update = UIAlertAction(title: "Update", style: .default){ action in
        let textField = alert.textFields![0]
        guard let text = textField.text , text != "" else{ //Fix: - 這裡使用假如處理空字串的問題,或許使用錯誤處理！？
          print("Not Update....")
          return
        }
        self.array[indexPath.row] = text
        self.arrayDidChange?(self.array)
        self.tableView.reloadData()
        print("Update it !!!!")
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel) // set alert cancel
      alert.addAction(update)
      alert.addAction(cancel)
      self.present(alert, animated: true,completion: nil)
    }
    edit.backgroundColor = UIColor(red: 255/255.0, green: 128.0/255.0, blue: 0.0, alpha: 1.0)
    let swipeActions = UISwipeActionsConfiguration(actions: [edit])
    return swipeActions
  }
  
  
  
}

