//
//  BookmarkListViewController.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import UIKit
import CoreData

class BookmarkListViewController: UIViewController {
  static let bookmarkListToScreenShotImageSegue = "bookmarkListToScreenShotImage"

  @IBOutlet weak var collectionView: UICollectionView!
  
  lazy var bookmarkFetchedResultsController: NSFetchedResultsController = {
    [unowned self] in
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: "Bookmark")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordID", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    controller.delegate = self
    return controller
    }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Selected Pairs"
    registerNib()
    
    var error: NSError? = nil
    if !bookmarkFetchedResultsController.performFetch(&error) {
      println(error?.localizedDescription)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if segue.identifier == self.dynamicType.bookmarkListToScreenShotImageSegue {
      let screenShotImageVC = segue.destinationViewController as! ScreenShotImageViewController
      let image = sender as! UIImage
      screenShotImageVC.screenShotImage = image
    }
  }
  
  // MARK: - Private methods
  private func registerNib() {
    let nib = UINib(nibName: "BookmarkCollectionViewCell", bundle: nil)
    collectionView.registerNib(nib, forCellWithReuseIdentifier: "bookmarkCollectionViewCell")
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension BookmarkListViewController: NSFetchedResultsControllerDelegate {
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDatasource
extension BookmarkListViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return bookmarkFetchedResultsController.fetchedObjects?.count ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let bookmark = bookmarkFetchedResultsController.objectAtIndexPath(indexPath) as! Bookmark
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bookmarkCollectionViewCell", forIndexPath: indexPath) as! BookmarkCollectionViewCell
    cell.upperWearImageView.image = UIImage(data: bookmark.upperWear.image)
    cell.lowerWearImageView.image = UIImage(data: bookmark.lowerWear.image)
    cell.delegate = self
    
    return cell
  }
}

// MARK: - 
extension BookmarkListViewController: BookmarkCollectionViewCellDelegate {
  func shareButtonPressedForCell(cell: BookmarkCollectionViewCell) {
    cell.shareButton.hidden = true
    if UIScreen.mainScreen().respondsToSelector("scale") {
      UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, UIScreen.mainScreen().scale)
    }
    else {
      UIGraphicsBeginImageContext(cell.bounds.size)
    }

    cell.layer.renderInContext(UIGraphicsGetCurrentContext())
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    cell.shareButton.hidden = false
    
    let imageData = UIImagePNGRepresentation(image)
    if imageData != nil {
      performSegueWithIdentifier(self.dynamicType.bookmarkListToScreenShotImageSegue, sender: image)
    }
    else {
      let alertView = UIAlertView(title: "Error", message: "Error while taking screen shot", delegate: nil, cancelButtonTitle: "Ok")
      alertView.show()
    }
  }
}