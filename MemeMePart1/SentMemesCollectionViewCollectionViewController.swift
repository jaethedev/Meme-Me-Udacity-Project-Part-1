//
//  SentMemesCollectionViewCollectionViewController.swift
//  MemeMePart1
//
//  Created by Jawaune on 8/6/18.
//  Copyright © 2018 jaelong. All rights reserved.
//Refer to link below to see what it should look like
//https://docs.google.com/document/d/1G2onkzN_weWmiYErhQJw1lB9-zxM-2TQ0N5bNMAaI7I/pub?embedded=true

import UIKit


private let reuseIdentifier = "Cell"

class SentMemesCollectionViewCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var memes: [Meme] {
        get {
            return appDelegate.dataModel.memes }
        set {
            appDelegate.dataModel.memes = newValue
        }
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.dataModel.loadMemes()
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            cell.imageView.image = memes[indexPath.row].memedImage
            return cell
        }
        return collectionView.cellForItem(at: indexPath)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionToMeme" {
            let cell = sender as? UICollectionViewCell
            if let indexPath = self.collectionView.indexPath(for: cell!) {
                let image = memes[indexPath.row].memedImage
                let controller = segue.destination as! MemedImageViewController
                controller.image = image
            }
        }
    }
}
