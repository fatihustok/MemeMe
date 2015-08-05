//
//  Meme.swift
//  MemeFatihApp
//
//  Created by Refik Fatih Ustok on 5/08/15.
//  Copyright (c) 2015 Refik Fatih Ustok. All rights reserved.
//

import Foundation
import UIKit
class Meme{
    var topText:String!
    var bottomText:String!
    var image: UIImage! //Original Image
    var memedImage: UIImage! //The generated image with Top and bottom text.
    
    init(let topText:String,let bottomText:String, let image:UIImage, let memedImage:UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
    
}