//
//  SavedMemesCollectionViewController.swift
//  MemeFatihApp
//
//  Created by Refik Fatih Ustok on 5/08/15.
//  Copyright (c) 2015 Refik Fatih Ustok. All rights reserved.
//



import Foundation

import UIKit

class SavedMemeCollectionViewController:  UICollectionViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var memes: [Meme]!
    var plusButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "AddNewMeme")
        editButton = UIBarButtonItem(title: "Delete", style: .Done, target: self, action: "delete")
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.leftBarButtonItem = editButton
        
        self.editing = false
        
        updateMemes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.collectionView?.reloadData()
    }
    
    //Load the memes from App Delegate
    func updateMemes(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Select an cell item. When edit mode is on select deletes the meme. When off, displays Meme Detail View
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let meme = self.memes[indexPath.row]
        
        if(self.editing){// If the edit mode is on display the delete icon.
            cell.deleteImageView.hidden = false
        }else{
            cell.deleteImageView.hidden = true
        }
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    //It is used for deletion and viewing the meme. When in the edit mode we delete the saved Meme on Select.
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        if(!self.editing){//Display Meme
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController")! as! ContentViewController
            detailController.memeSelected   = self.memes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
        }else{//Delete meme
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            memes.removeAtIndex(indexPath.row)
            
            applicationDelegate.memes = memes
            self.collectionView?.reloadData()
        }
    }
    
    //Toggles the edit and reloads the data for the delete icon to be displayed or hid.
    func delete(){
        self.editing = !self.editing
        self.collectionView?.reloadData()
    }
    
    func AddNewMeme(){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("BackToEditorFromCollection", sender: self)
        
    }
    
}
