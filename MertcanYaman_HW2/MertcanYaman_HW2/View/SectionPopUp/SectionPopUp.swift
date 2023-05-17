//
//  SectionPopUp.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 16.05.2023.
//

import UIKit
import NewsAPI

class SectionPopUp: UIViewController {
    
    var numberOfItemPerRow: CGFloat = 3
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var sections: [Section] = []
    var selectedSections: [Section] = []
    
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backView: UIView!
    
    init() {
        super.init(nibName: "SectionPopUp", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupCollectionViewLayout()
        
        for section in Section.allCases {
            if section != .home {
                sections.append(section)
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goBack))
        backView.addGestureRecognizer(tap)
        
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        sectionCollectionView.register(UINib(nibName: "SectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SectionCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch UIDevice.current.orientation{
        case .portrait:
            numberOfItemPerRow = 3
        case .landscapeLeft:
            numberOfItemPerRow = 5
        case .landscapeRight:
            numberOfItemPerRow = 5
        default:
            numberOfItemPerRow = 3
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateCollectionViewItemSize()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            self.numberOfItemPerRow = 5
        } else {
            self.numberOfItemPerRow = 3
        }
    }
    
    @objc func goBack() {
        hide()
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        hide()
        if selectedSections.count != 0 {
            NotificationCenter.default.post(name: Notification.Name("FetchSections"), object: nil, userInfo: ["section": selectedSections])
        }
    }
    
    func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.2) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    private func setupCollectionViewLayout() {
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        sectionCollectionView.setCollectionViewLayout(self.collectionViewFlowLayout, animated: true)
    }
    
    private func updateCollectionViewItemSize() {
        let lineSpacing: CGFloat = 0
        let interItemSpacing:CGFloat = 5
        let width = ((self.contentView.frame.width - (self.numberOfItemPerRow - 1) * interItemSpacing)) / self.numberOfItemPerRow
        
        collectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: Int(width))
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = lineSpacing
    }
}

extension SectionPopUp: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sectionCollectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCell", for: indexPath) as! SectionCollectionViewCell
        if selectedSections.contains(sections[indexPath.row]) {
            cell.setup(sections[indexPath.row], backgroundColor: sections[indexPath.row].getColor(), isSelected: false)
        }else {
            cell.setup(sections[indexPath.row], backgroundColor: sections[indexPath.row].getColor(), isSelected: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !selectedSections.contains(sections[indexPath.row]) && selectedSections.count < 3 {
            selectedSections.append(sections[indexPath.row])
        }else {
            if let index = selectedSections.firstIndex(of: sections[indexPath.row]) {
                selectedSections.remove(at: index)
            }
        }
        sectionCollectionView.reloadData()
    }
}
