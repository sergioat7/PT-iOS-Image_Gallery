//
//  PhotoCollectionViewCell.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 23/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var photoCellViewModel: PhotoCellViewModel? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        lbTitle.text = photoCellViewModel?.title
    }
}
