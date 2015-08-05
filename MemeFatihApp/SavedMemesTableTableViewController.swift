//
//  SavedMemesTableTableViewController.swift
//  MemeFatihApp
//
//  Created by Refik Fatih Ustok on 5/08/15.
//  Copyright (c) 2015 Refik Fatih Ustok. All rights reserved.
//

import UIKit

class SavedMemesTableViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    var plusButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        plusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "AddNewMeme")
        editButton = UIBarButtonItem(title: "Delete", style: .Done, target: self, action: "delete")
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.leftBarButtonItem = editButton
        updateMemes()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.editing = false
        self.tableView.reloadData() // Reload Data so if a delete was done to get the new data.
    }
    
    //Load the memes from App Delegate
    func updateMemes(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Asks the data source whether a given row can be moved to another location in the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true}
    
    //Setup the display of the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        let savedmemes = self.memes[indexPath.row]
        
        cell.textLabel?.text = savedmemes.topText
        cell.imageView?.image = savedmemes.memedImage
        return cell
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        detailController.memeSelected = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //For deleting the Meme
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes.removeAtIndex(indexPath.row)
        
        applicationDelegate.memes = memes
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func delete(){
        self.editing = !self.editing
    }
    
    func AddNewMeme(){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("BackToEditor", sender: self)
        
    }
    
    
    //On select display the Meme in Meme Detail View
    //        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
    //            detailController.meme   = self.memes[indexPath.row]
    
    //            self.navigationController!.pushViewController(detailController, animated: true)
    //        }
    
    //        override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    //            var itemToMove = memes[fromIndexPath.row]
    //            memes.removeAtIndex(fromIndexPath.row)
    //            memes.insert(itemToMove, atIndex: toIndexPath.row)
    //        }
    
    //        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //            if segue.identifier == "anotherMeme"{
    //                if let a = segue.destinationViewController as? EditorViewController{
    //                    //Reset Editor View.
    //                    let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    //                    applicationDelegate.editorMeme = Meme(topText: "TOP", bottomText: "BOTTOM", image: UIImage(), memedImage: UIImage())
    //                }
    //            }
    //        }
    
}
