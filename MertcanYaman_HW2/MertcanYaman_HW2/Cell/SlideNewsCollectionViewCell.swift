//
//  SlideNewsCollectionViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 13.05.2023.
//

import UIKit
import SDWebImage

class SlideNewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var leftView: UIVisualEffectView!
    @IBOutlet weak var rightView: UIVisualEffectView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var sectionView: SectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ newsPreview: NewsPreview, left: Bool, right: Bool) {
        setGestureRecognizer()
        setShadow()
        setViewHidden(left, right)
        
        self.titleLabel.text = newsPreview.title
        sectionView.setup(newsPreview.section)
        guard let imageUrl = URL(string: newsPreview.largeImageName) else { return }
        self.newsImageView.sd_setImage(with: imageUrl)
    }
    
    @objc func goBack()  {
        NotificationCenter.default.post(name: Notification.Name("GoBack"), object: nil)
    }
    
    @objc func goNext() {
        NotificationCenter.default.post(name: Notification.Name("GoNext"), object: nil)
    }
    
    private func setShadow() {
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.8
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 3
    }
    
    private func setGestureRecognizer() {
        let back = UITapGestureRecognizer(target: self, action: #selector(goBack))
        leftImage.addGestureRecognizer(back)
        let next = UITapGestureRecognizer(target: self, action: #selector(goNext))
        rightImage.addGestureRecognizer(next)
    }
    
    private func setViewHidden(_ left: Bool, _ right: Bool) {
        if left {
            leftView.isHidden = false
            leftImage.isHidden = false
        }else {
            leftView.isHidden = true
            leftImage.isHidden = true
        }
        if right {
            rightView.isHidden = false
            rightImage.isHidden = false
        }else {
            rightView.isHidden = true
            rightImage.isHidden = true
        }
    }
}
