//
//  SlideNewsCollectionViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 13.05.2023.
//

import UIKit

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
        sectionView.setup(newsPreview.section, backgroundColor: UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1))
        if left {
            leftArrow.isHidden = false
            self.newsImageView.image = UIImage(named: "haber1")
        }else {
            leftArrow.isHidden = true
            self.newsImageView.image = UIImage(named: "haber2")
        }
        if right {
            rightArrow.isHidden = false
        }else {
            rightArrow.isHidden = true
            self.newsImageView.image = UIImage(named: "haber3")
        }
    }
}
