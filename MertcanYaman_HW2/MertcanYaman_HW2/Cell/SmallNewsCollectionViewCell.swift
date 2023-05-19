//
//  SmallNewsCollectionViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 15.05.2023.
//

import UIKit

class SmallNewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sectionLabelBack: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var smallImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ newsPreview: NewsPreview) {
        setShadow()
        setBorder(newsPreview.section.getColor())
        
        self.titleLabel.text = newsPreview.title
        authorName.text = newsPreview.author
        sectionLabelBack.backgroundColor = UIColor(hexString: newsPreview.section.getColor())
        sectionLabel.text = newsPreview.section.rawValue.capitalized
        guard let imageUrl = URL(string: newsPreview.smalImageName) else { return }
        self.smallImageView.sd_setImage(with: imageUrl)
    }
    
    private func setShadow() {
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.8
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 1.5
    }
    
    private func setBorder(_ color: String) {
        smallImageView.layer.borderWidth = 1
        smallImageView.layer.borderColor = UIColor(hexString: color).cgColor
    }
}
