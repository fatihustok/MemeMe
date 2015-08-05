//
//  CollectionViewCell.swift
//  MemeFatihApp
//
//  Created by Refik Fatih Ustok on 5/08/15.
//  Copyright (c) 2015 Refik Fatih Ustok. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet var deleteImageView: UIImageView! //This is the icon for deletion. It displays when the edit button of the view is toggled.
}
