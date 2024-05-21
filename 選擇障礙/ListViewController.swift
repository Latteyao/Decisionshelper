//
//  ListViewController.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/3/20.
//

import Foundation
import UIKit



class ListViewController:UIViewController{

  var array:[String] = ViewController().item
  var arrayDidChange: (([String]) -> Void)?
  var tableView:UITableView = UITableView()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setNavigation()
    setTableView()
  }
  
  deinit{
    print("ListViewController deinit it!!!")
  }
}

//MARK: - Sub corntroller
extension ListViewController {
  
  func setNavigation(){
    self.navigationItem.title = "Item"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    let add = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(addItem))
    
    let edit = UIBarButtonItem(barButtonSystemItem: .edit,
                                                        target: self,
                                                        action: #selector(editItem))
//    let check = UIBarButtonItem(barButtonSystemItem: .action,
//                                                        target: self,
//                                                        action: #selector(printCount))
    navigationItem.rightBarButtonItems = [edit,add]
    
  }
  @objc func printCount(){
    print(array.count)
  }
  
  func setTableView(){
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: view.topAnchor),
          tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
  }
}
//MARK: - Sub action
extension ListViewController{
  @objc func editItem(){
    tableView.setEditing(!tableView.isEditing, animated: true)
    if tableView.isEditing{
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editItem))
    }else{
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem))
    }
  }
  
  @objc func addItem(){
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
}

//MARK: - tabbleView
extension ListViewController:UITableViewDataSource, UITableViewDelegate{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return array.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let array = array[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = array
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alert = UIAlertController(title: "Edit", message: "Edit TableView Row", preferredStyle: .alert)
    alert.addTextField()
    let update = UIAlertAction(title: "Update", style: .default){ action in
      let textField = alert.textFields![0]
      guard let text = textField.text , text != "" else{ //Fix: - 這裡使用假如處理空字串的問題,或許使用錯誤處理！？
        print("Not Update....")
        return
      }
      self.array[indexPath.row] = text
      self.tableView.reloadData()
      print("Update it !!!!")
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) // set alert cancel
    alert.addAction(update)
    alert.addAction(cancel)
    self.present(alert, animated: true,completion: nil)
  }
  
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: "Delete") { (action , view, success) in
      self.array.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .right)
//      print("Delete : \(self.array.remove(at: indexPath.row).title)")
      self.arrayDidChange?(self.array)
    }
    
    let swipeActions = UISwipeActionsConfiguration(actions: [delete])
    return swipeActions
  }
}

@available(iOS 17.0, *)
  #Preview("aaa"){
    let controller = ListViewController()
    return controller
  
}


