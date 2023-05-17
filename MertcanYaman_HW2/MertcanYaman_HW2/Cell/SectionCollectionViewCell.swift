//
//  SectionCollectionViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 17.05.2023.
//

import UIKit
import NewsAPI

class SectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ sectionName: Section, backgroundColor: String, isSelected: Bool) {
        self.sectionName.text = sectionName.rawValue
        outerView.backgroundColor = UIColor(hexString: backgroundColor)
        selectedImage.isHidden = isSelected
    }
}
