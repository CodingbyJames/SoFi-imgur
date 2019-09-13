//
//  CustomImgurCell.swift
//  SoFi-imgur
//
//  Created by James Garcia-Bengochea on 9/12/19.
//  Copyright © 2019 James Garcia-Bengochea. All rights reserved.
//

import UIKit
//created custom cell to display the images and titles in a somewhat legible fashion
class CustomImgurCell: UITableViewCell {
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imgurImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
