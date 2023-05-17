//
//  NewsCollectionViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 13.05.2023.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ newsPreview: NewsPreview) {
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.2
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 12
        self.titleLabel.text = newsPreview.title
        self.sectionLabel.text = newsPreview.section.rawValue.uppercased()
        guard let imageUrl = URL(string: newsPreview.largeImageName) else { return }
        self.newsImageView.sd_setImage(with: imageUrl)
    }
}
