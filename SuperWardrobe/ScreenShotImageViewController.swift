//
//  ScreenShotImageViewController.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import UIKit

class ScreenShotImageViewController: UIViewController {
  static let loginToHomeSegue = "loginToHome"
  
  @IBOutlet weak var screenShotImageView: UIImageView!
  
  var screenShotImage: UIImage!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Shared Screenshot"
    screenShotImageView.image = screenShotImage
  }
}
