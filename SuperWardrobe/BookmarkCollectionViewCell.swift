//
//  BookmarkCollectionViewCell.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import UIKit

protocol BookmarkCollectionViewCellDelegate {
  func shareButtonPressedForCell(cell: BookmarkCollectionViewCell)
}

class BookmarkCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var upperWearImageView: UIImageView!
  @IBOutlet weak var lowerWearImageView: UIImageView!
  @IBOutlet weak var shareButton: UIButton!
  
  var delegate: BookmarkCollectionViewCellDelegate?
  
  @IBAction func shareButtonPressed(sender: AnyObject) {
    delegate?.shareButtonPressedForCell(self)
  }
}
