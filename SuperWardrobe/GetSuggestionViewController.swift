//
//  GetSuggestionViewController.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import UIKit
import CoreData

class GetSuggestionViewController: UIViewController {

  @IBOutlet weak var upperWearImageView: UIImageView!
  @IBOutlet weak var lowerWearImageView: UIImageView!
  
  var upperWearFetchedResultsController: NSFetchedResultsController!
  var lowerWearFetchedResultsController: NSFetchedResultsController!
  
  var currentUpperWear: UpperWear!
  var currentLowerWear: LowerWear!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
    
    let images = getRandomImages()
    setImages(images.0, lowerWearImage: images.1)
  }
  
  func bookmarkButtonPressed() {
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let entity = NSEntityDescription.entityForName("Bookmark", inManagedObjectContext: managedContext!)
    let bookmark = Bookmark(entity: entity!, insertIntoManagedObjectContext: managedContext!)

    bookmark.upperWear = currentUpperWear
    bookmark.lowerWear = currentLowerWear
    
    var alertTitle = "Success"
    var alertMessage = "Bookmarked your pair successfully."
    var error: NSErrorPointer = nil
    if !bookmark.managedObjectContext!.save(error) {
      alertTitle = "Failure"
      alertMessage = "Unable to save managed object context.\n\(error)"
    }
    
    let alertView = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: "Ok")
    alertView.show()
  }
  
  func dislikeButtonPressed() {
    let images = getRandomImages()
    setImages(images.0, lowerWearImage: images.1)
  }
  
  // MARK: - Private methods
  private func setNavigationBar() {
    let bookmarkBarButton = UIBarButtonItem(image: UIImage(named: "bookmark"), style: UIBarButtonItemStyle.Plain, target: self, action: "bookmarkButtonPressed")
    let unlikeBarButton = UIBarButtonItem(image: UIImage(named: "dislike"), style: UIBarButtonItemStyle.Plain, target: self, action: "dislikeButtonPressed")
    navigationItem.rightBarButtonItems = [bookmarkBarButton, unlikeBarButton]
    
    navigationItem.title = "Suggested Pair"
  }
  
  private func getRandomImages() -> (UIImage, UIImage) {
    let firstNumber = Int(rand()) % (upperWearFetchedResultsController.fetchedObjects?.count ?? 1)
    let secondNumber = Int(rand()) % (lowerWearFetchedResultsController.fetchedObjects?.count ?? 1)
    
    let firstIndexPath = NSIndexPath(forRow: firstNumber, inSection: 0)
    let secondIndexPath = NSIndexPath(forRow: secondNumber, inSection: 0)
    
    currentUpperWear = upperWearFetchedResultsController.objectAtIndexPath(firstIndexPath) as! UpperWear
    currentLowerWear = lowerWearFetchedResultsController.objectAtIndexPath(secondIndexPath) as! LowerWear
    
    return (UIImage(data: currentUpperWear.image)!, UIImage(data: currentLowerWear.image)!)
  }
  
  private func setImages(upperWearImage: UIImage , lowerWearImage: UIImage) {
    upperWearImageView.image = upperWearImage
    lowerWearImageView.image = lowerWearImage
  }
}

// MARK: - UIAlertView delegate 
extension GetSuggestionViewController: UIAlertViewDelegate {
  func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
    navigationController?.popViewControllerAnimated(true)
  }
}
