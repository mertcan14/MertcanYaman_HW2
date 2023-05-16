//
//  SmallNewsCollectionViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 15.05.2023.
//

import UIKit

class SmallNewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var smallImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ newsPreview: NewsPreview) {
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.2
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 12
        self.titleLabel.text = newsPreview.title
        self.sectionLabel.text = newsPreview.section.uppercased()
        authorName.text = newsPreview.author
        guard let imageUrl = URL(string: newsPreview.smalImageName) else { return }
        self.smallImageView.sd_setImage(with: imageUrl)
    }
}
