//
//  Result.swift
//  SoFi-imgur
//
//  Created by James Garcia-Bengochea on 9/12/19.
//  Copyright © 2019 James Garcia-Bengochea. All rights reserved.
//

import Foundation
import UIKit
//made this class to store the alamofire results as an array of 'result'
class Result {
    var title: String
    var imageURL: String
    
    init(title: String, imageURL: String) {
        self.title = title
        self.imageURL = imageURL
    }
}
