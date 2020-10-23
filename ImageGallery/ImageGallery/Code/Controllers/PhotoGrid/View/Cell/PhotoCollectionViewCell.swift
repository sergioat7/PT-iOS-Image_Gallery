//
//  PhotoCollectionViewCell.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 23/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import Kingfisher

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
        
        if let image = photoCellViewModel?.imageUrl, let imageUrl = URL(string: image) {
            
            ivPhoto.kf.indicatorType = .activity
            ivPhoto.kf.setImage(with: imageUrl)
        } else {
            ivPhoto.image = UIImage(named: "noimage")
        }
    }
}
