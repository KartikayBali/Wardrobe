//
//  HomeViewController.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
  
  static let homeToGetSuggestionSegue = "homeToGetSuggestion"
  static let homeToBookmarkListSegue = "homeToBookmarkList"
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  var isUpperWear: Bool {
    return segmentControl.selectedSegmentIndex == 0
  }
  
  lazy var upperFetchedResultsController: NSFetchedResultsController = {
    [unowned self] in
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: "UpperWear")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordID", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    controller.delegate = self
    return controller
  }()
  
  lazy var lowerFetchedResultsController: NSFetchedResultsController = {
    [unowned self] in
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "LowerWear")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordID", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
    controller.delegate = self
    return controller
    }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
    registerNib()
    
    var error: NSError? = nil
    if !upperFetchedResultsController.performFetch(&error) {
      println(error?.localizedDescription)
    }
    if !lowerFetchedResultsController.performFetch(&error) {
      println(error?.localizedDescription)
    }
    
    addItemsReminder()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if segue.identifier == self.dynamicType.homeToGetSuggestionSegue {
      let getSuggestionVC = segue.destinationViewController as! GetSuggestionViewController
      getSuggestionVC.upperWearFetchedResultsController = upperFetchedResultsController
      getSuggestionVC.lowerWearFetchedResultsController = lowerFetchedResultsController
    }
  }
  
  func addButtonPressed() {
    var title = "Select UpperWear"
    if !isUpperWear {
      title = "Select LowerWear"
    }
    
    let optionMenu = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
    
    let cameraAction = UIAlertAction(title: "Take picture", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
      self.takePicture()
    })
    
    let selectFromPhotosAction = UIAlertAction(title: "Select from photos", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
      self.selectFromPhotos()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
      println("Cancelled")
    })
    
    optionMenu.addAction(cameraAction)
    optionMenu.addAction(selectFromPhotosAction)
    optionMenu.addAction(cancelAction)
    
    presentViewController(optionMenu, animated: true, completion: nil)
  }
  
  func showAllBookmarks() {
    performSegueWithIdentifier(self.dynamicType.homeToBookmarkListSegue, sender: nil)
  }
  
  // MARK: - Private Methods
  private func registerNib() {
    let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    collectionView.registerNib(nib, forCellWithReuseIdentifier: "homeCollectionViewCell")
  }
  
  private func setNavigationBar() {
    
    let addBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addButtonPressed")
    let bookmarkBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "showAllBookmarks")
    navigationItem.rightBarButtonItems = [addBarButton, bookmarkBarButton]
    navigationController?.navigationBar.translucent = false
  }
  
  private func takePicture() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    imagePicker.delegate = self
    
    navigationController?.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  private func selectFromPhotos() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    imagePicker.delegate = self
    
    navigationController?.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  private func addItemsReminder() {
    if upperFetchedResultsController.fetchedObjects?.count == 0 || lowerFetchedResultsController.fetchedObjects?.count == 0 {
      let alertView = UIAlertView(title: "Check", message: "Add shirts/tshirts by clicking the + button on the top right corner. To add the jeans, switch to LowerWear tab and then tap on + to add jeans.", delegate: nil, cancelButtonTitle: "Ok")
      alertView.show()
    }
  }
  
  // MARK: - IBActions
  @IBAction func segmentPressed(sender: UISegmentedControl) {
    collectionView.reloadData()
  }
  
  @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
    // Nothing to do here.
    
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDatasource
extension HomeViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if isUpperWear {
      return upperFetchedResultsController.fetchedObjects?.count ?? 0
    }
    return lowerFetchedResultsController.fetchedObjects?.count ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var imageData: NSData!
    if isUpperWear {
      let upperWear = upperFetchedResultsController.objectAtIndexPath(indexPath) as! UpperWear
      imageData = upperWear.image
    }
    else {
      let lowerWear = lowerFetchedResultsController.objectAtIndexPath(indexPath) as! LowerWear
      imageData = lowerWear.image
    }
    
    let image = UIImage(data: imageData)
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("homeCollectionViewCell", forIndexPath: indexPath) as! HomeCollectionViewCell
    cell.imageView.image = image
    
    return cell
  }
}

// MARK: - UINavigationControllerDelegate Methods
extension HomeViewController: UINavigationControllerDelegate {
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false) // To maintain status bar color after using Image Picker
  }
}

// MARK: - UIImagePickerControllerDelegate Methods
extension HomeViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
    var managedObject: NSManagedObject!
    if isUpperWear {
      let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
      let entity = NSEntityDescription.entityForName("UpperWear", inManagedObjectContext: managedContext!)
      let upperWear = UpperWear(entity: entity!, insertIntoManagedObjectContext: managedContext!)
      managedObject = upperWear
      let imageData = UIImagePNGRepresentation(selectedImage)
      upperWear.setValue(imageData, forKey: "image")
    }
    else {
      let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
      let entity = NSEntityDescription.entityForName("LowerWear", inManagedObjectContext: managedContext!)
      let lowerWear = LowerWear(entity: entity!, insertIntoManagedObjectContext: managedContext!)
      managedObject = lowerWear
      let imageData = UIImagePNGRepresentation(selectedImage)
      lowerWear.setValue(imageData, forKey: "image")
    }
    
    var error: NSErrorPointer = nil
    if !managedObject.managedObjectContext!.save(error) {
      println("Unable to save managed object context.\n\(error)")
    }

    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

