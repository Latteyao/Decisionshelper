//
//  ListViewController.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/3/20.
//

import Foundation
import UIKit

class ListViewController: UIViewController, tableViewController {
  var category: [String] = UserDefaults.standard.array(forKey: "defaultCategoryKey") as? [String] ?? ["Default"]
  var array: [String] = UserDefaults.standard.array(forKey: "defaultCategoryElements") as? [String] ?? []
  var selectedItem: Int = UserDefaults.standard.integer(forKey: "listIndex")
  var arrayDidChange: (([String]) -> Void)? // 或許不用！？
  var tableView: UITableView = .init()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setNavigation()
    setTableView()
  }

  deinit {
    print("ListViewController deinit it!!!")
  }
}

// MARK: - Sub corntroller

extension ListViewController {
  func setNavigation() {
    navigationItem.title = "Item"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.setNavigationBarHidden(false, animated: false)

    let add = UIBarButtonItem(barButtonSystemItem: .add,
                              target: self,
                              action: #selector(addItem))
    let editElement = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(editElement))

//    let edit = UIBarButtonItem(barButtonSystemItem: .edit,
//                                                        target: self,
//                                                        action: #selector(editItem))
//    let check = UIBarButtonItem(barButtonSystemItem: .action,
//                                                        target: self,
//                                                        action: #selector(printCount))
    navigationItem.rightBarButtonItems = [ /* edit, */ add, editElement]
  }

  @objc func printCount() {
    print(array.count)
  }

  func setTableView() {
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.allowsSelection = true

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
  }
}

// MARK: - Sub action

extension ListViewController {
  @objc func editElement() {
    let elements: [String] = UserDefaults.standard.array(forKey: category[selectedItem]) as? [String] ?? []
    
    let sheet = ElementViewController(category: category[selectedItem],array: elements)
    sheet.arrayDidChange = { [weak self] newArray in
      guard let elementsKey = self?.category[self?.selectedItem ?? 0] else { return }
      print("Data: \(newArray)")
      UserDefaults.standard.setValue(newArray, forKey: elementsKey)
    }
    sheet.modalPresentationStyle = .pageSheet
    if let sheet = sheet.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = 20
    }
    present(sheet, animated: true)
  }

//  @objc func editItem(){
//    tableView.setEditing(!tableView.isEditing, animated: true)
//    if tableView.isEditing{
//      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editItem))
//    }else{
//      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem))
//    }
//  }

  @objc func addItem() {
    let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
    alert.addTextField()
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) // set alert cancel
    alert.addAction(creatCategoryButton(alert: alert))
    alert.addAction(cancelButton())
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - Sub alert action

extension ListViewController {
  func creatCategoryButton(alert: UIAlertController) -> UIAlertAction {
    let done = UIAlertAction(title: "Done", style: .default) { _ in
      let textField = alert.textFields![0]
      self.category.append(textField.text!)
      self.tableView.reloadData()
      print("New Data: \(self.category.last ?? "")")
      UserDefaults.standard.set(self.category, forKey: "defaultCategoryKey")
      print(UserDefaults.standard.stringArray(forKey: "defaultCategoryKey") ?? [""])
//      self.arrayDidChange?(self.category)
    } // set alert ok
    return done
  }

  func cancelButton() -> UIAlertAction {
    UIAlertAction(title: "Cancel", style: .cancel)
  }
}

// MARK: - Sub tabbleView

extension ListViewController {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return category.count
//    return array.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let array = category[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.accessoryType = (selectedItem == indexPath.row) ? .checkmark : .none
    cell.textLabel?.text = array
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    guard selectedItem != indexPath.row else { return }
    selectedItem = indexPath.row
    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    UserDefaults.standard.setValue(selectedItem, forKey: "listIndex")
    array = UserDefaults.standard.array(forKey: category[selectedItem]) as? [String] ?? []
    UserDefaults.standard.setValue(array, forKey: "defaultCategoryElements")
    
    self.arrayDidChange?(array)
    tableView.reloadData()
    print("Fouse set \(selectedItem)")
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
      let alert = UIAlertController(title: "Delete", message: "Are you sure delete \(self.category[indexPath.row])", preferredStyle: .actionSheet)
      let alertDelete = UIAlertAction(title: "Delete", style: .destructive) { _ in
        self.category.remove(at: indexPath.row)
        if indexPath.row == 0 {
          self.selectedItem = 0
          UserDefaults.standard.set(self.selectedItem, forKey: "listIndex")
          UserDefaults.standard.setValue(UserDefaults.standard.array(forKey: self.category[self.selectedItem]) as? [String] ?? [], forKey: "defaultCategoryElements")
          self.array = UserDefaults.standard.array(forKey: self.category[self.selectedItem]) as? [String] ?? []
          print("Fouse set \(self.selectedItem)")
        } else {
          self.selectedItem -= 1
          UserDefaults.standard.set(self.selectedItem, forKey: "listIndex")
          UserDefaults.standard.setValue(UserDefaults.standard.array(forKey: self.category[self.selectedItem]) as? [String] ?? [], forKey: "defaultCategoryElements")
          self.array = UserDefaults.standard.array(forKey: self.category[self.selectedItem]) as? [String] ?? []
          print("Fouse set \(self.selectedItem)")
        }

        self.tableView.performBatchUpdates {
          self.tableView.deleteRows(at: [indexPath], with: .top)
        } completion: { _ in
          UserDefaults.standard.set(self.category, forKey: "defaultCategoryKey")
          self.tableView.reloadData()
        }
        self.arrayDidChange?(self.array)
      }

      alert.addAction(self.cancelButton())
      alert.addAction(alertDelete)
      self.present(alert, animated: true, completion: nil)
    }

    let swipeActions = UISwipeActionsConfiguration(actions: [delete])
    self.tableView.reloadData()
    return swipeActions
  }

  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
      let alert = UIAlertController(title: "Edit", message: "Edit List Row", preferredStyle: .alert)
      alert.addTextField()
      let update = UIAlertAction(title: "Update", style: .default) { _ in
        let textField = alert.textFields![0]
        guard let text = textField.text, text != "" else { // Fix: - 這裡使用假如處理空字串的問題,或許使用錯誤處理！？
          print("Not Update....")
          return
        }
        self.category[indexPath.row] = text
//        self.array[indexPath.row] = text
        self.tableView.reloadData()
        print("Update it !!!!")
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel) // set alert cancel
      alert.addAction(cancel)
      alert.addAction(update)

      self.present(alert, animated: true, completion: nil)
    }
    edit.backgroundColor = UIColor(red: 255/255.0, green: 128.0/255.0, blue: 0.0, alpha: 1.0)
    let swipeActions = UISwipeActionsConfiguration(actions: [edit])
    return swipeActions
  }
}

@available(iOS 17.0, *)
#Preview("aaa") {
  let controller = ListViewController()
  return controller
}
