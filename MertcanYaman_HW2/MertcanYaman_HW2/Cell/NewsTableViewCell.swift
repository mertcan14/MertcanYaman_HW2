//
//  NewsTableViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 13.05.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    
    func setup(_ newsPreview: NewsPreview) {
        outerView.layer.shadowColor = UIColor.darkGray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 10
        self.titleLabel.text = newsPreview.title
        self.sectionLabel.text = newsPreview.section.uppercased()
        self.newsImageView.image = UIImage(named: "deneme")
    }
}
