//
//  ImageViewController.swift
//  SoFi-imgur
//
//  Created by James Garcia-Bengochea on 9/12/19.
//  Copyright © 2019 James Garcia-Bengochea. All rights reserved.
//

import UIKit
import SDWebImage


class ImageViewController: UIViewController {
    //variable for url
    var imageURL: String = ""
    // image view
    @IBOutlet weak var imageResult: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads image into view
        imageResult.sd_setImage(with: URL(string: imageURL))
    }
}
