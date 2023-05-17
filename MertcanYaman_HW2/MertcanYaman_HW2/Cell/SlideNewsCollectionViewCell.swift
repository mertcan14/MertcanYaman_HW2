//
//  SlideNewsCollectionViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 13.05.2023.
//

import UIKit
import SDWebImage

class SlideNewsCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var sectionView: SectionView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ newsPreview: NewsPreview, left: Bool, right: Bool) {
        self.titleLabel.text = newsPreview.title
        sectionView.setup(newsPreview.section)
        guard let imageUrl = URL(string: newsPreview.largeImageName) else { return }
        self.newsImageView.sd_setImage(with: imageUrl)
        if left {
            leftArrow.isHidden = false
        }else {
            leftArrow.isHidden = true
        }
        if right {
            rightArrow.isHidden = false
        }else {
            rightArrow.isHidden = true
        }
    }
}
