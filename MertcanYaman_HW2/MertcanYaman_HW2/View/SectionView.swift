//
//  SectionView.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 14.05.2023.
//

import UIKit

class SectionView: UIView {
    private var view: UIView!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(_ section: String, backgroundColor: UIColor) {
        self.configureView()
        outerView.backgroundColor = backgroundColor
        sectionLabel.text = section.uppercased()
    }
    
    private func configureView() {
        guard let nibView = loadViewFromNib() else {return }
        containerView = view
        bounds = nibView.frame
        addSubview(nibView)
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        return view
    }
}
