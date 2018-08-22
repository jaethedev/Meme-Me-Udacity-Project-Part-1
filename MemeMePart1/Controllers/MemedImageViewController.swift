//
//  MemedImageViewController.swift
//  MemeMePart1
//
//  Created by Jawaune on 8/6/18.
//  Copyright © 2018 jaelong. All rights reserved.
//
//Refer to link below to see what it should look like
//https://docs.google.com/document/d/1G2onkzN_weWmiYErhQJw1lB9-zxM-2TQ0N5bNMAaI7I/pub?embedded=true

import UIKit


class MemedImageViewController: UIViewController {
    
    @IBOutlet weak var meme: UIImageView!
    
    var image: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image != nil {
            meme.contentMode = .scaleAspectFit
            meme.image = image
            
        }
    }
    
}
