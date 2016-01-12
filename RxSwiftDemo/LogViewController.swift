//
//  LogViewController.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/11.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift


let minUsernameLength = 5
let minPasswordLength = 5

class LogViewController: UIViewController {
  
  var usernameLabel: UILabel!
  var usernameTF: UITextField!
  var usernameValidLabel: UILabel!
  
  var passwordLabel: UILabel!
  var passwordTF: UITextField!
  var passwordValidLabel: UILabel!
  
  var doSomethingButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    setupUI()
    
    let usernameValid = usernameTF.rx_text
      .map { $0.characters.count >= minUsernameLength }
    
    
    let passwordValid = passwordTF.rx_text
      .map { $0.characters.count >= minPasswordLength }
    
    
    let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
    usernameValid.bindTo(passwordTF.rx_enabled).addDisposableTo(disposeBag)
    usernameValid.bindTo(usernameValidLabel.rx_hidden).addDisposableTo(disposeBag)
    
    passwordValid.bindTo(passwordValidLabel.rx_hidden).addDisposableTo(disposeBag)

    everythingValid.bindTo(doSomethingButton.rx_enabled).addDisposableTo(disposeBag)
    everythingValid.subscribeNext {
      if $0 {
          self.doSomethingButton.backgroundColor = UIColor.yellowColor()
      } else {
          self.doSomethingButton.backgroundColor = UIColor.greenColor()
      }
    }.addDisposableTo(disposeBag)
    doSomethingButton.rx_tap.subscribeNext {
      self.showAlert()
      }.addDisposableTo(disposeBag)
  }
  
  func showAlert() {
    let alert = UIAlertView(title: "Log",
                            message: "Wonderful",
                            delegate: nil,
                            cancelButtonTitle: "OK")
    alert.show()
  }
  
  func setupUI() {
    usernameLabel = UILabel()
    usernameLabel.text = "Username"
    view.addSubview(usernameLabel)
    
    usernameTF = UITextField()
    usernameTF.placeholder = "  Enter Username"
    usernameTF.layer.borderWidth = 1
    usernameTF.layer.borderColor = UIColor.grayColor().CGColor
    usernameTF.layer.cornerRadius = 6
    view.addSubview(usernameTF)
    
    usernameValidLabel = UILabel()
    usernameValidLabel.text = "Username has to be at least \(minUsernameLength) characters"
    usernameValidLabel.font = UIFont.systemFontOfSize(15)
    view.addSubview(usernameValidLabel)
    
    passwordLabel = UILabel()
    passwordLabel.text = "Password"
    view.addSubview(passwordLabel)
    
    passwordTF = UITextField()
    passwordTF.placeholder = "  Enter Password"
    passwordTF.layer.borderWidth = 1
    passwordTF.layer.borderColor = UIColor.grayColor().CGColor
    passwordTF.layer.cornerRadius = 6
    passwordTF.secureTextEntry = true
    view.addSubview(passwordTF)
    
    passwordValidLabel = UILabel()
    passwordValidLabel.text = "Password has to be at least \(minPasswordLength) characters"
    passwordValidLabel.font = UIFont.systemFontOfSize(15)
    view.addSubview(passwordValidLabel)
    
    doSomethingButton = UIButton(type: .Custom)
    doSomethingButton.setTitle("Login", forState: .Normal)
    doSomethingButton.setTitle("Do Something", forState: .Disabled)
    doSomethingButton.backgroundColor = UIColor.greenColor()
    doSomethingButton.layer.cornerRadius = 6
    view.addSubview(doSomethingButton)
    
    usernameLabel.snp_makeConstraints { make in
      make.top.equalTo(view).offset(84)
      make.left.equalTo(view).offset(15)
      make.height.equalTo(17)
    }
    
    usernameTF.snp_makeConstraints { make in
      make.top.equalTo(usernameLabel.snp_bottom).offset(8)
      make.leading.equalTo(usernameLabel)
      make.right.equalTo(view).offset(-15)
      make.height.equalTo(30)
    }
    
    usernameValidLabel.snp_makeConstraints{ make in
      make.top.equalTo(usernameTF.snp_bottom).offset(8)
      make.leading.equalTo(usernameTF)
      make.height.equalTo(15)
      make.right.equalTo(usernameTF.snp_right)
    }
    
    passwordLabel.snp_makeConstraints { make in
      make.top.equalTo(usernameValidLabel.snp_bottom).offset(25)
      make.leading.equalTo(usernameValidLabel)
      make.height.equalTo(usernameLabel.snp_height)
    }
    
    passwordTF.snp_makeConstraints { make in
      make.top.equalTo(passwordLabel.snp_bottom).offset(8)
      make.leading.equalTo(passwordLabel)
      make.width.equalTo(usernameTF)
      make.height.equalTo(usernameTF)
    }
    
    passwordValidLabel.snp_makeConstraints { make in
      make.top.equalTo(passwordTF.snp_bottom).offset(8)
      make.leading.equalTo(passwordTF)
      make.height.equalTo(usernameValidLabel)
      make.right.equalTo(usernameValidLabel)
    }
    
    doSomethingButton.snp_makeConstraints { make in
      make.top.equalTo(passwordValidLabel.snp_bottom).offset(20)
      make.leading.equalTo(passwordValidLabel)
      make.trailing.equalTo(passwordTF)
      make.height.equalTo(40)
    }
    
    
    
  }
}
