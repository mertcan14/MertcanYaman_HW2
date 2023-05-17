//
//  SectionTableViewCell.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 16.05.2023.
//

import UIKit
import NewsAPI

class SectionTableViewCell: UITableViewCell {

    var selectedSecitons: [Section] = []
    var unchecked = true
    
    @IBOutlet weak var checkBoxButton: UIImageView!
    @IBOutlet weak var sectionView: SectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let sectionSelect = UITapGestureRecognizer(target: self, action: #selector(selected))
        checkBoxButton.addGestureRecognizer(sectionSelect)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ sectionName: Section, backgroundColor: String) {
        sectionView.setup(sectionName)
    }
    
    @objc func selected() {
        if unchecked {
            checkBoxButton.image = UIImage(named: "Checkmark")
            unchecked = false
        }else {
            checkBoxButton.image = UIImage(named: "Checkmarkempty")
            unchecked = true
        }
    }
}
