//
//  ViewController.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  static let loginToHomeSegue = "loginToHome"
  
  @IBOutlet weak var loginButton: FBSDKLoginButton!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
        
    loginButton.readPermissions = ["email", "public_profile"]
    loginButton.delegate = self
  }
  
  @IBAction func loginButtonPressed(sender: AnyObject) {
    let loginManager = FBSDKLoginManager()
    loginManager.logInWithReadPermissions(loginButton.readPermissions, handler: { (result, error) -> Void in
      if error != nil {
        println("Process error ")
      }
      else if result.isCancelled {
        println("Cancelled")
      }
      else {
        println("Logged in")
      }
    })
  }
}

extension ViewController: FBSDKLoginButtonDelegate {
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    performSegueWithIdentifier(self.dynamicType.loginToHomeSegue, sender: nil)
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    
  }
}

