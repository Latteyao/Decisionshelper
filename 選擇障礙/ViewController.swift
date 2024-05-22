//
//  ViewController.swift
//  選擇障礙
//
//  Created by MacBook Pro on 2024/3/13.
//

import UIKit

class ViewController: UIViewController{

  var item:[String] = ListViewController().array
  
  var itemButton:UIButton = {   // item  Button
    let button = UIButton(type: .system)
    button.configuration = button.configurationSet()
    button.buttonCurcleSet(image: UIImage(systemName: "plus"), color: .brown)
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 30
    return button
  }()
  
  var rollButton:UIButton! = {  // roll Button
    let button = UIButton(type: .system)
    button.setTitle("Roll", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 15)
    button.backgroundColor = .black
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 15
    button.layer.masksToBounds = true
    return button
  }()
  
  
  var itemLable:UILabel! = {
    var lable = UILabel(frame: .zero)
    lable.textColor = .black
    lable.textAlignment = .center
    lable.numberOfLines = 1
    lable.text = ""
    lable.translatesAutoresizingMaskIntoConstraints = false
    lable.font = UIFont.systemFont(ofSize: 50)
    return lable
  }()
  
  var messageImage:UIImageView! = {
    var image = UIImage(systemName: "message.fill")
    let imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    imageView.tintColor = .white
    imageView.isOpaque = true
    return imageView
  }()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view.
    view.backgroundColor = .systemPurple
    view.addSubview(messageImage)
    view.addSubview(rollButton)
    view.addSubview(itemLable)
    view.addSubview(itemButton)
//    view.addSubview(bookmarkButton)
    layoutControll()
    buttonsAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    itemLable.text = ""   //reset itemLable
  }
  
  
  deinit{
    print("ViewCorntroller deinit it!!!")
  }

}

//MARK: - LayoutControll
extension ViewController {
  ///Stack view contorll
  func mainStackView() -> UIStackView{
    let vStackView = UIStackView(arrangedSubviews: [
      messageImage,
      rollButton
    ])
    vStackView.axis = .vertical
    vStackView.spacing = 20
    return vStackView
  }
  
  /// Layout position Controll
  func layoutControll(){
    NSLayoutConstraint.activate([
      
      messageImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
      messageImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35),
      messageImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      messageImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      
     
      rollButton.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: messageImage.bottomAnchor, multiplier: 7),
      rollButton.leadingAnchor.constraint(equalTo: self.messageImage.leadingAnchor,constant: 40),
      rollButton.trailingAnchor.constraint(equalTo: self.messageImage.trailingAnchor,constant: -40),
      
      itemLable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      itemLable.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -14),
      
      
      itemButton.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: messageImage.bottomAnchor, multiplier: 23),
      itemButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -30),
      itemButton.heightAnchor.constraint(equalToConstant: 60),
      itemButton.widthAnchor.constraint(equalToConstant: 60),
      
//      bookmarkButton.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: messageImage.bottomAnchor, multiplier: 25),
//      bookmarkButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -30),
//      bookmarkButton.heightAnchor.constraint(equalToConstant: 50),
//      bookmarkButton.widthAnchor.constraint(equalToConstant: 50),
      
    ])
  }
}

//MARK: - ActionControll
extension ViewController {
  ///For buttons action contorll
  func buttonsAction(){
    rollButton.addTarget(self, action: #selector(rollButtonAction), for: .touchUpInside)
    itemButton.addTarget(self, action: #selector(navigationButton), for: .touchUpInside)
//    bookmarkButton.addTarget(self, action: #selector(checkCount), for: .touchUpInside)
  }
  ///Check item this array count
//  @objc func checkCount(){
//    print(item.count)
//  }
  ///navigation
  @objc func navigationButton(){
    let controller = ListViewController()
    controller.modalPresentationStyle = .fullScreen
    
    controller.arrayDidChange = { [weak self] newArray in // Use Closure transfer
//      SelectItem.items = newArray
      self?.item = newArray
      print("Received new array in closure:" ,newArray)
    }
//    controller.category = category
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  ///roll action controll
  @objc func rollButtonAction(){
//   var elements = UserDefaults.standard.array(forKey: self.category[selectedItem]) as? [String] ?? []
   self.rollButton.animateButton()
   //Fix: - 待修正
   self.itemLable.labelAnimation(text: item.randomElement()?.maxLength(length: 6))
//   item.randomElement()?.maxLength(length: 6)
  }
}

