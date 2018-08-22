 //
 //  SentMemesTableViewController.swift
 //  MemeMePart1
 //
 //  Created by Jawaune on 7/28/18.
 //  Copyright © 2018 jaelong. All rights reserved.
 //
 
 
 import Foundation
 import UIKit
 
 class SentMemesTableViewController: UITableViewController {
    
    
    var memes: [Meme] {
        get {
            return appDelegate.dataModel.memes }
        set {
            appDelegate.dataModel.memes = newValue
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
    }
    var currentRowMemedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.dataModel.loadMemes()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemesCell") as? TableViewCell else { return UITableViewCell()}
        cell.customImageView?.image = memes[indexPath.row].memedImage
        cell.customLabel?.text = memes[indexPath.row].combinedText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Removes meme from all 3 places.
        guard var urls = DataModel.memes else { return }
        let indexPaths = [indexPath]
        try? FileManager.default.removeItem(at: urls[indexPath.row])
        memes.remove(at: indexPath.row)
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableToMeme" {
            
            //Pass image to the meme view when the cell is tapped.
            if let indexPath = tableView.indexPathForSelectedRow {
                let image = memes[indexPath.row].memedImage
                guard let controller = segue.destination as? MemedImageViewController else { return }
                controller.image = image
            }
        }
    }
 }
 
